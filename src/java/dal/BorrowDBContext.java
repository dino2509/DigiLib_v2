package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Book;
import model.BorrowDetail;
import model.borrow.Borrow;
import model.borrow.BorrowDetailItem;
import model.borrow.BorrowExtendRequest;
import model.borrow.BorrowItem;
import model.borrow.BorrowedBook;
import model.borrow.BorrowedBookItem;

public class BorrowDBContext extends DBContext<BorrowedBookItem> {

    public void setConnection(Connection conn) {
        this.connection = conn;
    }

    public void extendBorrowByBorrowId(int borrowId, Date newDueDate) {

        String sql = """
        UPDATE Borrow_Item
        SET due_date = ?
        WHERE borrow_id = ?
        AND status = 'BORROWING'
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setDate(1, newDueDate);
            ps.setInt(2, borrowId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<BorrowDetail> getBorrowItems(int borrowId) {

        List<BorrowDetail> list = new ArrayList<>();

        String sql = """
        SELECT 
            bi.borrow_item_id,
            bi.copy_id,
            bc.copy_code,
            b.book_id,
            b.title,
            b.cover_url,
            bi.due_date,
            bi.returned_at,
            bi.status
        FROM Borrow_Item bi
        JOIN BookCopy bc ON bi.copy_id = bc.copy_id
        JOIN Book b ON bc.book_id = b.book_id
        WHERE bi.borrow_id = ?
    """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, borrowId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowDetail d = new BorrowDetail();

                d.setBorrowItemId(rs.getInt("borrow_item_id"));
                d.setCopyId(rs.getInt("copy_id"));
                d.setCopyCode(rs.getString("copy_code"));

                d.setBookId(rs.getInt("book_id"));
                d.setTitle(rs.getString("title"));
                d.setCoverUrl(rs.getString("cover_url"));

                d.setDueDate(rs.getDate("due_date"));
                d.setReturnedAt(rs.getDate("returned_at"));
                d.setStatus(rs.getString("status"));

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Borrow getBorrowInfo(int borrowId) {

        String sql = """
        SELECT 
            b.borrow_id,
            b.borrow_date,
            b.status,
            r.full_name AS reader_name,
            r.email
        FROM Borrow b
        JOIN Reader r ON b.reader_id = r.reader_id
        WHERE b.borrow_id = ?
    """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, borrowId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Borrow b = new Borrow();

                b.setBorrowId(rs.getInt("borrow_id"));
                b.setBorrowDate(rs.getDate("borrow_date"));
                b.setStatus(rs.getString("status"));

                b.setReaderName(rs.getString("reader_name"));
                b.setReaderEmail(rs.getString("email"));

                return b;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void returnBorrow(int borrowId) {

        try {

            connection.setAutoCommit(false);

            String sqlItems = """
        SELECT copy_id, due_date
        FROM Borrow_Item
        WHERE borrow_id = ?
          AND returned_at IS NULL
        """;

            PreparedStatement stmItems = connection.prepareStatement(sqlItems);
            stmItems.setInt(1, borrowId);

            ResultSet rs = stmItems.executeQuery();

            while (rs.next()) {

                int copyId = rs.getInt("copy_id");
                Timestamp dueDate = rs.getTimestamp("due_date");

                // 2️⃣ update Borrow_Item
                String sqlUpdateItem = """
            UPDATE Borrow_Item
            SET returned_at = GETDATE(),
                status = 'RETURNED'
            WHERE borrow_id = ?
              AND copy_id = ?
            """;

                PreparedStatement stmUpdateItem
                        = connection.prepareStatement(sqlUpdateItem);

                stmUpdateItem.setInt(1, borrowId);
                stmUpdateItem.setInt(2, copyId);
                stmUpdateItem.executeUpdate();

                // 3️⃣ update BookCopy
                String sqlCopy = """
            UPDATE BookCopy
            SET status = 'AVAILABLE'
            WHERE copy_id = ?
            """;

                PreparedStatement stmCopy
                        = connection.prepareStatement(sqlCopy);

                stmCopy.setInt(1, copyId);
                stmCopy.executeUpdate();

                // 4️⃣ kiểm tra overdue để tạo Fine
                Timestamp now = new Timestamp(System.currentTimeMillis());

                if (dueDate.before(now)) {

                    long diff = now.getTime() - dueDate.getTime();
                    long days = diff / (1000 * 60 * 60 * 24);

                    String sqlFine = """
                INSERT INTO Fine
                (reader_id, amount, created_at)
                SELECT reader_id, ?, GETDATE()
                FROM Borrow
                WHERE borrow_id = ?
                """;

                    PreparedStatement stmFine
                            = connection.prepareStatement(sqlFine);

                    stmFine.setLong(1, days * 5000); // 5000 VND / day
                    stmFine.setInt(2, borrowId);

                    stmFine.executeUpdate();
                }

            }

            // 5️⃣ cập nhật Borrow status
            String sqlBorrow = """
        UPDATE Borrow
        SET status = 'RETURNED'
        WHERE borrow_id = ?
        """;

            PreparedStatement stmBorrow
                    = connection.prepareStatement(sqlBorrow);

            stmBorrow.setInt(1, borrowId);
            stmBorrow.executeUpdate();

            connection.commit();

        } catch (Exception e) {

            try {
                connection.rollback();
            } catch (Exception ex) {
            }

            e.printStackTrace();
        }
    }

    public Borrow getBorrow(int borrowId) {

        Borrow b = null;

        try {

            String sql = """
        SELECT b.borrow_id,
               b.borrow_date,
               b.status,
               r.full_name
        FROM Borrow b
        JOIN Reader r ON b.reader_id = r.reader_id
        WHERE b.borrow_id = ?
        """;

            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, borrowId);

            ResultSet rs = stm.executeQuery();

            if (rs.next()) {

                b = new Borrow();

                b.setBorrowId(rs.getInt("borrow_id"));
                b.setBorrowDate(rs.getDate("borrow_date"));
                b.setStatus(rs.getString("status"));
                b.setReaderName(rs.getString("full_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return b;
    }

    public List<BorrowItem> getBorrowItemsNotReturned() {

        List<BorrowItem> list = new ArrayList<>();

        try {

            String sql = """
        SELECT bi.borrow_item_id,
               bi.borrow_id,
               bi.copy_id,
               bi.due_date,
               bc.copy_code,
               b.title
        FROM Borrow_Item bi
        JOIN BookCopy bc ON bi.copy_id = bc.copy_id
        JOIN Book b ON bc.book_id = b.book_id
        WHERE bi.returned_at IS NULL
        ORDER BY bi.due_date
        """;

            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {

                BorrowItem item = new BorrowItem();

                item.setBorrowItemId(rs.getInt("borrow_item_id"));
                item.setBorrowId(rs.getInt("borrow_id"));
                item.setCopyId(rs.getInt("copy_id"));
                item.setBookTitle(rs.getString("title"));
                item.setCopyCode(rs.getString("copy_code"));
                item.setDueDate(rs.getTimestamp("due_date"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void returnBook(int borrowItemId, int copyId) {

        try {

            connection.setAutoCommit(false);

            String sql1 = """
        UPDATE Borrow_Item
        SET returned_at = GETDATE(),
            status = 'RETURNED'
        WHERE borrow_item_id = ?
        """;

            PreparedStatement stm1 = connection.prepareStatement(sql1);
            stm1.setInt(1, borrowItemId);
            stm1.executeUpdate();

            String sql2 = """
        UPDATE BookCopy
        SET status = 'AVAILABLE'
        WHERE copy_id = ?
        """;

            PreparedStatement stm2 = connection.prepareStatement(sql2);
            stm2.setInt(1, copyId);
            stm2.executeUpdate();

            connection.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int countBorrows(String search, String status) {

        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM Borrow b
        JOIN Reader r ON b.reader_id = r.reader_id
        WHERE 1=1
    """);

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (r.full_name LIKE ? OR CAST(b.borrow_id AS VARCHAR) LIKE ?) ");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND b.status = ? ");
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

    public List<Borrow> getBorrowsByPage(String search, String status, int page, int pageSize) {

        List<Borrow> list = new ArrayList<>();

        int offset = (page - 1) * pageSize;

        StringBuilder sql = new StringBuilder("""
    SELECT 
        b.borrow_id,
        r.full_name,
        b.borrow_date,
        b.status,
        MIN(bi.due_date) AS due_date,
        MAX(
            CASE 
                WHEN DATEDIFF(DAY, bi.due_date, GETDATE()) > 0 
                THEN DATEDIFF(DAY, bi.due_date, GETDATE())
                ELSE 0
            END
        ) AS overdue_days,
        MIN(book.title) AS book_title,
        MIN(bc.copy_code) AS copy_code
    FROM Borrow b
    JOIN Reader r ON b.reader_id = r.reader_id
    LEFT JOIN Borrow_Item bi ON b.borrow_id = bi.borrow_id
    LEFT JOIN BookCopy bc ON bi.copy_id = bc.copy_id
    LEFT JOIN Book book ON bc.book_id = book.book_id
    WHERE 1=1
""");

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (r.full_name LIKE ? OR CAST(b.borrow_id AS VARCHAR) LIKE ?) ");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND b.status = ? ");
        }

        sql.append("""
        GROUP BY b.borrow_id, r.full_name, b.borrow_date, b.status
        ORDER BY b.borrow_id DESC
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

            ps.setInt(index++, offset);
            ps.setInt(index, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Borrow b = new Borrow();

                b.setBorrowId(rs.getInt("borrow_id"));
                b.setReaderName(rs.getString("full_name"));
                b.setBorrowDate(rs.getDate("borrow_date"));
                b.setStatus(rs.getString("status"));
                b.setDueDate(rs.getTimestamp("due_date"));
                b.setBookTitle(rs.getString("book_title"));
                b.setCopyCode(rs.getString("copy_code"));
                int overdue = rs.getInt("overdue_days");
                b.setOverdueDays(Math.max(overdue, 0));

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getOverdueDaysByBorrowId(int borrowId) {

        String sql = """
        SELECT MAX(
            CASE 
                WHEN DATEDIFF(DAY, due_date, GETDATE()) > 0 
                THEN DATEDIFF(DAY, due_date, GETDATE())
                ELSE 0
            END
        ) AS overdue_days
        FROM Borrow_Item
        WHERE borrow_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, borrowId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("overdue_days");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int getBorrowIdByFine(int fineId) {

        String sql = """
        SELECT TOP 1 b.borrow_id
        FROM Fine f
        JOIN Borrow_Item bi ON f.borrow_item_id = bi.borrow_item_id
        JOIN Borrow b ON bi.borrow_id = b.borrow_id
        WHERE f.fine_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, fineId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("borrow_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public void returnAllItemsByBorrowId(int borrowId, Timestamp now) {

        String sql = """
        UPDATE Borrow_Item
        SET returned_at = ?
        WHERE borrow_id = ? AND returned_at IS NULL
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setTimestamp(1, now);
            ps.setInt(2, borrowId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateBookCopyAvailable(int borrowId) {

        String sql = """
        UPDATE bc
        SET bc.status = 'AVAILABLE'
        FROM BookCopy bc
        JOIN Borrow_Item bi ON bc.copy_id = bi.copy_id
        WHERE bi.borrow_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateBorrowStatusReturned(int borrowId) {

        String sql = """
        UPDATE Borrow
        SET status = 'RETURNED'
        WHERE borrow_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Borrow> getAllBorrows() {

        List<Borrow> list = new ArrayList<>();

        try {

            String sql = """
                SELECT b.borrow_id,
                       r.full_name,
                       b.borrow_date,
                       b.status
                FROM Borrow b
                JOIN Reader r ON b.reader_id = r.reader_id
                ORDER BY b.borrow_id DESC
            """;

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Borrow b = new Borrow();

                b.setBorrowId(rs.getInt("borrow_id"));
                b.setReaderName(rs.getString("full_name"));
                b.setBorrowDate(rs.getDate("borrow_date"));
                b.setStatus(rs.getString("status"));

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<BorrowItem> getBorrowedBooks(int readerId, int page, int pageSize) {

        List<BorrowItem> list = new ArrayList<>();

        String sql = """
SELECT
bi.borrow_item_id,
bk.title AS book_title,
bc.copy_code,
bi.due_date,
bi.status,
DATEDIFF(day, GETDATE(), bi.due_date) AS remaining_days,
be.status AS extend_status

FROM Borrow_Item bi
JOIN Borrow b ON bi.borrow_id = b.borrow_id
JOIN BookCopy bc ON bi.copy_id = bc.copy_id
JOIN Book bk ON bc.book_id = bk.book_id

LEFT JOIN Borrow_Extend be
ON be.extend_id = (
    SELECT TOP 1 extend_id
    FROM Borrow_Extend
    WHERE borrow_item_id = bi.borrow_item_id
    ORDER BY requested_at DESC
)

WHERE b.reader_id = ?
AND bi.returned_at IS NULL

ORDER BY bi.due_date

OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
""";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, readerId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowItem item = new BorrowItem();

                item.setBorrowItemId(rs.getInt("borrow_item_id"));
                item.setBookTitle(rs.getString("book_title"));
                item.setCopyCode(rs.getString("copy_code"));
                item.setDueDate(rs.getTimestamp("due_date"));
                item.setStatus(rs.getString("status"));
                item.setRemainingDays(rs.getInt("remaining_days"));
                item.setExtendStatus(rs.getString("extend_status"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countBorrowedBooks(int readerId) {

        String sql = """
SELECT COUNT(*)
FROM Borrow_Item bi
JOIN Borrow b ON bi.borrow_id = b.borrow_id
WHERE b.reader_id = ?
AND bi.returned_at IS NULL
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

        return 0;
    }

    public List<BorrowedBook> getBorrowedBooks() {

        List<BorrowedBook> list = new ArrayList<>();

        try {

            String sql = """
        SELECT 
            bi.borrow_item_id,
            bi.borrow_id,
            bi.due_date,
            b.title,
            bc.copy_code,
            br.borrow_date,
            r.full_name
        FROM Borrow_Item bi
        JOIN Borrow br ON bi.borrow_id = br.borrow_id
        JOIN BookCopy bc ON bi.copy_id = bc.copy_id
        JOIN Book b ON bc.book_id = b.book_id
        JOIN Reader r ON br.reader_id = r.reader_id
        WHERE bi.returned_at IS NULL
        ORDER BY bi.due_date
        """;

            PreparedStatement stm = connection.prepareStatement(sql);

            ResultSet rs = stm.executeQuery();

            while (rs.next()) {

                BorrowedBook bb = new BorrowedBook();

                bb.setBorrowItemId(rs.getInt("borrow_item_id"));
                bb.setBorrowId(rs.getInt("borrow_id"));
                bb.setBookTitle(rs.getString("title"));
                bb.setCopyCode(rs.getString("copy_code"));
                bb.setBorrowDate(rs.getTimestamp("borrow_date"));
                bb.setDueDate(rs.getTimestamp("due_date"));
                bb.setReaderName(rs.getString("full_name"));

                list.add(bb);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<BorrowItem> getBorrowedBooks(int readerId) {

        List<BorrowItem> list = new ArrayList<>();

        String sql = """
SELECT
bi.borrow_item_id,
bk.title AS book_title,
bc.copy_code,
bi.due_date,
bi.status,
DATEDIFF(day, GETDATE(), bi.due_date) AS remaining_days,
be.status AS extend_status
FROM Borrow_Item bi
JOIN Borrow b ON bi.borrow_id = b.borrow_id
JOIN BookCopy bc ON bi.copy_id = bc.copy_id
JOIN Book bk ON bc.book_id = bk.book_id
LEFT JOIN Borrow_Extend be 
ON bi.borrow_item_id = be.borrow_item_id
AND be.status IN ('PENDING','APPROVED')
WHERE b.reader_id = ?
AND bi.returned_at IS NULL
ORDER BY bi.due_date
""";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, readerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BorrowItem item = new BorrowItem();

                item.setBorrowItemId(rs.getInt("borrow_item_id"));
                item.setBookTitle(rs.getString("book_title"));
                item.setCopyCode(rs.getString("copy_code"));
                item.setDueDate(rs.getTimestamp("due_date"));
                item.setStatus(rs.getString("status"));
                item.setRemainingDays(rs.getInt("remaining_days"));
                item.setExtendStatus(rs.getString("extend_status"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public ArrayList<BorrowedBookItem> list() {
        throw new UnsupportedOperationException("Use listActiveByReader(readerId)");
    }

    @Override
    public BorrowedBookItem get(int id) {
        throw new UnsupportedOperationException("Not supported");

    }

    @Override
    public void insert(BorrowedBookItem model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void update(BorrowedBookItem model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void delete(BorrowedBookItem model) {
        throw new UnsupportedOperationException("Not supported");
    }

    public ArrayList<BorrowedBookItem> listActiveByReader(int readerId) {
        return listHistoryByReader(readerId, "borrowing");
    }

    public ArrayList<BorrowedBookItem> listHistoryByReader(int readerId, String filter) {
        ArrayList<BorrowedBookItem> items = new ArrayList<>();

        if (filter == null) {
            filter = "all";
        }
        filter = filter.trim().toLowerCase();

        String where = switch (filter) {
            case "returned" ->
                " AND bi.returned_at IS NOT NULL ";
            case "borrowing" ->
                " AND bi.returned_at IS NULL AND bi.due_date >= GETDATE() ";
            case "overdue" ->
                " AND bi.returned_at IS NULL AND bi.due_date < GETDATE() ";
            default ->
                "";
        };

        String sql = "SELECT br.borrow_id, br.status AS borrow_status, br.borrow_date, "
                + "bi.borrow_item_id, bi.due_date, bi.returned_at, bi.status AS borrow_item_status, "
                + "bc.copy_id, bc.copy_code, b.book_id, b.title, b.cover_url, b.currency, b.price "
                + "FROM Borrow br "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "INNER JOIN Book b ON b.book_id = bc.book_id "
                + "WHERE br.reader_id = ? " + where
                + "ORDER BY br.borrow_date DESC, bi.borrow_item_id DESC";

        BorrowExtendDBContext extendDao = new BorrowExtendDBContext();
        Map<Integer, BorrowExtendRequest> pendingMap = extendDao.mapPendingByReader(readerId);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowedBookItem it = new BorrowedBookItem();
                it.setBorrowId(rs.getInt("borrow_id"));
                it.setBorrowStatus(rs.getString("borrow_status"));
                it.setBorrowDate(rs.getTimestamp("borrow_date"));
                it.setBorrowItemId(rs.getInt("borrow_item_id"));
                it.setDueDate(rs.getTimestamp("due_date"));
                it.setReturnedAt(rs.getTimestamp("returned_at"));
                it.setBorrowItemStatus(rs.getString("borrow_item_status"));
                it.setCopyId(rs.getInt("copy_id"));
                it.setCopyCode(rs.getString("copy_code"));

                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setCoverUrl(rs.getString("cover_url"));
                b.setCurrency(rs.getString("currency"));
                b.setPrice(rs.getBigDecimal("price"));
                it.setBook(b);

                BorrowExtendRequest pending = pendingMap.get(it.getBorrowItemId());
                if (pending != null) {
                    it.setPendingExtendRequestId(pending.getExtendId());
                    it.setPendingExtendMaxDays(pending.getMaxAllowedDays());
                    it.setPendingExtendRequestedDays(pending.getRequestedDays());
                }
                BorrowExtendDBContext.FineInfo fineInfo = extendDao.getUnpaidFineInfo(it.getBorrowItemId());
                it.setHasUnpaidFine(fineInfo.hasUnpaidFine);
                it.setUnpaidFineAmount(fineInfo.amount);
                it.setUnpaidFineSummary(fineInfo.summary);
                items.add(it);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    public boolean isBookCurrentlyBorrowed(int readerId, int bookId) {
        String sql = "SELECT TOP 1 1 "
                + "FROM Borrow br "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "WHERE br.reader_id = ? "
                + "AND bc.book_id = ? "
                + "AND bi.returned_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countActiveBorrowedItems(int readerId) {
        String sql = "SELECT COUNT(*) FROM Borrow br INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id WHERE br.reader_id = ? AND bi.returned_at IS NULL";
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

    public int countDueSoon(int readerId, int days) {
        String sql = "SELECT COUNT(*) FROM Borrow br INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id WHERE br.reader_id = ? AND bi.returned_at IS NULL AND bi.due_date <= DATEADD(day, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, days);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countOverdueBorrowedItems(int readerId) {
        String sql = "SELECT COUNT(*) FROM Borrow br INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id WHERE br.reader_id = ? AND bi.returned_at IS NULL AND bi.due_date < GETDATE()";
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

    public int countAllBorrowedItems(int readerId) {
        String sql = "SELECT COUNT(*) FROM Borrow br INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id WHERE br.reader_id = ?";
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

    public int countReturnedBorrowedItems(int readerId) {
        String sql = "SELECT COUNT(*) FROM Borrow br INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id WHERE br.reader_id = ? AND bi.returned_at IS NOT NULL";
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
}
