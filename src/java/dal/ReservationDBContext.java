package dal;

import model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDBContext extends DBContext {

    public int fulfillReservation(int reservationId) throws SQLException {

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            connection.setAutoCommit(false);

            /* 1. Get reservation info */
            String getReservation = """
            SELECT r.reader_id, ri.book_id, ri.quantity
            FROM Reservation r
            JOIN Reservation_Item ri 
                ON r.reservation_id = ri.reservation_id
            WHERE r.reservation_id = ?
        """;

            ps = connection.prepareStatement(getReservation);
            ps.setInt(1, reservationId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                throw new SQLException("Reservation not found");
            }

            int readerId = rs.getInt("reader_id");
            int bookId = rs.getInt("book_id");
            int quantity = rs.getInt("quantity");

            rs.close();
            ps.close();

            /* 2. Create Borrow_Request */
            String insertRequest = """
            INSERT INTO Borrow_Request
            (reader_id, status, requested_at)
            VALUES (?, 'PENDING', GETDATE())
        """;

            ps = connection.prepareStatement(insertRequest,
                    Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, readerId);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int requestId = -1;

            if (rs.next()) {
                requestId = rs.getInt(1);
            }

            rs.close();
            ps.close();

            /* 3. Create Borrow_Request_Item */
            String insertItem = """
            INSERT INTO Borrow_Request_Item
            (request_id, book_id, quantity)
            VALUES (?, ?, ?)
        """;

            ps = connection.prepareStatement(insertItem);
            ps.setInt(1, requestId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            ps.executeUpdate();

            ps.close();

            /* 4. Update Reservation */
            String updateReservation = """
            UPDATE Reservation
            SET status = 'FULFILLED',
                fulfilled_at = GETDATE()
            WHERE reservation_id = ?
        """;

            ps = connection.prepareStatement(updateReservation);
            ps.setInt(1, reservationId);
            ps.executeUpdate();

            connection.commit();
            return requestId;

        } catch (SQLException e) {

            connection.rollback();
            throw e;

        } finally {

            connection.setAutoCommit(true);

            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
        }
    }

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

    public int countByReader(int readerId) {

        String sql = "SELECT COUNT(*) FROM Reservation WHERE reader_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Reservation> getReservationsByReaderPaging(int readerId, int page, int pageSize) {

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
        JOIN Reservation_Item ri ON r.reservation_id = ri.reservation_id
        JOIN Book b ON ri.book_id = b.book_id
        WHERE r.reader_id = ?
        ORDER BY r.created_at DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, readerId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Reservation r = new Reservation();

                r.setReservationId(rs.getInt("reservation_id"));
                r.setReaderId(rs.getInt("reader_id"));
                r.setStatus(rs.getString("status"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setExpiresAt(rs.getTimestamp("expires_at"));
                r.setFulfilledAt(rs.getTimestamp("fulfilled_at"));
                r.setNote(rs.getString("note"));

                r.setBookTitle(rs.getString("title"));
                r.setQuantity(rs.getInt("quantity"));

                list.add(r);
            }

        } catch (Exception e) {
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

    public int countReservations(String search, String status) {

        StringBuilder sql = new StringBuilder("""

SELECT COUNT(*)

FROM Reservation r

JOIN Reader rd
ON r.reader_id = rd.reader_id

JOIN Reservation_Item ri
ON r.reservation_id = ri.reservation_id

JOIN Book b
ON ri.book_id = b.book_id

WHERE 1=1

""");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (rd.full_name LIKE ? OR b.title LIKE ?) ");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND r.status = ? ");
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

    public List<Reservation> getReservations(
            String search,
            String status,
            int page,
            int pageSize) {

        List<Reservation> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""

SELECT
r.reservation_id,
rd.full_name,
b.title,
ri.quantity,
r.created_at,
r.status,

(
SELECT COUNT(*)
FROM BookCopy bc
WHERE bc.book_id = b.book_id
AND bc.status = 'AVAILABLE'
) AS available_copies

FROM Reservation r

JOIN Reader rd
ON r.reader_id = rd.reader_id

JOIN Reservation_Item ri
ON r.reservation_id = ri.reservation_id

JOIN Book b
ON ri.book_id = b.book_id

WHERE 1=1

""");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (rd.full_name LIKE ? OR b.title LIKE ?) ");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND r.status = ? ");
        }

        sql.append("""

ORDER BY r.created_at DESC
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

                Reservation r = new Reservation();

                r.setReservationId(rs.getInt("reservation_id"));
                r.setReaderName(rs.getString("full_name"));
                r.setBookTitle(rs.getString("title"));
                r.setQuantity(rs.getInt("quantity"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setStatus(rs.getString("status"));

                r.setAvailableCopies(rs.getInt("available_copies"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
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
