package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Author;
import model.Book;
import model.ReadingProgress;

public class ReadingHistoryDBContext extends DBContext<ReadingProgress> {

    private static final Logger LOGGER = Logger.getLogger(ReadingHistoryDBContext.class.getName());

    @Override
    public ArrayList<ReadingProgress> list() {
        throw new UnsupportedOperationException("Use listByReader(readerId, limit).");
    }

    public ArrayList<ReadingProgress> listByReader(int readerId, int limit) {
        ArrayList<ReadingProgress> list = new ArrayList<>();
        if (limit <= 0) {
            limit = 4;
        }

        // NOTE (SQL Server): TOP does not accept a bind parameter reliably.
        // We clamp limit to a safe range and inline it.
        int safeLimit = Math.min(Math.max(limit, 1), 50);

        String sql = "\nSELECT TOP " + safeLimit + "\n" +
                "    h.book_id, h.last_read_position, h.last_read_at,\n" +
                "    b.title, b.cover_url, b.total_pages,\n" +
                "    a.author_name,\n" +
                "    CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating\n" +
                "FROM Reading_History h\n" +
                "JOIN Book b ON b.book_id = h.book_id\n" +
                "LEFT JOIN Author a ON a.author_id = b.author_id\n" +
                "LEFT JOIN Review r ON r.book_id = b.book_id\n" +
                "WHERE h.reader_id = ?\n" +
                "GROUP BY h.book_id, h.last_read_position, h.last_read_at, b.title, b.cover_url, b.total_pages, a.author_name\n" +
                "ORDER BY h.last_read_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book b = new Book();
                    b.setBookId(rs.getInt("book_id"));
                    b.setTitle(rs.getString("title"));

                    Author a = new Author();
                    a.setAuthor_name(rs.getString("author_name"));
                    b.setAuthor(a);

                    b.setCoverUrl(rs.getString("cover_url"));
                    Object tpObj = rs.getObject("total_pages");
                    b.setTotalPages(tpObj == null ? null : rs.getInt("total_pages"));
                    b.setRating(rs.getDouble("avg_rating"));

                    int pos = rs.getInt("last_read_position");
                    int progress = 0;
                    Integer totalPages = b.getTotalPages();
                    if (totalPages != null && totalPages > 0) {
                        progress = (int) Math.min(100, Math.round(pos * 100.0 / totalPages));
                    }
                    list.add(new ReadingProgress(b, progress));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public int countDistinctBooksRead(int readerId) {
        String sql = "SELECT COUNT(DISTINCT book_id) AS total FROM Reading_History WHERE reader_id = ?";
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

    @Override
    public ReadingProgress get(int id) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void insert(ReadingProgress model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void update(ReadingProgress model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void delete(ReadingProgress model) {
        throw new UnsupportedOperationException("Not supported.");
    }
}
