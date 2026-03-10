package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.BorrowRequest;
import model.BorrowRequestItem;

/**
 * Borrow Request DAO (Reader + Librarian)
 */
public class BorrowRequestDBContext extends DBContext<BorrowRequest> {

    // ===== Required abstract overrides from DBContext =====
    @Override
    public ArrayList<BorrowRequest> list() {
        return listByStatus("pending", 200);
    }

    @Override
    public BorrowRequest get(int id) {
        return getWithItems(id);
    }

    @Override
    public void insert(BorrowRequest model) {
        throw new UnsupportedOperationException("Use createSingleBookRequest(...) instead.");
    }

    @Override
    public void update(BorrowRequest model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void delete(BorrowRequest model) {
        throw new UnsupportedOperationException("Not supported.");
    }
    // =====================================================

    // =====================================================
    // Reader-side functions (Book detail / Create request)
    // =====================================================

    public boolean hasPendingForBook(int readerId, int bookId) {
        String sql = "SELECT TOP 1 r.request_id "
                + "FROM Borrow_Request r "
                + "INNER JOIN Borrow_Request_Item i ON i.request_id = r.request_id "
                + "WHERE r.reader_id = ? AND r.status = N'PENDING' AND i.book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Tạo 1 borrow request cho 1 cuốn sách (quantity = 1)
     * @return request_id hoặc null nếu lỗi / đã có pending cho book này
     */
    public Integer createSingleBookRequest(int readerId, int bookId) {
        try {
            connection.setAutoCommit(false);

            if (hasPendingForBook(readerId, bookId)) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            int requestId;
            String insHead = "INSERT INTO Borrow_Request (reader_id, status, requested_at, note) "
                    + "OUTPUT INSERTED.request_id "
                    + "VALUES (?, N'PENDING', SYSDATETIME(), NULL)";
            try (PreparedStatement ps = connection.prepareStatement(insHead)) {
                ps.setInt(1, readerId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                requestId = rs.getInt(1);
            }

            String insItem = "INSERT INTO Borrow_Request_Item (request_id, book_id, quantity) VALUES (?, ?, 1)";
            try (PreparedStatement ps = connection.prepareStatement(insItem)) {
                ps.setInt(1, requestId);
                ps.setInt(2, bookId);
                ps.executeUpdate();
            }

            connection.commit();
            connection.setAutoCommit(true);
            return requestId;

        } catch (Exception e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Recent list (để Reader/Home dùng)
     */
    public List<BorrowRequest> listRecentWithItemsByReader(int readerId, int limit) {
        if (limit <= 0) limit = 5;

        Map<Integer, BorrowRequest> map = new LinkedHashMap<>();

        String sql = "SELECT TOP (?) "
                + "r.request_id, r.reader_id, r.status, r.requested_at, r.note, "
                + "r.processed_by_employee_id, r.processed_at, r.decision_note, "
                + "i.request_item_id, i.book_id, i.quantity, b.title AS book_title "
                + "FROM Borrow_Request r "
                + "LEFT JOIN Borrow_Request_Item i ON i.request_id = r.request_id "
                + "LEFT JOIN Book b ON b.book_id = i.book_id "
                + "WHERE r.reader_id = ? "
                + "ORDER BY r.requested_at DESC, i.request_item_id ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, readerId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int rid = rs.getInt("request_id");
                BorrowRequest br = map.get(rid);
                if (br == null) {
                    br = new BorrowRequest();
                    br.setRequestId(rid);
                    br.setReaderId(rs.getInt("reader_id"));
                    br.setStatus(rs.getString("status"));
                    br.setRequestedAt(rs.getTimestamp("requested_at"));
                    br.setNote(rs.getString("note"));

                    int p = rs.getInt("processed_by_employee_id");
                    br.setProcessedByEmployeeId(rs.wasNull() ? null : p);
                    br.setProcessedAt(rs.getTimestamp("processed_at"));
                    br.setDecisionNote(rs.getString("decision_note"));

                    map.put(rid, br);
                }

                int itemId = rs.getInt("request_item_id");
                if (!rs.wasNull()) {
                    BorrowRequestItem it = new BorrowRequestItem();
                    it.setRequestItemId(itemId);
                    it.setRequestId(rid);
                    it.setBookId(rs.getInt("book_id"));
                    it.setBookTitle(rs.getString("book_title"));
                    it.setQuantity(rs.getInt("quantity"));
                    br.getItems().add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    /**
     * Alias cho code cũ (nếu có chỗ gọi L hoa)
     */
    public List<BorrowRequest> ListRecentWithItemsByReader(int readerId, int limit) {
        return listRecentWithItemsByReader(readerId, limit);
    }

    /**
     * ✅ NEW: Reader history list with items theo filter:
     * - all / pending / approved / rejected
     */
    public List<BorrowRequest> listWithItemsByReaderAndStatus(int readerId, String filter, int limit) {
        if (limit <= 0) limit = 200;
        if (filter == null || filter.trim().isEmpty()) filter = "all";
        filter = filter.trim().toLowerCase();

        String where = " WHERE r.reader_id = ? ";
        switch (filter) {
            case "pending" -> where += " AND r.status = N'PENDING' ";
            case "approved" -> where += " AND r.status = N'APPROVED' ";
            case "rejected" -> where += " AND r.status = N'REJECTED' ";
            case "all" -> { /* no-op */ }
            default -> { /* no-op */ }
        }

        Map<Integer, BorrowRequest> map = new LinkedHashMap<>();

        String sql = "SELECT TOP (?) "
                + "r.request_id, r.reader_id, rd.full_name AS reader_name, r.status, r.requested_at, r.note, "
                + "r.processed_by_employee_id, r.processed_at, r.decision_note, "
                + "i.request_item_id, i.book_id, i.quantity, b.title AS book_title "
                + "FROM Borrow_Request r "
                + "INNER JOIN Reader rd ON rd.reader_id = r.reader_id "
                + "LEFT JOIN Borrow_Request_Item i ON i.request_id = r.request_id "
                + "LEFT JOIN Book b ON b.book_id = i.book_id "
                + where
                + "ORDER BY r.requested_at DESC, r.request_id DESC, i.request_item_id ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int rid = rs.getInt("request_id");
                BorrowRequest br = map.get(rid);
                if (br == null) {
                    br = new BorrowRequest();
                    br.setRequestId(rid);
                    br.setReaderId(rs.getInt("reader_id"));
                    br.setReaderName(rs.getString("reader_name"));
                    br.setStatus(rs.getString("status"));
                    br.setRequestedAt(rs.getTimestamp("requested_at"));
                    br.setNote(rs.getString("note"));

                    int p = rs.getInt("processed_by_employee_id");
                    br.setProcessedByEmployeeId(rs.wasNull() ? null : p);
                    br.setProcessedAt(rs.getTimestamp("processed_at"));
                    br.setDecisionNote(rs.getString("decision_note"));

                    map.put(rid, br);
                }

                int itemId = rs.getInt("request_item_id");
                if (!rs.wasNull()) {
                    BorrowRequestItem it = new BorrowRequestItem();
                    it.setRequestItemId(itemId);
                    it.setRequestId(rid);
                    it.setBookId(rs.getInt("book_id"));
                    it.setBookTitle(rs.getString("book_title"));
                    it.setQuantity(rs.getInt("quantity"));
                    br.getItems().add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(map.values());
    }

    // =====================================================
    // Librarian-side list/get
    // =====================================================

    public ArrayList<BorrowRequest> listByStatus(String filter, int limit) {
        ArrayList<BorrowRequest> list = new ArrayList<>();
        if (limit <= 0) limit = 200;

        if (filter == null) filter = "pending";
        filter = filter.trim().toLowerCase();

        String where = switch (filter) {
            case "pending" -> " WHERE r.status = N'PENDING' ";
            case "approved" -> " WHERE r.status = N'APPROVED' ";
            case "rejected" -> " WHERE r.status = N'REJECTED' ";
            case "all" -> "";
            default -> " WHERE r.status = N'PENDING' ";
        };

        String sql = "SELECT TOP (?) r.request_id, r.reader_id, rd.full_name AS reader_name, "
                + "r.status, r.requested_at, r.note "
                + "FROM Borrow_Request r "
                + "INNER JOIN Reader rd ON rd.reader_id = r.reader_id "
                + where
                + "ORDER BY r.requested_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowRequest br = new BorrowRequest();
                br.setRequestId(rs.getInt("request_id"));
                br.setReaderId(rs.getInt("reader_id"));
                br.setReaderName(rs.getString("reader_name"));
                br.setStatus(rs.getString("status"));
                br.setRequestedAt(rs.getTimestamp("requested_at"));
                br.setNote(rs.getString("note"));
                list.add(br);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public BorrowRequest getWithItems(int requestId) {
        Map<Integer, BorrowRequest> map = new LinkedHashMap<>();

        String sql = "SELECT r.request_id, r.reader_id, rd.full_name AS reader_name, "
                + "r.status, r.requested_at, r.note, r.processed_by_employee_id, r.processed_at, r.decision_note, "
                + "i.request_item_id, i.book_id, i.quantity, b.title AS book_title "
                + "FROM Borrow_Request r "
                + "INNER JOIN Reader rd ON rd.reader_id = r.reader_id "
                + "LEFT JOIN Borrow_Request_Item i ON i.request_id = r.request_id "
                + "LEFT JOIN Book b ON b.book_id = i.book_id "
                + "WHERE r.request_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int rid = rs.getInt("request_id");
                BorrowRequest br = map.get(rid);
                if (br == null) {
                    br = new BorrowRequest();
                    br.setRequestId(rid);
                    br.setReaderId(rs.getInt("reader_id"));
                    br.setReaderName(rs.getString("reader_name"));
                    br.setStatus(rs.getString("status"));
                    br.setRequestedAt(rs.getTimestamp("requested_at"));
                    br.setNote(rs.getString("note"));

                    int p = rs.getInt("processed_by_employee_id");
                    br.setProcessedByEmployeeId(rs.wasNull() ? null : p);
                    br.setProcessedAt(rs.getTimestamp("processed_at"));
                    br.setDecisionNote(rs.getString("decision_note"));

                    map.put(rid, br);
                }

                int itemId = rs.getInt("request_item_id");
                if (!rs.wasNull()) {
                    BorrowRequestItem it = new BorrowRequestItem();
                    it.setRequestItemId(itemId);
                    it.setRequestId(rid);
                    it.setBookId(rs.getInt("book_id"));
                    it.setBookTitle(rs.getString("book_title"));
                    it.setQuantity(rs.getInt("quantity"));
                    br.getItems().add(it);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map.values().stream().findFirst().orElse(null);
    }

    /**
     * ✅ APPROVE chuẩn (KHÔNG gọi BorrowDBContext.createBorrowFromRequest)
     * - Chọn đủ BookCopy AVAILABLE
     * - Update Borrow_Request -> APPROVED
     * - Insert Borrow + Borrow_Item
     * - Update BookCopy -> BORROWED
     */
    public boolean approve(int requestId, int employeeId, String decisionNote, int borrowDays) {
        try {
            connection.setAutoCommit(false);

            BorrowRequest br = getWithItems(requestId);
            if (br == null || br.getItems().isEmpty()) {
                connection.rollback();
                connection.setAutoCommit(true);
                return false;
            }
            if (!"PENDING".equalsIgnoreCase(br.getStatus())) {
                connection.rollback();
                connection.setAutoCommit(true);
                return false;
            }

            ArrayList<Integer> chosenCopyIds = new ArrayList<>();
            for (BorrowRequestItem it : br.getItems()) {
                String pick = "SELECT TOP (?) copy_id FROM BookCopy WHERE book_id = ? AND status = N'AVAILABLE' ORDER BY copy_id ASC";
                try (PreparedStatement ps = connection.prepareStatement(pick)) {
                    ps.setInt(1, it.getQuantity());
                    ps.setInt(2, it.getBookId());
                    ResultSet rs = ps.executeQuery();
                    int count = 0;
                    while (rs.next()) {
                        chosenCopyIds.add(rs.getInt("copy_id"));
                        count++;
                    }
                    if (count < it.getQuantity()) {
                        connection.rollback();
                        connection.setAutoCommit(true);
                        return false;
                    }
                }
            }

            String updReq = "UPDATE Borrow_Request SET status = N'APPROVED', processed_by_employee_id = ?, processed_at = SYSDATETIME(), decision_note = ? "
                    + "WHERE request_id = ? AND status = N'PENDING'";
            try (PreparedStatement ps = connection.prepareStatement(updReq)) {
                ps.setInt(1, employeeId);
                ps.setString(2, decisionNote);
                ps.setInt(3, requestId);
                int n = ps.executeUpdate();
                if (n == 0) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
            }

            int borrowId;
            String insBorrow = "INSERT INTO Borrow (reader_id, request_id, borrow_date, status, created_at, approved_by_employee_id) "
                    + "OUTPUT INSERTED.borrow_id "
                    + "VALUES (?, ?, SYSDATETIME(), N'ACTIVE', SYSDATETIME(), ?)";
            try (PreparedStatement ps = connection.prepareStatement(insBorrow)) {
                ps.setInt(1, br.getReaderId());
                ps.setInt(2, requestId);
                ps.setInt(3, employeeId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                borrowId = rs.getInt(1);
            }

            String insItem = "INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, returned_at, status) "
                    + "VALUES (?, ?, DATEADD(day, ?, SYSDATETIME()), NULL, N'BORROWED')";
            String updCopy = "UPDATE BookCopy SET status = N'BORROWED' WHERE copy_id = ?";

            for (Integer copyId : chosenCopyIds) {
                try (PreparedStatement ps = connection.prepareStatement(insItem)) {
                    ps.setInt(1, borrowId);
                    ps.setInt(2, copyId);
                    ps.setInt(3, borrowDays);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = connection.prepareStatement(updCopy)) {
                    ps.setInt(1, copyId);
                    ps.executeUpdate();
                }
            }

            connection.commit();
            connection.setAutoCommit(true);
            return true;

        } catch (Exception e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        }
    }

    public void reject(int requestId, int employeeId, String decisionNote) {
        String sql = "UPDATE Borrow_Request SET status = N'REJECTED', processed_by_employee_id = ?, processed_at = SYSDATETIME(), decision_note = ? "
                + "WHERE request_id = ? AND status = N'PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setString(2, decisionNote);
            ps.setInt(3, requestId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}