package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.Fine;

/**
 * Fine DAO
 * - Handle overdue fine (per-day)
 * - Handle damage fine
 * - Dashboard summary for librarian
 */
public class FineDBContext extends DBContext<Fine> {

    public static final String TYPE_OVERDUE = "OVERDUE";
    public static final String TYPE_DAMAGE = "DAMAGE";

    public static final BigDecimal DEFAULT_OVERDUE_RATE = new BigDecimal("5000");

    @Override
    public ArrayList<Fine> list() {
        return listByStatus("ALL");
    }

    @Override
    public Fine get(int id) {
        String sql = "SELECT f.fine_id, f.reader_id, f.borrow_item_id, f.fine_type_id, ft.name AS fine_type_name, "
                + "f.amount, f.reason, f.status, f.created_at, f.paid_at, f.handled_by_employee_id "
                + "FROM Fine f INNER JOIN Fine_Type ft ON ft.fine_type_id = f.fine_type_id "
                + "WHERE f.fine_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Fine f = new Fine();
                f.setFineId(rs.getInt("fine_id"));
                f.setReaderId(rs.getInt("reader_id"));
                f.setBorrowItemId(rs.getInt("borrow_item_id"));
                f.setFineTypeId(rs.getInt("fine_type_id"));
                f.setFineTypeName(rs.getString("fine_type_name"));
                f.setAmount(rs.getBigDecimal("amount"));
                f.setReason(rs.getString("reason"));
                f.setStatus(rs.getString("status"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                f.setPaidAt(rs.getTimestamp("paid_at"));
                int hb = rs.getInt("handled_by_employee_id");
                f.setHandledByEmployeeId(rs.wasNull() ? null : hb);
                return f;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void insert(Fine model) {
        throw new UnsupportedOperationException("Use createOverdueFine/createDamageFine instead.");
    }

    @Override
    public void update(Fine model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void delete(Fine model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    /**
     * Ensure Fine_Type rows exist:
     * - OVERDUE: per_day_rate = 5000
     * - DAMAGE: default_amount = 0
     */
    public void ensureDefaultFineTypes() {
        try {
            upsertFineType(TYPE_OVERDUE,
                    "Phạt quá hạn (tính theo ngày)",
                    null,
                    DEFAULT_OVERDUE_RATE);

            upsertFineType(TYPE_DAMAGE,
                    "Phạt hư hỏng/mất sách (do thủ thư nhập)",
                    BigDecimal.ZERO,
                    null);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void upsertFineType(String name, String desc, BigDecimal defaultAmount, BigDecimal perDayRate) throws SQLException {
        // If exists -> update missing fields; if not -> insert
        String q = "SELECT fine_type_id FROM Fine_Type WHERE name = ?";
        Integer id = null;
        try (PreparedStatement ps = connection.prepareStatement(q)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) id = rs.getInt(1);
        }
        if (id == null) {
            String ins = "INSERT INTO Fine_Type(name, description, default_amount, per_day_rate) VALUES(?, ?, ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(ins)) {
                ps.setString(1, name);
                ps.setString(2, desc);
                if (defaultAmount == null) ps.setNull(3, java.sql.Types.DECIMAL);
                else ps.setBigDecimal(3, defaultAmount);
                if (perDayRate == null) ps.setNull(4, java.sql.Types.DECIMAL);
                else ps.setBigDecimal(4, perDayRate);
                ps.executeUpdate();
            }
            return;
        }

        String upd = "UPDATE Fine_Type SET "
                + "description = COALESCE(description, ?), "
                + "default_amount = COALESCE(default_amount, ?), "
                + "per_day_rate = COALESCE(per_day_rate, ?) "
                + "WHERE fine_type_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(upd)) {
            ps.setString(1, desc);
            if (defaultAmount == null) ps.setNull(2, java.sql.Types.DECIMAL);
            else ps.setBigDecimal(2, defaultAmount);
            if (perDayRate == null) ps.setNull(3, java.sql.Types.DECIMAL);
            else ps.setBigDecimal(3, perDayRate);
            ps.setInt(4, id);
            ps.executeUpdate();
        }
    }

    public Integer getFineTypeIdByName(String typeName) {
        String sql = "SELECT fine_type_id FROM Fine_Type WHERE name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, typeName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public BigDecimal getOverdueRate() {
        String sql = "SELECT TOP 1 per_day_rate FROM Fine_Type WHERE name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, TYPE_OVERDUE);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal r = rs.getBigDecimal(1);
                if (r != null) return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return DEFAULT_OVERDUE_RATE;
    }

    /**
     * Refresh overdue fines for all Borrow_Item that are overdue and not yet returned.
     * - Create UNPAID fine if missing
     * - Update amount daily = overdueDays * rate
     */
    public void refreshOverdueFinesForBorrowingItems() {
        ensureDefaultFineTypes();

        Integer overdueTypeId = getFineTypeIdByName(TYPE_OVERDUE);
        if (overdueTypeId == null) return;

        BigDecimal rate = getOverdueRate();

        // OverdueDays calculated by date boundary (CAST to date)
        String sql = "SELECT bi.borrow_item_id, b.reader_id, "
                + "CASE WHEN CAST(SYSDATETIME() AS date) > CAST(bi.due_date AS date) "
                + "THEN DATEDIFF(day, CAST(bi.due_date AS date), CAST(SYSDATETIME() AS date)) ELSE 0 END AS overdue_days "
                + "FROM Borrow_Item bi "
                + "INNER JOIN Borrow b ON b.borrow_id = bi.borrow_id "
                + "WHERE bi.returned_at IS NULL AND CAST(SYSDATETIME() AS date) > CAST(bi.due_date AS date)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int borrowItemId = rs.getInt("borrow_item_id");
                int readerId = rs.getInt("reader_id");
                int days = rs.getInt("overdue_days");
                if (days <= 0) continue;
                BigDecimal amount = rate.multiply(new BigDecimal(days));
                upsertUnpaidFine(readerId, borrowItemId, overdueTypeId, amount,
                        "Quá hạn " + days + " ngày (" + rate.toPlainString() + "/ngày)");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Create/update unpaid fine row for the given borrow_item + type.
     * If an UNPAID fine exists -> update amount & reason.
     * Else -> insert new UNPAID fine.
     */
    public void upsertUnpaidFine(int readerId, int borrowItemId, int fineTypeId, BigDecimal amount, String reason) throws SQLException {
        String q = "SELECT TOP 1 fine_id FROM Fine WHERE reader_id = ? AND borrow_item_id = ? AND fine_type_id = ? AND status = N'UNPAID'";
        Integer fineId = null;
        try (PreparedStatement ps = connection.prepareStatement(q)) {
            ps.setInt(1, readerId);
            ps.setInt(2, borrowItemId);
            ps.setInt(3, fineTypeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) fineId = rs.getInt(1);
        }

        if (fineId == null) {
            String ins = "INSERT INTO Fine(reader_id, borrow_item_id, fine_type_id, amount, reason, status, created_at, paid_at, handled_by_employee_id) "
                    + "VALUES(?, ?, ?, ?, ?, N'UNPAID', SYSDATETIME(), NULL, NULL)";
            try (PreparedStatement ps = connection.prepareStatement(ins)) {
                ps.setInt(1, readerId);
                ps.setInt(2, borrowItemId);
                ps.setInt(3, fineTypeId);
                ps.setBigDecimal(4, amount);
                ps.setString(5, reason);
                ps.executeUpdate();
            }
            return;
        }

        String upd = "UPDATE Fine SET amount = ?, reason = ? WHERE fine_id = ? AND status = N'UNPAID'";
        try (PreparedStatement ps = connection.prepareStatement(upd)) {
            ps.setBigDecimal(1, amount);
            ps.setString(2, reason);
            ps.setInt(3, fineId);
            ps.executeUpdate();
        }
    }

    /**
     * Create a DAMAGE fine (UNPAID) for a borrow item.
     */
    public boolean createDamageFine(int readerId, int borrowItemId, BigDecimal amount, String reason) {
        ensureDefaultFineTypes();
        Integer typeId = getFineTypeIdByName(TYPE_DAMAGE);
        if (typeId == null) return false;

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) return true;

        String ins = "INSERT INTO Fine(reader_id, borrow_item_id, fine_type_id, amount, reason, status, created_at, paid_at, handled_by_employee_id) "
                + "VALUES(?, ?, ?, ?, ?, N'UNPAID', SYSDATETIME(), NULL, NULL)";
        try (PreparedStatement ps = connection.prepareStatement(ins)) {
            ps.setInt(1, readerId);
            ps.setInt(2, borrowItemId);
            ps.setInt(3, typeId);
            ps.setBigDecimal(4, amount);
            ps.setString(5, (reason == null || reason.trim().isEmpty()) ? "Sách hư hỏng/mất (thủ thư nhập)" : reason);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Create/update overdue fine at the moment of return confirmation.
     * Uses due_date vs returnTime (SYSDATETIME()).
     */
    public void createOrUpdateOverdueFineAtReturn(int readerId, int borrowItemId) throws SQLException {
        ensureDefaultFineTypes();
        Integer overdueTypeId = getFineTypeIdByName(TYPE_OVERDUE);
        if (overdueTypeId == null) return;
        BigDecimal rate = getOverdueRate();

        String sql = "SELECT TOP 1 "
                + "CASE WHEN CAST(SYSDATETIME() AS date) > CAST(due_date AS date) "
                + "THEN DATEDIFF(day, CAST(due_date AS date), CAST(SYSDATETIME() AS date)) ELSE 0 END AS overdue_days "
                + "FROM Borrow_Item WHERE borrow_item_id = ?";

        int days = 0;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) days = rs.getInt("overdue_days");
        }
        if (days <= 0) return;

        BigDecimal amount = rate.multiply(new BigDecimal(days));
        upsertUnpaidFine(readerId, borrowItemId, overdueTypeId, amount,
                "Quá hạn " + days + " ngày (" + rate.toPlainString() + "/ngày)");
    }

    /**
     * Mark a fine as PAID.
     */
    public boolean markPaid(int fineId, int employeeId) {
        String sql = "UPDATE Fine SET status = N'PAID', paid_at = SYSDATETIME(), handled_by_employee_id = ? "
                + "WHERE fine_id = ? AND status = N'UNPAID'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, fineId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public ArrayList<Fine> listByStatus(String status) {
        ArrayList<Fine> list = new ArrayList<>();

        String where = "";
        if (status != null) {
            status = status.trim().toUpperCase();
        }
        if (status != null && !status.isEmpty() && !"ALL".equals(status)) {
            where = "WHERE f.status = ?";
        }

        String sql = "SELECT f.fine_id, f.reader_id, r.full_name AS reader_name, "
                + "f.borrow_item_id, bi.due_date, bi.returned_at, "
                + "bc.copy_code, b.title AS book_title, "
                + "f.fine_type_id, ft.name AS fine_type_name, "
                + "f.amount, f.reason, f.status, f.created_at, f.paid_at, f.handled_by_employee_id "
                + "FROM Fine f "
                + "INNER JOIN Fine_Type ft ON ft.fine_type_id = f.fine_type_id "
                + "INNER JOIN Reader r ON r.reader_id = f.reader_id "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_item_id = f.borrow_item_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "INNER JOIN Book b ON b.book_id = bc.book_id "
                + where
                + " ORDER BY f.status ASC, f.created_at DESC, f.fine_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (!where.isEmpty()) {
                ps.setString(1, status);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Fine f = new Fine();
                f.setFineId(rs.getInt("fine_id"));
                f.setReaderId(rs.getInt("reader_id"));
                f.setReaderName(rs.getString("reader_name"));
                f.setBorrowItemId(rs.getInt("borrow_item_id"));
                f.setDueDate(rs.getTimestamp("due_date"));
                f.setReturnedAt(rs.getTimestamp("returned_at"));
                f.setCopyCode(rs.getString("copy_code"));
                f.setBookTitle(rs.getString("book_title"));
                f.setFineTypeId(rs.getInt("fine_type_id"));
                f.setFineTypeName(rs.getString("fine_type_name"));
                f.setAmount(rs.getBigDecimal("amount"));
                f.setReason(rs.getString("reason"));
                f.setStatus(rs.getString("status"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                f.setPaidAt(rs.getTimestamp("paid_at"));
                int hb = rs.getInt("handled_by_employee_id");
                f.setHandledByEmployeeId(rs.wasNull() ? null : hb);
                list.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Summary for dashboard.
     * @return BigDecimal[]{unpaidTotal, paidTotal}
     */
    public BigDecimal[] getTotals() {
        BigDecimal unpaid = BigDecimal.ZERO;
        BigDecimal paid = BigDecimal.ZERO;

        String sql = "SELECT status, SUM(amount) AS total_amount "
                + "FROM Fine GROUP BY status";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String st = rs.getString("status");
                BigDecimal t = rs.getBigDecimal("total_amount");
                if (t == null) t = BigDecimal.ZERO;
                if ("UNPAID".equalsIgnoreCase(st)) unpaid = t;
                if ("PAID".equalsIgnoreCase(st)) paid = t;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new BigDecimal[]{unpaid, paid};
    }

    /**
     * @return int[]{unpaidCount, paidCount}
     */
    public int[] getCounts() {
        int unpaid = 0;
        int paid = 0;
        String sql = "SELECT status, COUNT(*) AS cnt FROM Fine GROUP BY status";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String st = rs.getString("status");
                int c = rs.getInt("cnt");
                if ("UNPAID".equalsIgnoreCase(st)) unpaid = c;
                if ("PAID".equalsIgnoreCase(st)) paid = c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new int[]{unpaid, paid};
    }
}