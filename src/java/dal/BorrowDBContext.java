package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Book;
import model.BorrowedBookItem;

/**
 * Reader Borrow: đọc dữ liệu từ Borrow + Borrow_Item + BookCopy + Book.
 */
public class BorrowDBContext extends DBContext<BorrowedBookItem> {

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

    /**
     * Danh sách sách đang mượn (Borrow_Item chưa trả).
     */
    public ArrayList<BorrowedBookItem> listActiveByReader(int readerId) {
        ArrayList<BorrowedBookItem> items = new ArrayList<>();

        String sql =
                "SELECT "
                + " br.borrow_id, br.status AS borrow_status, br.borrow_date, "
                + " bi.borrow_item_id, bi.due_date, bi.returned_at, bi.status AS borrow_item_status, "
                + " bc.copy_id, bc.copy_code, "
                + " b.book_id, b.title, b.cover_url, b.currency, b.price "
                + "FROM Borrow br "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id "
                + "INNER JOIN BookCopy bc ON bc.copy_id = bi.copy_id "
                + "INNER JOIN Book b ON b.book_id = bc.book_id "
                + "WHERE br.reader_id = ? AND bi.returned_at IS NULL "
                + "ORDER BY bi.due_date ASC";

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

                items.add(it);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    public int countActiveBorrowedItems(int readerId) {
        String sql =
                "SELECT COUNT(*) "
                + "FROM Borrow br "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id "
                + "WHERE br.reader_id = ? AND bi.returned_at IS NULL";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countDueSoon(int readerId, int days) {
        String sql =
                "SELECT COUNT(*) "
                + "FROM Borrow br "
                + "INNER JOIN Borrow_Item bi ON bi.borrow_id = br.borrow_id "
                + "WHERE br.reader_id = ? "
                + "AND bi.returned_at IS NULL "
                + "AND bi.due_date <= DATEADD(day, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, days);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
