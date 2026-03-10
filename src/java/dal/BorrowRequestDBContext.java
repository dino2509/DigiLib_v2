package dal;

import java.sql.*;
import java.util.*;
import model.*;

public class BorrowRequestDBContext extends DBContext {

    public List<BorrowRequest> getAllRequests() {

        List<BorrowRequest> list = new ArrayList<>();

        String sql = """
            SELECT br.*, r.full_name
            FROM Borrow_Request br
            JOIN Reader r ON br.reader_id = r.reader_id
            ORDER BY br.requested_at DESC
        """;

        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {

                BorrowRequest br = new BorrowRequest();

                br.setRequestId(rs.getInt("request_id"));
                br.setReaderId(rs.getInt("reader_id"));
                br.setStatus(rs.getString("status"));
                br.setRequestedAt(rs.getTimestamp("requested_at"));

                Reader r = new Reader();
                r.setFullName(rs.getString("full_name"));

                br.setReader(r);

                list.add(br);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void approveRequest(int requestId, int employeeId) {

        String sql = """
            UPDATE Borrow_Request
            SET status = 'APPROVED',
                processed_by_employee_id = ?,
                processed_at = GETDATE()
            WHERE request_id = ?
        """;

        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, employeeId);
            stm.setInt(2, requestId);
            stm.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void rejectRequest(int requestId, int employeeId, String note) {

        String sql = """
            UPDATE Borrow_Request
            SET status = 'REJECTED',
                processed_by_employee_id = ?,
                processed_at = GETDATE(),
                decision_note = ?
            WHERE request_id = ?
        """;

        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, employeeId);
            stm.setString(2, note);
            stm.setInt(3, requestId);
            stm.executeUpdate();

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
