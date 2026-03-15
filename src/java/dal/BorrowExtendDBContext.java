package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.Book;
import model.borrow.BorrowExtend;
import model.borrow.BorrowExtendRequest;
import model.borrow.BorrowItem;

public class BorrowExtendDBContext extends DBContext<BorrowExtendRequest> {

    public List<BorrowExtend> getExtendRequests(String search, String status, int page, int pageSize) {

        List<BorrowExtend> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""

SELECT
be.extend_id,
bk.title AS book_title,
bc.copy_code,
be.old_due_date,
be.requested_due_date,
be.status,
be.requested_at

FROM Borrow_Extend be
JOIN Borrow_Item bi ON be.borrow_item_id = bi.borrow_item_id
JOIN BookCopy bc ON bi.copy_id = bc.copy_id
JOIN Book bk ON bc.book_id = bk.book_id

WHERE 1=1

""");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (bk.title LIKE ? OR bc.copy_code LIKE ?) ");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND be.status = ? ");
        }

        sql.append("""

ORDER BY
CASE
WHEN be.status='PENDING' THEN 0
WHEN be.status='REJECTED' THEN 1
WHEN be.status='APPROVED' THEN 2
END,
be.requested_at DESC

OFFSET ? ROWS FETCH NEXT ? ROWS ONLY

""");

        try {

            PreparedStatement ps = connection.prepareStatement(sql.toString());

            int index = 1;

            if (search != null && !search.isEmpty()) {
                ps.setString(index++, "%" + search + "%");
                ps.setString(index++, "%" + search + "%");
            }

            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowExtend e = new BorrowExtend();

                e.setExtendId(rs.getInt("extend_id"));
                e.setBookTitle(rs.getString("book_title"));
                e.setCopyCode(rs.getString("copy_code"));
                e.setOldDueDate(rs.getTimestamp("old_due_date"));
                e.setRequestedDueDate(rs.getTimestamp("requested_due_date"));
                e.setStatus(rs.getString("status"));
                e.setRequestedAt(rs.getTimestamp("requested_at"));

                list.add(e);

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    public int countExtendRequests(String search, String status) {

        StringBuilder sql = new StringBuilder("""

SELECT COUNT(*)

FROM Borrow_Extend be
JOIN Borrow_Item bi ON be.borrow_item_id = bi.borrow_item_id
JOIN BookCopy bc ON bi.copy_id = bc.copy_id
JOIN Book bk ON bc.book_id = bk.book_id

WHERE 1=1

""");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (bk.title LIKE ? OR bc.copy_code LIKE ?) ");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND be.status = ? ");
        }

        try {

            PreparedStatement ps = connection.prepareStatement(sql.toString());

            int index = 1;

            if (search != null && !search.isEmpty()) {
                ps.setString(index++, "%" + search + "%");
                ps.setString(index++, "%" + search + "%");
            }

            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;

    }

    public void createExtendRequest(int borrowItemId, String requestedDate) {

        String sql = """
INSERT INTO Borrow_Extend
(
borrow_item_id,
old_due_date,
requested_due_date,
status,
requested_at
)
SELECT
borrow_item_id,
due_date,
?,
'PENDING',
GETDATE()
FROM Borrow_Item
WHERE borrow_item_id = ?
""";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, requestedDate);
            ps.setInt(2, borrowItemId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean hasExtendRequest(int borrowItemId) {

        String sql = """
SELECT COUNT(*)
FROM Borrow_Extend
WHERE borrow_item_id = ?
AND status IN ('PENDING','APPROVED')
""";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, borrowItemId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<BorrowExtend> getPendingExtends() {

        List<BorrowExtend> list = new ArrayList<>();

        String sql = """
    SELECT 
        be.extend_id,
        be.borrow_item_id,
        bk.title,
        bc.copy_code,
        be.old_due_date,
        be.requested_due_date,
        be.status,
        be.requested_at
    FROM Borrow_Extend be
    JOIN Borrow_Item bi ON be.borrow_item_id = bi.borrow_item_id
    JOIN BookCopy bc ON bi.copy_id = bc.copy_id
    JOIN Book bk ON bc.book_id = bk.book_id
    WHERE be.status = 'PENDING'
    ORDER BY be.requested_at
    """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowExtend e = new BorrowExtend();

                e.setExtendId(rs.getInt("extend_id"));
                e.setBorrowItemId(rs.getInt("borrow_item_id"));
                e.setBookTitle(rs.getString("title"));
                e.setCopyCode(rs.getString("copy_code"));
                e.setOldDueDate(rs.getTimestamp("old_due_date"));
                e.setRequestedDueDate(rs.getTimestamp("requested_due_date"));
                e.setStatus(rs.getString("status"));

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void approveExtend(int extendId, int employeeId) {

        String sql1 = """
    UPDATE Borrow_Extend
    SET status='APPROVED',
        approved_due_date = requested_due_date,
        processed_at = GETDATE(),
        approved_by_employee_id = ?
    WHERE extend_id = ?
    """;

        String sql2 = """
    UPDATE Borrow_Item
    SET due_date = (
        SELECT requested_due_date 
        FROM Borrow_Extend 
        WHERE extend_id = ?
    )
    WHERE borrow_item_id = (
        SELECT borrow_item_id 
        FROM Borrow_Extend 
        WHERE extend_id = ?
    )
    """;

        try {

            connection.setAutoCommit(false);

            PreparedStatement ps1 = connection.prepareStatement(sql1);
            ps1.setInt(1, employeeId);
            ps1.setInt(2, extendId);
            ps1.executeUpdate();

            PreparedStatement ps2 = connection.prepareStatement(sql2);
            ps2.setInt(1, extendId);
            ps2.setInt(2, extendId);
            ps2.executeUpdate();

            connection.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void rejectExtend(int extendId, int employeeId) {

        String sql = """
    UPDATE Borrow_Extend
    SET status='REJECTED',
        processed_at = GETDATE(),
        approved_by_employee_id = ?
    WHERE extend_id = ?
    """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, employeeId);
            ps.setInt(2, extendId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public ArrayList<BorrowExtendRequest> list() {
        return listForLibrarian("all", "all", 200);
    }

    @Override
    public BorrowExtendRequest get(int id) {
        return getDetailed(id);
    }

    @Override
    public void insert(BorrowExtendRequest model) {
        throw new UnsupportedOperationException("Use createByReader/createByLibrarian");
    }

    @Override
    public void update(BorrowExtendRequest model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void delete(BorrowExtendRequest model) {
        throw new UnsupportedOperationException("Not supported");
    }

    public void createExtendRequest(int borrowItemId) {

        String sql = """
        INSERT INTO Borrow_Extend
        (
            borrow_item_id,
            old_due_date,
            requested_due_date,
            status,
            requested_at
        )
        SELECT
            borrow_item_id,
            due_date,
            DATEADD(day, 7, due_date),
            'PENDING',
            GETDATE()
        FROM Borrow_Item
        WHERE borrow_item_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, borrowItemId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void approveExtend(int extendId) {

        try {

            connection.setAutoCommit(false);

            String sql1 = """
        UPDATE Borrow_Item
        SET due_date = (
            SELECT requested_due_date
            FROM Borrow_Extend
            WHERE extend_id = ?
        )
        WHERE borrow_item_id = (
            SELECT borrow_item_id
            FROM Borrow_Extend
            WHERE extend_id = ?
        )
        """;

            PreparedStatement stm1 = connection.prepareStatement(sql1);

            stm1.setInt(1, extendId);
            stm1.setInt(2, extendId);
            stm1.executeUpdate();

            String sql2 = """
        UPDATE Borrow_Extend
        SET status = 'APPROVED',
            approved_due_date = requested_due_date,
            processed_at = GETDATE()
        WHERE extend_id = ?
        """;

            PreparedStatement stm2 = connection.prepareStatement(sql2);
            stm2.setInt(1, extendId);
            stm2.executeUpdate();

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }

            e.printStackTrace();
        }
    }

    public void rejectExtend(int extendId) {

        try {

            String sql = """
        UPDATE Borrow_Extend
        SET status = 'REJECTED',
            processed_at = GETDATE()
        WHERE extend_id = ?
        """;

            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, extendId);

            stm.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<BorrowExtend> getExtendRequests() {

        List<BorrowExtend> list = new ArrayList<>();

        try {

            String sql = """
        SELECT 
            be.extend_id,
            be.borrow_item_id,
            be.old_due_date,
            be.requested_due_date,
            be.status,
            be.requested_at,
            b.title,
            bc.copy_code
        FROM Borrow_Extend be
        JOIN Borrow_Item bi ON be.borrow_item_id = bi.borrow_item_id
        JOIN BookCopy bc ON bi.copy_id = bc.copy_id
        JOIN Book b ON bc.book_id = b.book_id
        WHERE be.status = 'PENDING'
        ORDER BY be.requested_at
        """;

            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {

                BorrowExtend e = new BorrowExtend();

                e.setExtendId(rs.getInt("extend_id"));
                e.setBorrowItemId(rs.getInt("borrow_item_id"));
                e.setOldDueDate(rs.getTimestamp("old_due_date"));
                e.setRequestedDueDate(rs.getTimestamp("requested_due_date"));
                e.setRequestedAt(rs.getTimestamp("requested_at"));
                e.setStatus(rs.getString("status"));

                e.setBookTitle(rs.getString("title"));
                e.setCopyCode(rs.getString("copy_code"));

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Set<Integer> listPendingBorrowItemIdsByReader(int readerId) {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT borrow_item_id FROM Borrow_Extend WHERE status = N'PENDING' AND borrow_item_id IN ("
                + "SELECT bi.borrow_item_id FROM Borrow_Item bi INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id WHERE br.reader_id = ? )";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt(1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    public Map<Integer, BorrowExtendRequest> mapPendingByReader(int readerId) {
        Map<Integer, BorrowExtendRequest> map = new HashMap<>();
        String sql = baseSelect()
                + "WHERE be.status = N'PENDING' AND br.reader_id = ? "
                + "ORDER BY be.requested_at DESC, be.extend_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowExtendRequest req = mapRow(rs);
                map.put(req.getBorrowItemId(), req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Integer createByReader(int readerId, int borrowItemId, int extendDays) {
        return createInternal("READER", readerId, null, borrowItemId, extendDays);
    }

    public Integer createByLibrarian(int employeeId, int borrowItemId, int extendDays) {
        return createInternal("LIBRARIAN", null, employeeId, borrowItemId, extendDays);
    }

    private Integer createInternal(String actorType, Integer readerId, Integer employeeId, int borrowItemId, int extendDays) {
        try {
            connection.setAutoCommit(false);

            EligibilityInfo info = validateEligibility(borrowItemId, readerId, true);
            if (!info.valid) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            if (extendDays < 1 || extendDays > info.maxAllowedDays) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            String sql = "INSERT INTO Borrow_Extend(borrow_item_id, old_due_date, requested_due_date, approved_due_date, status, requested_at, processed_at, decision_note, approved_by_employee_id) "
                    + "OUTPUT INSERTED.extend_id VALUES (?, ?, DATEADD(day, ?, ?), NULL, N'PENDING', SYSDATETIME(), NULL, ?, NULL)";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, borrowItemId);
                ps.setTimestamp(2, info.oldDueDate);
                ps.setInt(3, extendDays);
                ps.setTimestamp(4, info.oldDueDate);
                ps.setString(5, "READER".equals(actorType)
                        ? "Reader yêu cầu gia hạn " + extendDays + " ngày"
                        : "Librarian tạo yêu cầu gia hạn " + extendDays + " ngày");
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    connection.commit();
                    connection.setAutoCommit(true);
                    return id;
                }
            }

            connection.rollback();
            connection.setAutoCommit(true);
            return null;
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

    public ArrayList<BorrowExtendRequest> listForLibrarian(String typeFilter, String statusFilter, int limit) {
        ArrayList<BorrowExtendRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(baseSelect()).append("WHERE 1=1 ");
        if (statusFilter != null && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append("AND be.status = ? ");
        }
        sql.append("ORDER BY be.requested_at DESC, be.extend_id DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusFilter != null && !"all".equalsIgnoreCase(statusFilter)) {
                ps.setString(idx++, statusFilter.trim().toUpperCase());
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
                if (limit > 0 && list.size() >= limit) {
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public BorrowExtendRequest getDetailed(int extendId) {
        String sql = baseSelect() + "WHERE be.extend_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, extendId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean approve(int extendId, int employeeId, int approvedDays, String decisionNote) {
        try {
            connection.setAutoCommit(false);
            BorrowExtendRequest req = getDetailedForUpdate(extendId);
            if (req == null || !"PENDING".equalsIgnoreCase(req.getStatus())) {
                connection.rollback();
                connection.setAutoCommit(true);
                return false;
            }
            EligibilityInfo info = validateEligibility(req.getBorrowItemId(), req.getReaderId(), false);
            if (!info.valid) {
                connection.rollback();
                connection.setAutoCommit(true);
                return false;
            }
            int max = req.getRequestedDays() == null ? 1 : req.getRequestedDays();
            if (approvedDays < 1 || approvedDays > max) {
                connection.rollback();
                connection.setAutoCommit(true);
                return false;
            }

            String updItem = "UPDATE Borrow_Item SET due_date = DATEADD(day, ?, ?) WHERE borrow_item_id = ? AND returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(updItem)) {
                ps.setInt(1, approvedDays);
                ps.setTimestamp(2, req.getOldDueDate());
                ps.setInt(3, req.getBorrowItemId());
                if (ps.executeUpdate() == 0) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
            }

            String updReq = "UPDATE Borrow_Extend SET status = N'APPROVED', approved_due_date = DATEADD(day, ?, old_due_date), processed_at = SYSDATETIME(), decision_note = ?, approved_by_employee_id = ? WHERE extend_id = ? AND status = N'PENDING'";
            try (PreparedStatement ps = connection.prepareStatement(updReq)) {
                ps.setInt(1, approvedDays);
                ps.setString(2, decisionNote);
                ps.setInt(3, employeeId);
                ps.setInt(4, extendId);
                if (ps.executeUpdate() == 0) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
            }

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

    public boolean reject(int extendId, int employeeId, String decisionNote) {
        String sql = "UPDATE Borrow_Extend SET status = N'REJECTED', processed_at = SYSDATETIME(), decision_note = ?, approved_by_employee_id = ? WHERE extend_id = ? AND status = N'PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, decisionNote);
            ps.setInt(2, employeeId);
            ps.setInt(3, extendId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private BorrowExtendRequest getDetailedForUpdate(int extendId) {
        String sql = baseSelect() + "WHERE be.extend_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, extendId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private EligibilityInfo validateEligibility(int borrowItemId, Integer expectedReaderId, boolean checkPending) throws SQLException {
        EligibilityInfo info = new EligibilityInfo();
        String sql = "SELECT TOP 1 bi.borrow_item_id, bi.borrow_id, br.reader_id, br.borrow_date, bi.copy_id, bi.due_date, bi.returned_at "
                + "FROM Borrow_Item bi INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id WHERE bi.borrow_item_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return info;
            }
            int actualReaderId = rs.getInt("reader_id");
            if (expectedReaderId != null && actualReaderId != expectedReaderId) {
                return info;
            }
            if (rs.getTimestamp("returned_at") != null) {
                return info;
            }
            info.valid = true;
            info.borrowItemId = borrowItemId;
            info.borrowId = rs.getInt("borrow_id");
            info.readerId = actualReaderId;
            info.oldDueDate = rs.getTimestamp("due_date");
        }
        if (checkPending && getPendingByBorrowItem(borrowItemId) != null) {
            info.valid = false;
            return info;
        }
        FineInfo fineInfo = getUnpaidFineInfo(borrowItemId);
        info.hasUnpaidFine = fineInfo.hasUnpaidFine;
        info.unpaidSummary = fineInfo.summary;
        info.unpaidAmount = fineInfo.amount;
        if (fineInfo.hasUnpaidFine) {
            info.valid = false;
            return info;
        }
        info.maxAllowedDays = 7;
        return info;
    }

    public BorrowExtendRequest getPendingByBorrowItem(int borrowItemId) {
        String sql = baseSelect() + "WHERE be.borrow_item_id = ? AND be.status = N'PENDING' ORDER BY be.requested_at DESC, be.extend_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public FineInfo getUnpaidFineInfo(int borrowItemId) {
        FineInfo info = new FineInfo();
        String sql = "SELECT COUNT(*) AS cnt, COALESCE(SUM(amount), 0) AS total, STRING_AGG(CONVERT(nvarchar(255), reason), N'; ') AS reason_summary "
                + "FROM Fine WHERE borrow_item_id = ? AND status = N'UNPAID'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                info.hasUnpaidFine = rs.getInt("cnt") > 0;
                info.amount = rs.getBigDecimal("total");
                info.summary = rs.getString("reason_summary");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return info;
    }

    private String baseSelect() {
        return "SELECT be.extend_id, be.borrow_item_id, bi.borrow_id, br.reader_id, rd.full_name AS reader_name, "
                + "bi.copy_id, bc.copy_code, b.book_id, b.title, b.cover_url, br.borrow_date, "
                + "be.old_due_date, be.requested_due_date, be.approved_due_date, be.status, be.requested_at, be.processed_at, be.decision_note, be.approved_by_employee_id, "
                + "DATEDIFF(day, be.old_due_date, be.requested_due_date) AS requested_days "
                + "FROM Borrow_Extend be "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_item_id = be.borrow_item_id "
                + "INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id "
                + "INNER JOIN Reader rd ON rd.reader_id = br.reader_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "INNER JOIN Book b ON b.book_id = bc.book_id ";
    }

    private BorrowExtendRequest mapRow(ResultSet rs) throws SQLException {
        BorrowExtendRequest req = new BorrowExtendRequest();
        req.setExtendId(rs.getInt("extend_id"));
        req.setBorrowItemId(rs.getInt("borrow_item_id"));
        req.setBorrowId(rs.getInt("borrow_id"));
        req.setReaderId(rs.getInt("reader_id"));
        req.setReaderName(rs.getString("reader_name"));
        req.setCopyId(rs.getInt("copy_id"));
        req.setCopyCode(rs.getString("copy_code"));
        req.setBorrowDate(rs.getTimestamp("borrow_date"));
        req.setOldDueDate(rs.getTimestamp("old_due_date"));
        req.setRequestedDueDate(rs.getTimestamp("requested_due_date"));
        req.setApprovedDueDate(rs.getTimestamp("approved_due_date"));
        req.setStatus(rs.getString("status"));
        req.setRequestedAt(rs.getTimestamp("requested_at"));
        req.setProcessedAt(rs.getTimestamp("processed_at"));
        req.setDecisionNote(rs.getString("decision_note"));
        int approvedBy = rs.getInt("approved_by_employee_id");
        req.setApprovedByEmployeeId(rs.wasNull() ? null : approvedBy);
        int requestedDays = rs.getInt("requested_days");
        req.setRequestedDays(rs.wasNull() ? null : requestedDays);
        req.setMaxAllowedDays(req.getRequestedDays());

        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setCoverUrl(rs.getString("cover_url"));
        req.setBook(book);

        FineInfo fineInfo = getUnpaidFineInfo(req.getBorrowItemId());
        req.setHasUnpaidFine(fineInfo.hasUnpaidFine);
        req.setUnpaidFineAmount(fineInfo.amount);
        req.setUnpaidFineSummary(fineInfo.summary);
        return req;
    }

    private static class EligibilityInfo {

        boolean valid;
        int borrowItemId;
        int borrowId;
        int readerId;
        java.sql.Timestamp oldDueDate;
        int maxAllowedDays;
        boolean hasUnpaidFine;
        java.math.BigDecimal unpaidAmount;
        String unpaidSummary;
    }

    public static class FineInfo {

        public boolean hasUnpaidFine;
        public java.math.BigDecimal amount;
        public String summary;
    }
}
