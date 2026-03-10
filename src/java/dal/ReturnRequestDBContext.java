package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import model.Book;
import model.ReturnRequest;
import model.ReturnRequestItem;

public class ReturnRequestDBContext extends DBContext<ReturnRequest> {

    @Override
    public ArrayList<ReturnRequest> list() {
        return listForLibrarian("all", 200);
    }

    @Override
    public ReturnRequest get(int id) {
        return getDetailed(id);
    }

    @Override
    public void insert(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void update(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Set<Integer> listPendingBorrowItemIdsByReader(int readerId) {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT DISTINCT i.borrow_item_id FROM Return_Request r INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id WHERE r.status = N'PENDING' AND r.reader_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt(1));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    public Integer createByReader(int readerId, int borrowItemId) {
        try {
            connection.setAutoCommit(false);
            String chk = "SELECT TOP 1 bi.borrow_item_id FROM Borrow_Item bi INNER JOIN Borrow b ON b.borrow_id = bi.borrow_id WHERE bi.borrow_item_id = ? AND b.reader_id = ? AND bi.returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(chk)) {
                ps.setInt(1, borrowItemId);
                ps.setInt(2, readerId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return null;
                }
            }
            if (getPendingReturnRequestIdByBorrowItem(borrowItemId) != null) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }
            int requestId;
            String insReq = "INSERT INTO Return_Request(reader_id, created_by_employee_id, created_by_type, status, created_at, note) OUTPUT INSERTED.return_request_id VALUES(?, NULL, N'READER', N'PENDING', SYSDATETIME(), N'Reader yêu cầu trả sách')";
            try (PreparedStatement ps = connection.prepareStatement(insReq)) {
                ps.setInt(1, readerId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return null;
                }
                requestId = rs.getInt(1);
            }
            try (PreparedStatement ps = connection.prepareStatement("INSERT INTO Return_Request_Item(return_request_id, borrow_item_id) VALUES(?, ?)")) {
                ps.setInt(1, requestId);
                ps.setInt(2, borrowItemId);
                ps.executeUpdate();
            }
            connection.commit();
            connection.setAutoCommit(true);
            return requestId;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return null;
        }
    }

    public Integer getPendingReturnRequestIdByBorrowItem(int borrowItemId) {
        String sql = "SELECT TOP 1 r.return_request_id FROM Return_Request r INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id WHERE r.status = N'PENDING' AND i.borrow_item_id = ? ORDER BY r.created_at ASC, r.return_request_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean confirmOrCreateAndAutoConfirm(int employeeId, int borrowItemId) {
        return confirmOrCreateAndAutoConfirm(employeeId, borrowItemId, null, null);
    }

    public boolean confirmOrCreateAndAutoConfirm(int employeeId, int borrowItemId, java.math.BigDecimal damageAmount, String damageReason) {
        Integer pendingId = getPendingReturnRequestIdByBorrowItem(borrowItemId);
        if (pendingId != null) return confirm(employeeId, pendingId, damageAmount, damageReason);
        return createAndAutoConfirmByLibrarian(employeeId, borrowItemId, damageAmount, damageReason) != null;
    }

    public Integer createAndAutoConfirmByLibrarian(int employeeId, int borrowItemId) {
        return createAndAutoConfirmByLibrarian(employeeId, borrowItemId, null, null);
    }

    public Integer createAndAutoConfirmByLibrarian(int employeeId, int borrowItemId, java.math.BigDecimal damageAmount, String damageReason) {
        try {
            connection.setAutoCommit(false);
            int readerId;
            int copyId;
            int borrowId;
            String chk = "SELECT TOP 1 br.reader_id, bi.copy_id, bi.borrow_id FROM Borrow_Item bi INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id WHERE bi.borrow_item_id = ? AND bi.returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(chk)) {
                ps.setInt(1, borrowItemId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return null;
                }
                readerId = rs.getInt("reader_id");
                copyId = rs.getInt("copy_id");
                borrowId = rs.getInt("borrow_id");
            }
            int requestId;
            String insReq = "INSERT INTO Return_Request(reader_id, created_by_employee_id, created_by_type, status, created_at, confirmed_by_employee_id, confirmed_at, note) OUTPUT INSERTED.return_request_id VALUES(?, ?, N'LIBRARIAN', N'CONFIRMED', SYSDATETIME(), ?, SYSDATETIME(), N'Trả sách trực tiếp bởi thủ thư')";
            try (PreparedStatement ps = connection.prepareStatement(insReq)) {
                ps.setInt(1, readerId);
                ps.setInt(2, employeeId);
                ps.setInt(3, employeeId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                requestId = rs.getInt(1);
            }
            try (PreparedStatement ps = connection.prepareStatement("INSERT INTO Return_Request_Item(return_request_id, borrow_item_id) VALUES(?, ?)")) {
                ps.setInt(1, requestId);
                ps.setInt(2, borrowItemId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement("UPDATE Borrow_Item SET returned_at = SYSDATETIME(), status = N'RETURNED' WHERE borrow_item_id = ? AND returned_at IS NULL")) {
                ps.setInt(1, borrowItemId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement("UPDATE BookCopy SET status = N'AVAILABLE' WHERE copy_id = ?")) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }
            updateBorrowCompletedIfNeeded(borrowId);
            FineDBContext fineDao = new FineDBContext();
            fineDao.connection = this.connection;
            fineDao.ensureDefaultFineTypes();
            fineDao.createOrUpdateOverdueFineAtReturn(readerId, borrowItemId);
            fineDao.createDamageFine(readerId, borrowItemId, damageAmount, damageReason);
            connection.commit();
            connection.setAutoCommit(true);
            return requestId;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return null;
        }
    }

    public boolean confirm(int employeeId, int returnRequestId) {
        return confirm(employeeId, returnRequestId, null, null);
    }

    public boolean confirm(int employeeId, int returnRequestId, java.math.BigDecimal damageAmount, String damageReason) {
        try {
            connection.setAutoCommit(false);
            int borrowItemId;
            try (PreparedStatement ps = connection.prepareStatement("SELECT TOP 1 borrow_item_id FROM Return_Request_Item WHERE return_request_id = ?")) {
                ps.setInt(1, returnRequestId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
                borrowItemId = rs.getInt("borrow_item_id");
            }
            int changed;
            try (PreparedStatement ps = connection.prepareStatement("UPDATE Return_Request SET status = N'CONFIRMED', confirmed_by_employee_id = ?, confirmed_at = SYSDATETIME() WHERE return_request_id = ? AND status = N'PENDING'")) {
                ps.setInt(1, employeeId);
                ps.setInt(2, returnRequestId);
                changed = ps.executeUpdate();
            }
            if (changed == 0) {
                connection.rollback();
                connection.setAutoCommit(true);
                return false;
            }
            int copyId;
            int borrowId;
            int readerId;
            try (PreparedStatement ps = connection.prepareStatement("SELECT bi.copy_id, bi.borrow_id, b.reader_id FROM Borrow_Item bi INNER JOIN Borrow b ON b.borrow_id = bi.borrow_id WHERE bi.borrow_item_id = ?")) {
                ps.setInt(1, borrowItemId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
                copyId = rs.getInt("copy_id");
                borrowId = rs.getInt("borrow_id");
                readerId = rs.getInt("reader_id");
            }
            try (PreparedStatement ps = connection.prepareStatement("UPDATE Borrow_Item SET returned_at = SYSDATETIME(), status = N'RETURNED' WHERE borrow_item_id = ? AND returned_at IS NULL")) {
                ps.setInt(1, borrowItemId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement("UPDATE BookCopy SET status = N'AVAILABLE' WHERE copy_id = ?")) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }
            updateBorrowCompletedIfNeeded(borrowId);
            FineDBContext fineDao = new FineDBContext();
            fineDao.connection = this.connection;
            fineDao.ensureDefaultFineTypes();
            fineDao.createOrUpdateOverdueFineAtReturn(readerId, borrowItemId);
            fineDao.createDamageFine(readerId, borrowItemId, damageAmount, damageReason);
            connection.commit();
            connection.setAutoCommit(true);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        }
    }

    public boolean reject(int employeeId, int returnRequestId, String decisionNote) {
        try (PreparedStatement ps = connection.prepareStatement("UPDATE Return_Request SET status = N'REJECTED', confirmed_by_employee_id = ?, confirmed_at = SYSDATETIME(), note = ? WHERE return_request_id = ? AND status = N'PENDING'")) {
            ps.setInt(1, employeeId);
            ps.setString(2, decisionNote);
            ps.setInt(3, returnRequestId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public ArrayList<ReturnRequest> listForLibrarian(String statusFilter, int limit) {
        ArrayList<ReturnRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(baseSelect()).append("WHERE 1=1 ");
        if (statusFilter != null && !"all".equalsIgnoreCase(statusFilter)) sql.append("AND r.status = ? ");
        sql.append("ORDER BY r.created_at DESC, r.return_request_id DESC");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusFilter != null && !"all".equalsIgnoreCase(statusFilter)) ps.setString(idx++, statusFilter.trim().toUpperCase());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReturnRequest rr = mapRequest(rs);
                rr.getItems().add(mapItem(rs));
                list.add(rr);
                if (limit > 0 && list.size() >= limit) break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ReturnRequest getDetailed(int requestId) {
        String sql = baseSelect() + "WHERE r.return_request_id = ? ORDER BY i.return_request_item_id ASC";
        ReturnRequest rr = null;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (rr == null) rr = mapRequest(rs);
                rr.getItems().add(mapItem(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rr;
    }

    private String baseSelect() {
        return "SELECT r.return_request_id, r.reader_id, rd.full_name AS reader_name, r.created_by_employee_id, cbe.full_name AS created_by_employee_name, "
                + "r.created_by_type, r.status, r.created_at, r.confirmed_by_employee_id, cfe.full_name AS confirmed_by_employee_name, r.confirmed_at, r.note, "
                + "i.return_request_item_id, i.borrow_item_id, bi.borrow_id, bi.copy_id, bc.copy_code, br.borrow_date, bi.due_date, bi.returned_at, b.book_id, b.title, b.cover_url "
                + "FROM Return_Request r "
                + "INNER JOIN Reader rd ON rd.reader_id = r.reader_id "
                + "LEFT JOIN Employee cbe ON cbe.employee_id = r.created_by_employee_id "
                + "LEFT JOIN Employee cfe ON cfe.employee_id = r.confirmed_by_employee_id "
                + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_item_id = i.borrow_item_id "
                + "INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "INNER JOIN Book b ON b.book_id = bc.book_id ";
    }

    private ReturnRequest mapRequest(ResultSet rs) throws SQLException {
        ReturnRequest rr = new ReturnRequest();
        rr.setReturnRequestId(rs.getInt("return_request_id"));
        rr.setReaderId(rs.getInt("reader_id"));
        rr.setReaderName(rs.getString("reader_name"));
        int cbe = rs.getInt("created_by_employee_id");
        rr.setCreatedByEmployeeId(rs.wasNull() ? null : cbe);
        rr.setCreatedByEmployeeName(rs.getString("created_by_employee_name"));
        rr.setCreatedByType(rs.getString("created_by_type"));
        rr.setStatus(rs.getString("status"));
        rr.setCreatedAt(rs.getTimestamp("created_at"));
        int cfe = rs.getInt("confirmed_by_employee_id");
        rr.setConfirmedByEmployeeId(rs.wasNull() ? null : cfe);
        rr.setConfirmedByEmployeeName(rs.getString("confirmed_by_employee_name"));
        rr.setConfirmedAt(rs.getTimestamp("confirmed_at"));
        rr.setNote(rs.getString("note"));
        return rr;
    }

    private ReturnRequestItem mapItem(ResultSet rs) throws SQLException {
        ReturnRequestItem it = new ReturnRequestItem();
        it.setReturnRequestItemId(rs.getInt("return_request_item_id"));
        it.setReturnRequestId(rs.getInt("return_request_id"));
        it.setBorrowItemId(rs.getInt("borrow_item_id"));
        it.setBorrowId(rs.getInt("borrow_id"));
        it.setCopyId(rs.getInt("copy_id"));
        it.setCopyCode(rs.getString("copy_code"));
        it.setBorrowDate(rs.getTimestamp("borrow_date"));
        it.setDueDate(rs.getTimestamp("due_date"));
        it.setReturnedAt(rs.getTimestamp("returned_at"));
        Book b = new Book();
        b.setBookId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setCoverUrl(rs.getString("cover_url"));
        it.setBook(b);
        return it;
    }

    private void updateBorrowCompletedIfNeeded(int borrowId) throws SQLException {
        String sqlCount = "SELECT COUNT(*) AS total_items, SUM(CASE WHEN returned_at IS NOT NULL THEN 1 ELSE 0 END) AS returned_items FROM Borrow_Item WHERE borrow_id = ?";
        int total = 0;
        int returned = 0;
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total_items");
                returned = rs.getInt("returned_items");
            }
        }
        if (total > 0 && total == returned) {
            try (PreparedStatement ps = connection.prepareStatement("UPDATE Borrow SET status = N'COMPLETED' WHERE borrow_id = ?")) {
                ps.setInt(1, borrowId);
                ps.executeUpdate();
            }
        }
    }
}