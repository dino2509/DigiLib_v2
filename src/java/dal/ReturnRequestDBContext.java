package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;
import model.ReturnRequest;

public class ReturnRequestDBContext extends DBContext<ReturnRequest> {

    @Override
    public java.util.ArrayList<ReturnRequest> list() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ReturnRequest get(int id) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void insert(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void update(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete(ReturnRequest model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    /**
     * List all Borrow_Item ids that already have a PENDING Return_Request of the given reader.
     * Used to disable "Trả sách" button in reader borrowed history.
     */
    public Set<Integer> listPendingBorrowItemIdsByReader(int readerId) {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT DISTINCT i.borrow_item_id "
                + "FROM Return_Request r "
                + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                + "WHERE r.status = N'PENDING' AND r.reader_id = ?";
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

    /**
     * Reader creates a return request (PENDING) for a specific Borrow_Item.
     * - Borrow_Item must belong to the reader
     * - Borrow_Item must NOT be returned yet
     * - Must NOT already have a PENDING return request for that Borrow_Item
     *
     * @return return_request_id if created, otherwise null
     */
    public Integer createByReader(int readerId, int borrowItemId) {
        try {
            connection.setAutoCommit(false);

            // Validate: borrow item exists, belongs to reader, not returned
            String chk = "SELECT TOP 1 bi.borrow_item_id "
                    + "FROM Borrow_Item bi "
                    + "INNER JOIN Borrow b ON b.borrow_id = bi.borrow_id "
                    + "WHERE bi.borrow_item_id = ? AND b.reader_id = ? AND bi.returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(chk)) {
                ps.setInt(1, borrowItemId);
                ps.setInt(2, readerId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return null;
                }
            }

            // Prevent duplicate pending request for this borrow_item
            Integer existingPending = getPendingReturnRequestIdByBorrowItem(borrowItemId);
            if (existingPending != null) {
                connection.rollback();
                connection.setAutoCommit(true);
                return null;
            }

            // Create Return_Request
            int requestId;
            String insReq = "INSERT INTO Return_Request(reader_id, created_by_employee_id, created_by_type, status, created_at, note) "
                    + "OUTPUT INSERTED.return_request_id "
                    + "VALUES(?, NULL, N'READER', N'PENDING', SYSDATETIME(), N'Reader yêu cầu trả sách')";
            try (PreparedStatement ps = connection.prepareStatement(insReq)) {
                ps.setInt(1, readerId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return null;
                }
                requestId = rs.getInt(1);
            }

            // Insert Return_Request_Item
            String insItem = "INSERT INTO Return_Request_Item(return_request_id, borrow_item_id) VALUES(?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(insItem)) {
                ps.setInt(1, requestId);
                ps.setInt(2, borrowItemId);
                ps.executeUpdate();
            }

            connection.commit();
            connection.setAutoCommit(true);
            return requestId;

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

    /**
     * Find pending return_request_id for a borrow_item
     */
    public Integer getPendingReturnRequestIdByBorrowItem(int borrowItemId) {
        String sql = "SELECT TOP 1 r.return_request_id "
                + "FROM Return_Request r "
                + "INNER JOIN Return_Request_Item i ON i.return_request_id = r.return_request_id "
                + "WHERE r.status = N'PENDING' AND i.borrow_item_id = ? "
                + "ORDER BY r.created_at ASC, r.return_request_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, borrowItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean confirmOrCreateAndAutoConfirm(int employeeId, int borrowItemId) {
        return confirmOrCreateAndAutoConfirm(employeeId, borrowItemId, null, null);
    }

    /**
     * Confirm return (and optionally add damage fine).
     */
    public boolean confirmOrCreateAndAutoConfirm(int employeeId, int borrowItemId, java.math.BigDecimal damageAmount, String damageReason) {
        Integer pendingId = getPendingReturnRequestIdByBorrowItem(borrowItemId);
        if (pendingId != null) {
            return confirm(employeeId, pendingId, damageAmount, damageReason);
        }
        return createAndAutoConfirmByLibrarian(employeeId, borrowItemId, damageAmount, damageReason) != null;
    }

    public Integer createAndAutoConfirmByLibrarian(int employeeId, int borrowItemId) {
        return createAndAutoConfirmByLibrarian(employeeId, borrowItemId, null, null);
    }

    public Integer createAndAutoConfirmByLibrarian(int employeeId, int borrowItemId, java.math.BigDecimal damageAmount, String damageReason) {
        try {
            connection.setAutoCommit(false);

            // Check borrow_item exists and not returned
            int readerId;
            int copyId;
            int borrowId;
            java.sql.Timestamp dueDate;

            String chk = "SELECT TOP 1 br.reader_id, bi.copy_id, bi.borrow_id, bi.due_date "
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
                dueDate = rs.getTimestamp("due_date");
            }

            // Create Return_Request
            int requestId;
            String insReq = "INSERT INTO Return_Request(reader_id, created_by_employee_id, created_by_type, status, created_at, "
                    + "confirmed_by_employee_id, confirmed_at, note) "
                    + "OUTPUT INSERTED.return_request_id "
                    + "VALUES(?, ?, N'LIBRARIAN', N'CONFIRMED', SYSDATETIME(), ?, SYSDATETIME(), N'Trả sách trực tiếp bởi thủ thư')";
            try (PreparedStatement ps = connection.prepareStatement(insReq)) {
                ps.setInt(1, readerId);
                ps.setInt(2, employeeId);
                ps.setInt(3, employeeId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return null;
                }
                requestId = rs.getInt(1);
            }

            // Insert Return_Request_Item
            String insItem = "INSERT INTO Return_Request_Item(return_request_id, borrow_item_id) VALUES(?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(insItem)) {
                ps.setInt(1, requestId);
                ps.setInt(2, borrowItemId);
                ps.executeUpdate();
            }

            // Update borrow_item -> returned
            String updBorrowItem = "UPDATE Borrow_Item SET returned_at = SYSDATETIME(), status = N'RETURNED' "
                    + "WHERE borrow_item_id = ? AND returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(updBorrowItem)) {
                ps.setInt(1, borrowItemId);
                ps.executeUpdate();
            }

            // Update BookCopy -> AVAILABLE
            String updCopy = "UPDATE BookCopy SET status = N'AVAILABLE' WHERE copy_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updCopy)) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }

            updateBorrowCompletedIfNeeded(borrowId);

            // ===== Create fines (overdue + damage) =====
            FineDBContext fineDao = new FineDBContext();
            fineDao.connection = this.connection; // share transaction
            fineDao.ensureDefaultFineTypes();
            fineDao.createOrUpdateOverdueFineAtReturn(readerId, borrowItemId);
            fineDao.createDamageFine(readerId, borrowItemId, damageAmount, damageReason);

            connection.commit();
            connection.setAutoCommit(true);
            return requestId;

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

    /**
     * Confirm request PENDING -> CONFIRMED + update Borrow_Item + BookCopy
     */
    public boolean confirm(int employeeId, int returnRequestId) {
        return confirm(employeeId, returnRequestId, null, null);
    }

    public boolean confirm(int employeeId, int returnRequestId, java.math.BigDecimal damageAmount, String damageReason) {
        try {
            connection.setAutoCommit(false);

            // get borrow_item_id from request
            int borrowItemId;
            String qItem = "SELECT TOP 1 borrow_item_id FROM Return_Request_Item WHERE return_request_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(qItem)) {
                ps.setInt(1, returnRequestId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return false;
                }
                borrowItemId = rs.getInt("borrow_item_id");
            }

            // update request status
            String updReq = "UPDATE Return_Request SET status = N'CONFIRMED', confirmed_by_employee_id = ?, confirmed_at = SYSDATETIME() "
                    + "WHERE return_request_id = ? AND status = N'PENDING'";
            int changed;
            try (PreparedStatement ps = connection.prepareStatement(updReq)) {
                ps.setInt(1, employeeId);
                ps.setInt(2, returnRequestId);
                changed = ps.executeUpdate();
            }
            if (changed == 0) {
                connection.rollback();
                connection.setAutoCommit(true);
                return false;
            }

            // get copy_id + borrow_id + reader_id
            int copyId;
            int borrowId;
            int readerId;
            String q = "SELECT bi.copy_id, bi.borrow_id, b.reader_id FROM Borrow_Item bi "
                    + "INNER JOIN Borrow b ON b.borrow_id = bi.borrow_id "
                    + "WHERE bi.borrow_item_id = ?";
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
                readerId = rs.getInt("reader_id");
            }

            // Update borrow_item -> returned
            String updBorrowItem = "UPDATE Borrow_Item SET returned_at = SYSDATETIME(), status = N'RETURNED' "
                    + "WHERE borrow_item_id = ? AND returned_at IS NULL";
            try (PreparedStatement ps = connection.prepareStatement(updBorrowItem)) {
                ps.setInt(1, borrowItemId);
                ps.executeUpdate();
            }

            // Update BookCopy -> AVAILABLE
            String updCopy = "UPDATE BookCopy SET status = N'AVAILABLE' WHERE copy_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updCopy)) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }

            updateBorrowCompletedIfNeeded(borrowId);

            // ===== Create fines (overdue + damage) =====
            FineDBContext fineDao = new FineDBContext();
            fineDao.connection = this.connection; // share transaction
            fineDao.ensureDefaultFineTypes();
            fineDao.createOrUpdateOverdueFineAtReturn(readerId, borrowItemId);
            fineDao.createDamageFine(readerId, borrowItemId, damageAmount, damageReason);

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

    /**
     * Reject a return request (just means: not received yet / invalid). Does NOT mark Borrow_Item returned.
     */
    public boolean reject(int employeeId, int returnRequestId, String decisionNote) {
        try {
            String updReq = "UPDATE Return_Request SET status = N'REJECTED', confirmed_by_employee_id = ?, confirmed_at = SYSDATETIME(), note = ? "
                    + "WHERE return_request_id = ? AND status = N'PENDING'";
            try (PreparedStatement ps = connection.prepareStatement(updReq)) {
                ps.setInt(1, employeeId);
                ps.setString(2, decisionNote);
                ps.setInt(3, returnRequestId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * If all items returned -> Borrow.status = COMPLETED
     */
    private void updateBorrowCompletedIfNeeded(int borrowId) throws SQLException {
        String sqlCount = "SELECT COUNT(*) AS total_items, "
                + "SUM(CASE WHEN returned_at IS NOT NULL THEN 1 ELSE 0 END) AS returned_items "
                + "FROM Borrow_Item WHERE borrow_id = ?";
        int total = 0;
        int returned = 0;
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total_items");
                returned = rs.getInt("returned_items");
            }
        }
        if (total > 0 && total == returned) {
            String updBorrow = "UPDATE Borrow SET status = N'COMPLETED' WHERE borrow_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(updBorrow)) {
                ps.setInt(1, borrowId);
                ps.executeUpdate();
            }
        }
    }
}