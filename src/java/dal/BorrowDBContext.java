package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Author;
import model.Book;
import model.BorrowedItem;

public class BorrowDBContext extends DBContext<BorrowedItem> {

    private static final Logger LOGGER = Logger.getLogger(BorrowDBContext.class.getName());

    @Override
    public ArrayList<BorrowedItem> list() {
        throw new UnsupportedOperationException("Use listByReader(readerId).");
    }

    public int countActiveBorrowed(int readerId) {
        String sql = "\nSELECT COUNT(*) AS total\n" +
                     "FROM Borrow_Item bi\n" +
                     "JOIN Borrow b ON b.borrow_id = bi.borrow_id\n" +
                     "WHERE b.reader_id = ? AND bi.returned_at IS NULL";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int countDueSoon(int readerId, int withinDays) {
        if (withinDays <= 0) withinDays = 3;
        String sql = "\nSELECT COUNT(*) AS total\n" +
                     "FROM Borrow_Item bi\n" +
                     "JOIN Borrow b ON b.borrow_id = bi.borrow_id\n" +
                     "WHERE b.reader_id = ?\n" +
                     "  AND bi.returned_at IS NULL\n" +
                     "  AND bi.due_date <= DATEADD(day, ?, SYSUTCDATETIME())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, withinDays);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public ArrayList<BorrowedItem> listByReader(int readerId) {
        ArrayList<BorrowedItem> items = new ArrayList<>();

        String sql = "\nSELECT\n" +
                     "  bi.borrow_item_id, bi.due_date, bi.returned_at, bi.status AS borrow_item_status,\n" +
                     "  bc.copy_code,\n" +
                     "  bk.book_id, bk.title, bk.cover_url, bk.total_pages,\n" +
                     "  a.author_name,\n" +
                     "  CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating\n" +
                     "FROM Borrow_Item bi\n" +
                     "JOIN Borrow b ON b.borrow_id = bi.borrow_id\n" +
                     "JOIN BookCopy bc ON bc.copy_id = bi.copy_id\n" +
                     "JOIN Book bk ON bk.book_id = bc.book_id\n" +
                     "LEFT JOIN Author a ON a.author_id = bk.author_id\n" +
                     "LEFT JOIN Review r ON r.book_id = bk.book_id\n" +
                     "WHERE b.reader_id = ?\n" +
                     "GROUP BY bi.borrow_item_id, bi.due_date, bi.returned_at, bi.status, bc.copy_code,\n" +
                     "         bk.book_id, bk.title, bk.cover_url, bk.total_pages, a.author_name\n" +
                     "ORDER BY bi.returned_at DESC, bi.due_date ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book bk = new Book();
                    bk.setBookId(rs.getInt("book_id"));
                    bk.setTitle(rs.getString("title"));

                    Author a = new Author();
                    a.setAuthor_name(rs.getString("author_name"));
                    bk.setAuthor(a);

                    bk.setCoverUrl(rs.getString("cover_url"));
                    Object tpObj = rs.getObject("total_pages");
                    bk.setTotalPages(tpObj == null ? null : rs.getInt("total_pages"));
                    bk.setRating(rs.getDouble("avg_rating"));

                    BorrowedItem item = new BorrowedItem();
                    item.setBorrowItemId(rs.getInt("borrow_item_id"));
                    item.setBook(bk);
                    item.setCopyCode(rs.getString("copy_code"));
                    item.setStatus(rs.getString("borrow_item_status"));

                    java.sql.Timestamp due = rs.getTimestamp("due_date");
                    if (due != null) item.setDueDate(due.toLocalDateTime());
                    java.sql.Timestamp returned = rs.getTimestamp("returned_at");
                    if (returned != null) item.setReturnedAt(returned.toLocalDateTime());

                    if (item.getReturnedAt() == null && item.getDueDate() != null) {
                        LocalDateTime now = LocalDateTime.now();
                        if (item.getDueDate().isBefore(now)) {
                            item.setStatus("overdue");
                        }
                    }
                    items.add(item);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }

        return items;
    }

    @Override
    public BorrowedItem get(int id) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void insert(BorrowedItem model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void update(BorrowedItem model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void delete(BorrowedItem model) {
        throw new UnsupportedOperationException("Not supported.");
    }
}
