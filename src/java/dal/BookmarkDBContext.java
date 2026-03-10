package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookmarkDBContext extends DBContext<Integer> {

    private static final Logger LOGGER = Logger.getLogger(BookmarkDBContext.class.getName());

    @Override
    public ArrayList<Integer> list() {
        throw new UnsupportedOperationException("Use listBookIdsByReader(readerId).");
    }

    public ArrayList<Integer> listBookIdsByReader(int readerId) {
        ArrayList<Integer> ids = new ArrayList<>();
        String sql = "SELECT DISTINCT book_id FROM Bookmark WHERE reader_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("book_id"));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return ids;
    }

    public int countFavorites(int readerId) {
        String sql = "SELECT COUNT(DISTINCT book_id) AS total FROM Bookmark WHERE reader_id = ?";
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
    public Integer get(int id) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void insert(Integer model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void update(Integer model) {
        throw new UnsupportedOperationException("Not supported.");
    }

    @Override
    public void delete(Integer model) {
        throw new UnsupportedOperationException("Not supported.");
    }
}
