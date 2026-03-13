package dal;

import model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDBContext extends DBContext {

    public List<Reservation> getReservationsByReader(int readerId) {

        List<Reservation> list = new ArrayList<>();

        String sql = """
        SELECT r.reservation_id,
               r.reader_id,
               r.status,
               r.created_at,
               r.expires_at,
               r.fulfilled_at,
               r.note,
               b.title,
               ri.quantity
        FROM Reservation r
        JOIN Reservation_Item ri
            ON r.reservation_id = ri.reservation_id
        JOIN Book b
            ON ri.book_id = b.book_id
        WHERE r.reader_id = ?
        ORDER BY r.created_at DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Reservation r = new Reservation();

                    r.setReservationId(rs.getInt("reservation_id"));
                    r.setReaderId(rs.getInt("reader_id"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setExpiresAt(rs.getTimestamp("expires_at"));
                    r.setFulfilledAt(rs.getTimestamp("fulfilled_at"));
                    r.setNote(rs.getString("note"));

                    // thêm thông tin book
                    r.setBookTitle(rs.getString("title"));
                    r.setQuantity(rs.getInt("quantity"));

                    list.add(r);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void createReservation(int readerId, int bookId, int quantity) {

        try {

            connection.setAutoCommit(false);

            int reservationId = 0;

            String sql1 = """
            INSERT INTO Reservation
            (reader_id, status, created_at)
            VALUES (?, 'WAITING', GETDATE());
            SELECT SCOPE_IDENTITY();
        """;

            PreparedStatement ps1 = connection.prepareStatement(sql1);
            ps1.setInt(1, readerId);

            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                reservationId = rs.getInt(1);
            }

            String sql2 = """
            INSERT INTO Reservation_Item
            (reservation_id, book_id, quantity)
            VALUES (?, ?, ?)
        """;

            PreparedStatement ps2 = connection.prepareStatement(sql2);

            ps2.setInt(1, reservationId);
            ps2.setInt(2, bookId);
            ps2.setInt(3, quantity);

            ps2.executeUpdate();

            connection.commit();

            connection.setAutoCommit(true);

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }

            e.printStackTrace();
        }
    }

    public List<Reservation> getAllReservations() {

        List<Reservation> list = new ArrayList<>();

        try {

            String sql = """
            SELECT r.reservation_id,
                   rd.full_name,
                   b.title,
                   ri.quantity,
                   r.created_at,
                   r.status
            FROM Reservation r
            JOIN Reader rd
                ON r.reader_id = rd.reader_id
            JOIN Reservation_Item ri
                ON r.reservation_id = ri.reservation_id
            JOIN Book b
                ON ri.book_id = b.book_id
            ORDER BY r.created_at DESC
        """;

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Reservation r = new Reservation();

                r.setReservationId(rs.getInt("reservation_id"));
                r.setReaderName(rs.getString("full_name"));
                r.setBookTitle(rs.getString("title"));
                r.setQuantity(rs.getInt("quantity"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setStatus(rs.getString("status"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Reservation> getReservationQueue() {

        List<Reservation> list = new ArrayList<>();

        try {

            String sql = """
            SELECT r.reservation_id,
                   rd.full_name,
                   b.title,
                   ri.quantity,
                   r.created_at,
                   r.status
            FROM Reservation r
            JOIN Reader rd
                ON r.reader_id = rd.reader_id
            JOIN Reservation_Item ri
                ON r.reservation_id = ri.reservation_id
            JOIN Book b
                ON ri.book_id = b.book_id
            WHERE r.status = 'WAITING'
            ORDER BY r.created_at ASC
        """;

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Reservation r = new Reservation();

                r.setReservationId(rs.getInt("reservation_id"));
                r.setReaderName(rs.getString("full_name"));
                r.setBookTitle(rs.getString("title"));
                r.setQuantity(rs.getInt("quantity"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setStatus(rs.getString("status"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void fulfillReservation(int reservationId) {

        try {

            connection.setAutoCommit(false);

            // 1 lấy reservation info
            String sql1 = """
        SELECT reader_id
        FROM Reservation
        WHERE reservation_id = ?
        """;

            PreparedStatement ps1 = connection.prepareStatement(sql1);
            ps1.setInt(1, reservationId);

            ResultSet rs = ps1.executeQuery();

            int readerId = 0;

            if (rs.next()) {
                readerId = rs.getInt("reader_id");
            }

            // 2 tạo Borrow
            String sql2 = """
        INSERT INTO Borrow
        (reader_id, borrow_date, status, created_at)
        VALUES (?, GETDATE(), 'BORROWING', GETDATE())
        """;

            PreparedStatement ps2 = connection.prepareStatement(sql2);
            ps2.setInt(1, readerId);
            ps2.executeUpdate();

            // lấy borrow id
            String getBorrowId = "SELECT SCOPE_IDENTITY()";
            Statement st = connection.createStatement();
            ResultSet rs2 = st.executeQuery(getBorrowId);

            int borrowId = 0;

            if (rs2.next()) {
                borrowId = rs2.getInt(1);
            }

            // 3 lấy book từ reservation item
            String sql3 = """
        SELECT book_id, quantity
        FROM Reservation_Item
        WHERE reservation_id = ?
        """;

            PreparedStatement ps3 = connection.prepareStatement(sql3);
            ps3.setInt(1, reservationId);

            ResultSet rs3 = ps3.executeQuery();

            while (rs3.next()) {

                int bookId = rs3.getInt("book_id");

                // lấy book copy available
                String sql4 = """
            SELECT TOP 1 copy_id
            FROM BookCopy
            WHERE book_id = ?
            AND status = 'AVAILABLE'
            """;

                PreparedStatement ps4 = connection.prepareStatement(sql4);
                ps4.setInt(1, bookId);

                ResultSet rs4 = ps4.executeQuery();

                if (rs4.next()) {

                    int copyId = rs4.getInt("copy_id");

                    // tạo borrow item
                    String sql5 = """
                INSERT INTO Borrow_Item
                (borrow_id, copy_id, due_date, status)
                VALUES (?, ?, DATEADD(day,14,GETDATE()), 'BORROWING')
                """;

                    PreparedStatement ps5 = connection.prepareStatement(sql5);

                    ps5.setInt(1, borrowId);
                    ps5.setInt(2, copyId);

                    ps5.executeUpdate();

                    // update book copy
                    String sql6 = """
                UPDATE BookCopy
                SET status = 'BORROWED'
                WHERE copy_id = ?
                """;

                    PreparedStatement ps6 = connection.prepareStatement(sql6);
                    ps6.setInt(1, copyId);
                    ps6.executeUpdate();
                }
            }

            // 4 update reservation
            String sql7 = """
        UPDATE Reservation
        SET status = 'FULFILLED',
            fulfilled_at = GETDATE()
        WHERE reservation_id = ?
        """;

            PreparedStatement ps7 = connection.prepareStatement(sql7);
            ps7.setInt(1, reservationId);
            ps7.executeUpdate();

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }

            e.printStackTrace();
        }
    }

    public void cancelReservation(int reservationId) {

        try {

            String sql = """
        UPDATE Reservation
        SET status = 'CANCELLED'
        WHERE reservation_id = ?
        """;

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, reservationId);

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
