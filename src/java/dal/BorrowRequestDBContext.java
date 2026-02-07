package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.BorrowRequest;
import model.BorrowRequestItem;

/**
 * Librarian xử lý Borrow_Request.
 */
public class BorrowRequestDBContext extends DBContext<BorrowRequest> {

    @Override
    public ArrayList<BorrowRequest> list() {
        throw new UnsupportedOperationException("Use listPending() or getWithItems(requestId)");
    }

    @Override
    public BorrowRequest get(int id) {
        return getWithItems(id);
    }

    @Override
    public void insert(BorrowRequest model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void update(BorrowRequest model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void delete(BorrowRequest model) {
        throw new UnsupportedOperationException("Not supported");
    }

    public ArrayList<BorrowRequest> listPending() {
        ArrayList<BorrowRequest> list = new ArrayList<>();
        String sql = "SELECT TOP 200 r.request_id, r.reader_id, rd.full_name AS reader_name, r.status, r.requested_at, r.note "
                + "FROM Borrow_Request r "
                + "INNER JOIN Reader rd ON rd.reader_id = r.reader_id "
                + "WHERE r.status = N'PENDING' "
                + "ORDER BY r.requested_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
        BorrowRequest br = null;

        String headSql = "SELECT r.request_id, r.reader_id, rd.full_name AS reader_name, r.status, r.requested_at, r.note, "
                + "r.processed_by_employee_id, r.processed_at, r.decision_note "
                + "FROM Borrow_Request r "
                + "INNER JOIN Reader rd ON rd.reader_id = r.reader_id "
                + "WHERE r.request_id = ?";

        String itemsSql = "SELECT i.request_item_id, i.request_id, i.book_id, b.title AS book_title, i.quantity "
                + "FROM Borrow_Request_Item i "
                + "INNER JOIN Book b ON b.book_id = i.book_id "
                + "WHERE i.request_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(headSql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                br = new BorrowRequest();
                br.setRequestId(rs.getInt("request_id"));
                br.setReaderId(rs.getInt("reader_id"));
                br.setReaderName(rs.getString("reader_name"));
                br.setStatus(rs.getString("status"));
                br.setRequestedAt(rs.getTimestamp("requested_at"));
                br.setNote(rs.getString("note"));
                int p = rs.getInt("processed_by_employee_id");
                br.setProcessedByEmployeeId(rs.wasNull() ? null : p);
                br.setProcessedAt(rs.getTimestamp("processed_at"));
                br.setDecisionNote(rs.getString("decision_note"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (br == null) return null;

        try (PreparedStatement ps = connection.prepareStatement(itemsSql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowRequestItem it = new BorrowRequestItem();
                it.setRequestItemId(rs.getInt("request_item_id"));
                it.setRequestId(rs.getInt("request_id"));
                it.setBookId(rs.getInt("book_id"));
                it.setBookTitle(rs.getString("book_title"));
                it.setQuantity(rs.getInt("quantity"));
                br.getItems().add(it);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return br;
    }

    /**
     * Approve request -> tạo Borrow + Borrow_Item, gán copy, update BookCopy.status.
     *
     * @return true nếu thành công, false nếu thiếu copy hoặc lỗi.
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

            // 1) kiểm tra đủ copy AVAILABLE
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

            // 2) update Borrow_Request
            String updReq = "UPDATE Borrow_Request SET status = N'APPROVED', processed_by_employee_id = ?, processed_at = SYSDATETIME(), decision_note = ? WHERE request_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updReq)) {
                ps.setInt(1, employeeId);
                ps.setString(2, decisionNote);
                ps.setInt(3, requestId);
                ps.executeUpdate();
            }

            // 3) insert Borrow
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

            // 4) insert Borrow_Item + update BookCopy
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
        String sql = "UPDATE Borrow_Request SET status = N'REJECTED', processed_by_employee_id = ?, processed_at = SYSDATETIME(), decision_note = ? WHERE request_id = ?";
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
