package dal;

import java.beans.Statement;
import java.sql.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.BorrowRequest;
import model.BorrowRequestItem;

public class BorrowRequestDBContext extends DBContext {

    public List<BorrowRequest> getAllRequests() {

        List<BorrowRequest> list = new ArrayList<>();

        String sql = """
                     SELECT br.request_id,
                            r.full_name,
                            br.status,
                            br.requested_at
                     FROM Borrow_Request br
                     JOIN Reader r ON br.reader_id = r.reader_id
                     ORDER BY br.requested_at DESC
                     """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowRequest br = new BorrowRequest();

                br.setRequestId(rs.getInt("request_id"));
                br.setReaderName(rs.getString("full_name"));
                br.setStatus(rs.getString("status"));
                br.setRequestedAt(rs.getTimestamp("requested_at"));

                list.add(br);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<BorrowRequest> getRequestsByPage(int page, int pageSize) {

        List<BorrowRequest> list = new ArrayList<>();

        int offset = (page - 1) * pageSize;

        String sql = """
                 SELECT br.request_id,
                        r.full_name,
                        br.status,
                        br.requested_at
                 FROM Borrow_Request br
                 JOIN Reader r ON br.reader_id = r.reader_id
                 ORDER BY br.requested_at ASC
                 OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                 """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowRequest br = new BorrowRequest();

                br.setRequestId(rs.getInt("request_id"));
                br.setReaderName(rs.getString("full_name"));
                br.setStatus(rs.getString("status"));
                br.setRequestedAt(rs.getTimestamp("requested_at"));

                list.add(br);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countRequests() {

        String sql = "SELECT COUNT(*) FROM Borrow_Request";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int createBorrowRequest(int readerId) {

        String sql = """
                     INSERT INTO Borrow_Request
                     (reader_id, status, created_at)
                     OUTPUT INSERTED.request_id
                     VALUES (?, 'pending', GETDATE())
                     """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, readerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean createBorrowRequest(int readerId, String note) {

        String sql = """
        INSERT INTO Borrow_Request
        (reader_id, status, requested_at, note)
        VALUES (?, 'PENDING', GETDATE(), ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);
            ps.setString(2, note);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getLastBorrowRequestId(int readerId) {

        String sql = """
        SELECT TOP 1 request_id
        FROM Borrow_Request
        WHERE reader_id = ?
        ORDER BY requested_at DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("request_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public List<BorrowRequest> getRequestsByReader(int readerId) {

        List<BorrowRequest> list = new ArrayList<>();

        String sql = """
        SELECT br.request_id,
               br.reader_id,
               br.status,
               br.requested_at,
               br.note,
               bri.book_id,
               bri.quantity,
               b.title
        FROM Borrow_Request br
        JOIN Borrow_Request_Item bri
            ON br.request_id = bri.request_id
        JOIN Book b
            ON b.book_id = bri.book_id
        WHERE br.reader_id = ?
        ORDER BY br.requested_at DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            ResultSet rs = ps.executeQuery();

            Map<Integer, BorrowRequest> map = new LinkedHashMap<>();

            while (rs.next()) {

                int requestId = rs.getInt("request_id");

                BorrowRequest request = map.get(requestId);

                if (request == null) {

                    request = new BorrowRequest();

                    request.setRequestId(requestId);
                    request.setReaderId(rs.getInt("reader_id"));
                    request.setStatus(rs.getString("status"));
                    request.setRequestedAt(rs.getTimestamp("requested_at"));
                    request.setNote(rs.getString("note"));

                    map.put(requestId, request);
                }

                BorrowRequestItem item = new BorrowRequestItem();

                item.setBookId(rs.getInt("book_id"));
                item.setBookTitle(rs.getString("title"));
                item.setQuantity(rs.getInt("quantity"));

                request.getItems().add(item);
            }

            list.addAll(map.values());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public BorrowRequest getRequestById(int id) {

        String sql = """
        SELECT br.request_id,
               r.full_name,
               br.status,
               br.requested_at
        FROM Borrow_Request br
        JOIN Reader r ON br.reader_id = r.reader_id
        WHERE br.request_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                BorrowRequest br = new BorrowRequest();

                br.setRequestId(rs.getInt("request_id"));
                br.setReaderName(rs.getString("full_name"));
                br.setStatus(rs.getString("status"));
                br.setRequestedAt(rs.getTimestamp("requested_at"));

                return br;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<BorrowRequestItem> getRequestItems(int requestId) {

        List<BorrowRequestItem> list = new ArrayList<>();

        String sql = """
        SELECT b.title,
               bri.quantity
        FROM Borrow_Request_Item bri
        JOIN Book b ON bri.book_id = b.book_id
        WHERE bri.request_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, requestId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowRequestItem item = new BorrowRequestItem();

                item.setBookTitle(rs.getString("title"));
                item.setQuantity(rs.getInt("quantity"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void approveRequest(int requestId, int employeeId, String dueDate, String decisionNote) {

        try {

            connection.setAutoCommit(false);

            /* UPDATE Borrow_Request */
            String updateRequest = """
            UPDATE Borrow_Request
            SET status = 'APPROVED',
                processed_by_employee_id = ?,
                processed_at = GETDATE(),
                decision_note = ?
            WHERE request_id = ?
        """;

            PreparedStatement ps1 = connection.prepareStatement(updateRequest);
            ps1.setInt(1, employeeId);
            ps1.setString(2, decisionNote);
            ps1.setInt(3, requestId);
            ps1.executeUpdate();


            /* INSERT Borrow */
            String insertBorrow = """
            INSERT INTO Borrow(reader_id, request_id, borrow_date, status, created_at, approved_by_employee_id)
            SELECT reader_id, request_id, GETDATE(), 'BORROWING', GETDATE(), ?
            FROM Borrow_Request
            WHERE request_id = ?
        """;

            PreparedStatement ps2 = connection.prepareStatement(insertBorrow);
            ps2.setInt(1, employeeId);
            ps2.setInt(2, requestId);
            ps2.executeUpdate();


            /* LẤY borrow_id */
            int borrowId = 0;

            String borrowSql = "SELECT MAX(borrow_id) AS borrow_id FROM Borrow WHERE request_id = ?";

            PreparedStatement psBorrow = connection.prepareStatement(borrowSql);
            psBorrow.setInt(1, requestId);

            ResultSet rsBorrow = psBorrow.executeQuery();

            if (rsBorrow.next()) {
                borrowId = rsBorrow.getInt("borrow_id");
            }

            if (borrowId == 0) {
                throw new Exception("Cannot create borrow record");
            }


            /* LẤY BOOK TRONG REQUEST */
            String itemsSql = """
            SELECT book_id, quantity
            FROM Borrow_Request_Item
            WHERE request_id = ?
        """;

            PreparedStatement ps3 = connection.prepareStatement(itemsSql);
            ps3.setInt(1, requestId);

            ResultSet items = ps3.executeQuery();

            while (items.next()) {

                int bookId = items.getInt("book_id");
                int quantity = items.getInt("quantity");

                for (int i = 0; i < quantity; i++) {

                    /* LẤY COPY AVAILABLE */
                    String copySql = """
                    SELECT TOP 1 copy_id
                    FROM BookCopy
                    WHERE book_id = ? AND status = 'AVAILABLE'
                """;

                    PreparedStatement psCopy = connection.prepareStatement(copySql);
                    psCopy.setInt(1, bookId);

                    ResultSet copyRs = psCopy.executeQuery();

                    if (!copyRs.next()) {
                        throw new Exception("Not enough book copies for book_id = " + bookId);
                    }

                    int copyId = copyRs.getInt("copy_id");


                    /* INSERT Borrow_Item */
                    String insertItem = """
                    INSERT INTO Borrow_Item
                    (borrow_id, copy_id, due_date, status)
                    VALUES (?, ?, ?, 'BORROWING')
                """;

                    PreparedStatement psItem = connection.prepareStatement(insertItem);

                    psItem.setInt(1, borrowId);
                    psItem.setInt(2, copyId);
                    psItem.setDate(3, java.sql.Date.valueOf(dueDate));

                    psItem.executeUpdate();


                    /* UPDATE BookCopy */
                    String updateCopy = """
                    UPDATE BookCopy
                    SET status = 'BORROWED'
                    WHERE copy_id = ?
                """;

                    PreparedStatement psUpdate = connection.prepareStatement(updateCopy);
                    psUpdate.setInt(1, copyId);
                    psUpdate.executeUpdate();
                }
            }

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
        }
    }

    public void rejectRequest(int requestId, int employeeId, String decisionNote) {

        try {

            String sql = """
            UPDATE Borrow_Request
            SET status = 'REJECTED',
                processed_by_employee_id = ?,
                processed_at = GETDATE(),
                decision_note = ?
            WHERE request_id = ?
        """;

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, employeeId);
            ps.setString(2, decisionNote);
            ps.setInt(3, requestId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public ArrayList list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Object get(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void insert(Object model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Object model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Object model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
