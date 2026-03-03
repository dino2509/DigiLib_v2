package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;
import model.ReturnRequest;
import dal.ReservationDBContext;

/**
 * Return Request DAO
 */
public class ReturnRequestDBContext extends DBContext<ReturnRequest> {

    // ===== Required abstract overrides from DBContext =====
    @Override
    public java.util.ArrayList<ReturnRequest> list() {
        // bạn chưa dùng list() tổng quát ở đâu -> trả rỗng cho an toàn
        return new java.util.ArrayList<>();
    }

    @Override
    public ReturnRequest get(int id) {
        // project hiện không cần get detail return request ở UI
        return null;
    }

    @Override
    public void insert(ReturnRequest model) {
        throw new UnsupportedOperationException("Use createByReader / createAndAutoConfirmByLibrarian instead.");
    }

    @Override
    public void update(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void delete(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported.");
    }
    // =====================================================

    // =====================================================
    // Reader-side
    // =====================================================

    public boolean hasPendingForBorrowItem(int borrowItemId) {
        String sql = "SELECT TOP 1 r.return_request_id "
                + "FROM Return_Request r "
                + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                + "WHERE r.status = N'PENDING' AND i.borrow_item_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Integer getPendingReturnRequestIdByBorrowItem(int borrowItemId) {
        String sql = "SELECT TOP 1 r.return_request_id "
                + "FROM Return_Request r "
                + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                + "WHERE r.status = N'PENDING' AND i.borrow_item_id = ? "
                + "ORDER BY r.created_at ASC, r.return_request_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Reader tạo Return_Request (PENDING) cho 1 Borrow_Item đang mượn.
     * @return return_request_id hoặc null nếu lỗi/đã có pending/đã trả
     */
    public Integer createByReader(int readerId, int borrowItemId) {
        try {
            connection.setAutoCommit(false);

            // borrow_item phải thuộc reader + chưa returned
            String chk = "SELECT TOP 1 bi.borrow_item_id "
                    + "FROM Borrow_Item bi "
                    + "INNER JOIN Borrow b ON b.borrow_id = bi.borrow_id "
                    + "WHERE bi.borrow_item_id = ? AND b.reader_id = ? AND bi.returned_at IS NULL";
            boolean ok = false;
            try (PreparedStatement ps = connection.prepareStatement(chk)) {
                ps.setInt(1, borrowItemId);
                ps.setInt(2, readerId);
                ResultSet rs = ps.executeQuery();
                ok = rs.next();
            }
            if (!ok) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            if (hasPendingForBorrowItem(borrowItemId)) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            int requestId;
            String insHead = "INSERT INTO Return_Request (reader_id, created_by_employee_id, created_by_type, status, created_at, "
                    + "confirmed_by_employee_id, confirmed_at, note) "
                    + "OUTPUT INSERTED.return_request_id "
                    + "VALUES (?, NULL, N'READER', N'PENDING', SYSDATETIME(), NULL, NULL, NULL)";
            try (PreparedStatement ps = connection.prepareStatement(insHead)) {
                ps.setInt(1, readerId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                requestId = rs.getInt(1);
            }

            String insItem = "INSERT INTO Return_Request_Item (return_request_id, borrow_item_id) VALUES (?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(insItem)) {
                ps.setInt(1, requestId);
                ps.setInt(2, borrowItemId);
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

    // =====================================================
    // Librarian-side
    // =====================================================

    /**
     * Librarian bấm "Trả sách" trên /librarian/borrowed-books:
     * - Nếu đã có request PENDING (do reader tạo) -> confirm request đó
     * - Nếu chưa có -> tạo request LIBRARIAN và auto confirm
     */
    public boolean confirmOrCreateAndAutoConfirm(int employeeId, int borrowItemId) {
        Integer pendingId = getPendingReturnRequestIdByBorrowItem(borrowItemId);
        if (pendingId != null) {
            return confirm(employeeId, pendingId);
        }
        return createAndAutoConfirmByLibrarian(employeeId, borrowItemId) != null;
    }

    public Integer createAndAutoConfirmByLibrarian(int employeeId, int borrowItemId) {
        try {
            connection.setAutoCommit(false);

            int readerId;
            int copyId;
            int borrowId;

            String chk = "SELECT TOP 1 br.reader_id, bi.copy_id, bi.borrow_id "
                    + "FROM Borrow_Item bi "
                    + "INNER JOIN Borrow br ON br.borrow_id = bi.borrow_id "
                    + "WHERE bi.borrow_item_id = ? AND bi.returned_at IS NULL";
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

            if (hasPendingForBorrowItem(borrowItemId)) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            int requestId;
            String insHead = "INSERT INTO Return_Request (reader_id, created_by_employee_id, created_by_type, status, created_at, "
                    + "confirmed_by_employee_id, confirmed_at, note) "
                    + "OUTPUT INSERTED.return_request_id "
                    + "VALUES (?, ?, N'LIBRARIAN', N'CONFIRMED', SYSDATETIME(), ?, SYSDATETIME(), NULL)";
            try (PreparedStatement ps = connection.prepareStatement(insHead)) {
                ps.setInt(1, readerId);
                ps.setInt(2, employeeId);
                ps.setInt(3, employeeId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                requestId = rs.getInt(1);
            }

            String insItem = "INSERT INTO Return_Request_Item (return_request_id, borrow_item_id) VALUES (?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(insItem)) {
                ps.setInt(1, requestId);
                ps.setInt(2, borrowItemId);
                ps.executeUpdate();
            }

            String updBorrowItem = "UPDATE Borrow_Item SET returned_at = SYSDATETIME(), status = N'RETURNED' "
                    + "WHERE borrow_item_id = ? AND returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(updBorrowItem)) {
                ps.setInt(1, borrowItemId);
                ps.executeUpdate();
            }

            String updCopy = "UPDATE BookCopy SET status = N'AVAILABLE' WHERE copy_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updCopy)) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }

            // ✅ Auto process reservation queue when a copy becomes AVAILABLE
            Integer bookId = getBookIdByCopyId(copyId);
            if (bookId != null) {
                ReservationDBContext resDao = new ReservationDBContext();
                resDao.connection = this.connection; // share transaction
                resDao.processQueueForBook(bookId);
            }

            updateBorrowCompletedIfNeeded(borrowId);

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
     * Confirm request PENDING -> CONFIRMED + update Borrow_Item + BookCopy
     */
    public boolean confirm(int employeeId, int returnRequestId) {
        try {
            connection.setAutoCommit(false);

            int borrowItemId;
            String getBorrowItem = "SELECT TOP 1 i.borrow_item_id "
                    + "FROM Return_Request r "
                    + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                    + "WHERE r.return_request_id = ? AND r.status = N'PENDING'";
            try (PreparedStatement ps = connection.prepareStatement(getBorrowItem)) {
                ps.setInt(1, returnRequestId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
                borrowItemId = rs.getInt(1);
            }

            int copyId;
            int borrowId;
            String q = "SELECT copy_id, borrow_id FROM Borrow_Item WHERE borrow_item_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(q)) {
                ps.setInt(1, borrowItemId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
                copyId = rs.getInt("copy_id");
                borrowId = rs.getInt("borrow_id");
            }

            String updReq = "UPDATE Return_Request SET status = N'CONFIRMED', confirmed_by_employee_id = ?, confirmed_at = SYSDATETIME() "
                    + "WHERE return_request_id = ? AND status = N'PENDING'";
            try (PreparedStatement ps = connection.prepareStatement(updReq)) {
                ps.setInt(1, employeeId);
                ps.setInt(2, returnRequestId);
                int n = ps.executeUpdate();
                if (n == 0) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
            }

            String updBorrowItem = "UPDATE Borrow_Item SET returned_at = SYSDATETIME(), status = N'RETURNED' "
                    + "WHERE borrow_item_id = ? AND returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(updBorrowItem)) {
                ps.setInt(1, borrowItemId);
                ps.executeUpdate();
            }

            String updCopy = "UPDATE BookCopy SET status = N'AVAILABLE' WHERE copy_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updCopy)) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }

            // ✅ Auto process reservation queue when a copy becomes AVAILABLE
            Integer bookId = getBookIdByCopyId(copyId);
            if (bookId != null) {
                ReservationDBContext resDao = new ReservationDBContext();
                resDao.connection = this.connection; // share transaction
                resDao.processQueueForBook(bookId);
            }

            updateBorrowCompletedIfNeeded(borrowId);

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

    public Set<Integer> listPendingBorrowItemIdsByReader(int readerId) {
        Set<Integer> set = new HashSet<>();
        String sql = "SELECT i.borrow_item_id "
                + "FROM Return_Request r "
                + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                + "WHERE r.reader_id = ? AND r.status = N'PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) set.add(rs.getInt(1));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return set;
    }

    private void updateBorrowCompletedIfNeeded(int borrowId) throws SQLException {
        String cntSql = "SELECT COUNT(*) FROM Borrow_Item WHERE borrow_id = ? AND returned_at IS NULL";
        int remain = 0;
        try (PreparedStatement ps = connection.prepareStatement(cntSql)) {
            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) remain = rs.getInt(1);
        }
        if (remain == 0) {
            String upd = "UPDATE Borrow SET status = N'COMPLETED' WHERE borrow_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(upd)) {
                ps.setInt(1, borrowId);
                ps.executeUpdate();
            }
        }
    }

    private Integer getBookIdByCopyId(int copyId) {
        String sql = "SELECT book_id FROM BookCopy WHERE copy_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, copyId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}