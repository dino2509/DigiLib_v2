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
