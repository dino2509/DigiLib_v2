package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Book;
import model.ReadingHistoryEntry;

/**
 * Reader Home: Continue Reading.
 */
public class ReadingHistoryDBContext extends DBContext<ReadingHistoryEntry> {

    @Override
    public ArrayList<ReadingHistoryEntry> list() {
        throw new UnsupportedOperationException("Use listRecentByReader(readerId, limit)");
    }

    @Override
    public ReadingHistoryEntry get(int id) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void insert(ReadingHistoryEntry model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void update(ReadingHistoryEntry model) {
        throw new UnsupportedOperationException("Not supported");
    }

    @Override
    public void delete(ReadingHistoryEntry model) {
        throw new UnsupportedOperationException("Not supported");
    }

    public ArrayList<ReadingHistoryEntry> listRecentByReader(int readerId, int limit) {
        ArrayList<ReadingHistoryEntry> list = new ArrayList<>();

        String sql =
                "SELECT TOP (?) "
                + " h.history_id, h.reader_id, h.book_id, h.last_read_position, h.last_read_at, "
                + " b.title, b.cover_url, b.total_pages "
                + "FROM Reading_History h "
                + "INNER JOIN Book b ON b.book_id = h.book_id "
                + "WHERE h.reader_id = ? "
                + "ORDER BY h.last_read_at DESC, h.history_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, readerId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReadingHistoryEntry e = new ReadingHistoryEntry();
                e.setHistoryId(rs.getInt("history_id"));
                e.setReaderId(rs.getInt("reader_id"));
                e.setLastReadPosition((Integer) rs.getObject("last_read_position"));
                e.setLastReadAt(rs.getTimestamp("last_read_at"));

                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setCoverUrl(rs.getString("cover_url"));
                b.setTotalPages(rs.getInt("total_pages"));
                e.setBook(b);

                list.add(e);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public int countDistinctBooksRead(int readerId) {
        String sql = "SELECT COUNT(DISTINCT book_id) FROM Reading_History WHERE reader_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return 0;
    }
}
