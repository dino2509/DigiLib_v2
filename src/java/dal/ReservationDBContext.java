package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.ReservationRequest;

/**
 * Reservation (đặt trước) DAO
 *
 * status:
 *  - WAITING
 *  - CONVERTED
 *  - CANCELLED
 */
public class ReservationDBContext extends DBContext<ReservationRequest> {

    @Override
    public ArrayList<ReservationRequest> list() {
        // not used
        return new ArrayList<>();
    }

    @Override
    public ReservationRequest get(int id) {
        String sql = "SELECT rr.reservation_id, rr.reader_id, rd.full_name AS reader_name, "
                + "rr.book_id, b.title AS book_title, rr.status, rr.created_at, "
                + "rr.converted_request_id, rr.converted_at "
                + "FROM Reservation_Request rr "
                + "INNER JOIN Reader rd ON rd.reader_id = rr.reader_id "
                + "INNER JOIN Book b ON b.book_id = rr.book_id "
                + "WHERE rr.reservation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ReservationRequest r = map(rs);
                r.setPosition(getPositionOfReservation(r.getBookId(), r.getReservationId()));
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void insert(ReservationRequest model) {
        throw new UnsupportedOperationException("Use createWaiting(readerId, bookId).");
    }

    @Override
    public void update(ReservationRequest model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void delete(ReservationRequest model) {
        throw new UnsupportedOperationException("Use cancel(...)");
    }

    // =========================================================
    // Core
    // =========================================================

    /**
     * Reader đặt trước (WAITING) nếu chưa có WAITING cho cùng book
     * @return reservation_id hoặc null nếu đã có WAITING
     */
    public Integer createWaiting(int readerId, int bookId) {
        try {
            connection.setAutoCommit(false);

            if (hasWaiting(readerId, bookId)) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            String sql = "INSERT INTO Reservation_Request(reader_id, book_id, status, created_at, converted_request_id, converted_at) "
                    + "OUTPUT INSERTED.reservation_id "
                    + "VALUES(?, ?, N'WAITING', SYSDATETIME(), NULL, NULL)";
            int rid;
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, readerId);
                ps.setInt(2, bookId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                rid = rs.getInt(1);
            }

            connection.commit();
            connection.setAutoCommit(true);
            return rid;
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

    public boolean hasWaiting(int readerId, int bookId) {
        String sql = "SELECT TOP 1 reservation_id "
                + "FROM Reservation_Request "
                + "WHERE reader_id = ? AND book_id = ? AND status = N'WAITING'";
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
     * Lấy reservation WAITING của reader cho book + tính position trong hàng đợi
     */
    public ReservationRequest getWaitingByReaderAndBook(int readerId, int bookId) {
        String sql = "SELECT TOP 1 rr.reservation_id, rr.reader_id, rd.full_name AS reader_name, "
                + "rr.book_id, b.title AS book_title, rr.status, rr.created_at, "
                + "rr.converted_request_id, rr.converted_at "
                + "FROM Reservation_Request rr "
                + "INNER JOIN Reader rd ON rd.reader_id = rr.reader_id "
                + "INNER JOIN Book b ON b.book_id = rr.book_id "
                + "WHERE rr.reader_id = ? AND rr.book_id = ? AND rr.status = N'WAITING' "
                + "ORDER BY rr.created_at ASC, rr.reservation_id ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ReservationRequest r = map(rs);
                r.setPosition(getPositionOfReservation(bookId, r.getReservationId()));
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Danh sách hàng đợi theo book (WAITING), có position
     */
    public ArrayList<ReservationRequest> listQueueByBook(int bookId) {
        ArrayList<ReservationRequest> list = new ArrayList<>();

        String sql = "SELECT rr.reservation_id, rr.reader_id, rd.full_name AS reader_name, "
                + "rr.book_id, b.title AS book_title, rr.status, rr.created_at, "
                + "rr.converted_request_id, rr.converted_at "
                + "FROM Reservation_Request rr "
                + "INNER JOIN Reader rd ON rd.reader_id = rr.reader_id "
                + "INNER JOIN Book b ON b.book_id = rr.book_id "
                + "WHERE rr.book_id = ? AND rr.status = N'WAITING' "
                + "ORDER BY rr.created_at ASC, rr.reservation_id ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            int pos = 1;
            while (rs.next()) {
                ReservationRequest r = map(rs);
                r.setPosition(pos++);
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Reader huỷ đặt trước (chỉ huỷ được WAITING)
     */
    public boolean cancel(int reservationId, int readerId) {
        String sql = "UPDATE Reservation_Request "
                + "SET status = N'CANCELLED' "
                + "WHERE reservation_id = ? AND reader_id = ? AND status = N'WAITING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Librarian huỷ đặt trước (chỉ huỷ được WAITING)
     */
    public boolean cancelByLibrarian(int reservationId) {
        String sql = "UPDATE Reservation_Request "
                + "SET status = N'CANCELLED' "
                + "WHERE reservation_id = ? AND status = N'WAITING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // History lists (Reader/Librarian merged page)
    // =========================================================

    /**
     * Reader history list.
     * filter:
     *  - reserved  => WAITING
     *  - approved  => CONVERTED
     *  - rejected  => CANCELLED
     *  - all       => all statuses
     */
    public ArrayList<ReservationRequest> listByReader(int readerId, String filter, int limit) {
        ArrayList<ReservationRequest> list = new ArrayList<>();
        if (limit <= 0) limit = 200;

        String where = " WHERE rr.reader_id = ? ";
        if (filter == null) filter = "all";
        filter = filter.trim().toLowerCase();
        switch (filter) {
            case "reserved" -> where += " AND rr.status = N'WAITING' ";
            case "approved" -> where += " AND rr.status = N'CONVERTED' ";
            case "rejected" -> where += " AND rr.status = N'CANCELLED' ";
            case "all" -> {
            }
            default -> {
            }
        }

        // Compute queue position for WAITING with ROW_NUMBER()
        String sql = "SELECT TOP (?) rr.reservation_id, rr.reader_id, rd.full_name AS reader_name, "
                + "rr.book_id, b.title AS book_title, rr.status, rr.created_at, "
                + "rr.converted_request_id, rr.converted_at, "
                + "CASE WHEN rr.status = N'WAITING' THEN "
                + "  ROW_NUMBER() OVER(PARTITION BY rr.book_id ORDER BY rr.created_at ASC, rr.reservation_id ASC) "
                + "ELSE NULL END AS pos "
                + "FROM Reservation_Request rr "
                + "INNER JOIN Reader rd ON rd.reader_id = rr.reader_id "
                + "INNER JOIN Book b ON b.book_id = rr.book_id "
                + where
                + "ORDER BY rr.created_at DESC, rr.reservation_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReservationRequest r = map(rs);
                int p = rs.getInt("pos");
                r.setPosition(rs.wasNull() ? null : p);
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Librarian history list.
     * filter mapping giống listByReader.
     */
    public ArrayList<ReservationRequest> listForLibrarian(String filter, int limit) {
        ArrayList<ReservationRequest> list = new ArrayList<>();
        if (limit <= 0) limit = 200;

        String where = " WHERE 1=1 ";
        if (filter == null) filter = "all";
        filter = filter.trim().toLowerCase();
        switch (filter) {
            case "reserved" -> where += " AND rr.status = N'WAITING' ";
            case "approved" -> where += " AND rr.status = N'CONVERTED' ";
            case "rejected" -> where += " AND rr.status = N'CANCELLED' ";
            case "all" -> {
            }
            default -> {
            }
        }

        String sql = "SELECT TOP (?) rr.reservation_id, rr.reader_id, rd.full_name AS reader_name, "
                + "rr.book_id, b.title AS book_title, rr.status, rr.created_at, "
                + "rr.converted_request_id, rr.converted_at, "
                + "CASE WHEN rr.status = N'WAITING' THEN "
                + "  ROW_NUMBER() OVER(PARTITION BY rr.book_id ORDER BY rr.created_at ASC, rr.reservation_id ASC) "
                + "ELSE NULL END AS pos "
                + "FROM Reservation_Request rr "
                + "INNER JOIN Reader rd ON rd.reader_id = rr.reader_id "
                + "INNER JOIN Book b ON b.book_id = rr.book_id "
                + where
                + "ORDER BY rr.created_at DESC, rr.reservation_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReservationRequest r = map(rs);
                int p = rs.getInt("pos");
                r.setPosition(rs.wasNull() ? null : p);
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================================================
    // Auto convert queue -> Borrow_Request (PENDING)
    // =========================================================

    /**
     * Khi có copy AVAILABLE, tự động convert từng người đầu hàng đợi thành Borrow_Request (PENDING).
     * Convert tối đa bằng số copy AVAILABLE hiện tại.
     *
     * @return số reservation đã convert
     */
    public int processQueueForBook(int bookId) {
        int converted = 0;

        try {
            connection.setAutoCommit(false);

            int available = countAvailableCopies(bookId);
            if (available <= 0) {
                connection.commit();
                connection.setAutoCommit(true);
                return 0;
            }

            while (available > 0) {
                Integer reservationId = getFirstWaitingReservationId(bookId);
                if (reservationId == null) break;

                ReservationRequest first = get(reservationId);
                if (first == null || !"WAITING".equalsIgnoreCase(first.getStatus())) break;

                // tạo Borrow_Request (PENDING)
                BorrowRequestDBContext br = new BorrowRequestDBContext();
                br.connection = this.connection; // dùng chung transaction/connection
                Integer requestId = br.createSingleBookRequest(first.getReaderId(), bookId);
                if (requestId == null) {
                    // nếu không tạo được (đã có pending), đánh CANCELLED để tránh kẹt queue
                    markCancelled(reservationId);
                    // không trừ available
                    continue;
                }

                // mark CONVERTED
                String upd = "UPDATE Reservation_Request "
                        + "SET status = N'CONVERTED', converted_request_id = ?, converted_at = SYSDATETIME() "
                        + "WHERE reservation_id = ? AND status = N'WAITING'";
                try (PreparedStatement ps = connection.prepareStatement(upd)) {
                    ps.setInt(1, requestId);
                    ps.setInt(2, reservationId);
                    int n = ps.executeUpdate();
                    if (n > 0) {
                        converted++;
                        available--; // mỗi copy AVAILABLE -> 1 người được chuyển sang Borrow_Request
                    } else {
                        break;
                    }
                }
            }

            connection.commit();
            connection.setAutoCommit(true);
            return converted;

        } catch (Exception e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return converted;
        }
    }

    // =========================================================
    // Helpers
    // =========================================================

    private ReservationRequest map(ResultSet rs) throws SQLException {
        ReservationRequest r = new ReservationRequest();
        r.setReservationId(rs.getInt("reservation_id"));
        r.setReaderId(rs.getInt("reader_id"));
        r.setReaderName(rs.getString("reader_name"));
        r.setBookId(rs.getInt("book_id"));
        r.setBookTitle(rs.getString("book_title"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at"));

        int cr = rs.getInt("converted_request_id");
        r.setConvertedRequestId(rs.wasNull() ? null : cr);
        r.setConvertedAt(rs.getTimestamp("converted_at"));
        return r;
    }

    private Integer getFirstWaitingReservationId(int bookId) {
        String sql = "SELECT TOP 1 reservation_id "
                + "FROM Reservation_Request "
                + "WHERE book_id = ? AND status = N'WAITING' "
                + "ORDER BY created_at ASC, reservation_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private void markCancelled(int reservationId) {
        String sql = "UPDATE Reservation_Request SET status = N'CANCELLED' WHERE reservation_id = ? AND status = N'WAITING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private int countAvailableCopies(int bookId) {
        String sql = "SELECT COUNT(*) FROM BookCopy WHERE book_id = ? AND status = N'AVAILABLE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * position = số WAITING trước nó + 1
     */
    private Integer getPositionOfReservation(int bookId, int reservationId) {
        String sql = "SELECT COUNT(*) + 1 AS pos "
                + "FROM Reservation_Request rr "
                + "WHERE rr.book_id = ? AND rr.status = N'WAITING' "
                + "AND (rr.created_at < (SELECT created_at FROM Reservation_Request WHERE reservation_id = ?) "
                + "OR (rr.created_at = (SELECT created_at FROM Reservation_Request WHERE reservation_id = ?) AND rr.reservation_id < ?))";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.setInt(2, reservationId);
            ps.setInt(3, reservationId);
            ps.setInt(4, reservationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("pos");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}