package dal;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ReadingHistory;

public class ReadingHistoryDBContext extends DBContext {

    public List<ReadingHistory> getHistoryByReader(int readerId, int page, int pageSize) {

        List<ReadingHistory> list = new ArrayList<>();

        try {

            String sql = """
                SELECT rh.history_id,
                       rh.book_id,
                       rh.last_read_position,
                       rh.last_read_at,
                       b.title,
                       b.cover_url
                FROM Reading_History rh
                JOIN Book b ON rh.book_id = b.book_id
                WHERE rh.reader_id = ?
                ORDER BY rh.last_read_at DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

            PreparedStatement stm = connection.prepareStatement(sql);

            stm.setInt(1, readerId);
            stm.setInt(2, (page - 1) * pageSize);
            stm.setInt(3, pageSize);

            ResultSet rs = stm.executeQuery();

            while (rs.next()) {

                ReadingHistory h = new ReadingHistory();

                h.setHistoryId(rs.getInt("history_id"));
                h.setBookId(rs.getInt("book_id"));
                h.setLastReadPosition(rs.getInt("last_read_position"));
                h.setLastReadAt(rs.getTimestamp("last_read_at"));
                h.setTitle(rs.getString("title"));
                h.setCoverUrl(rs.getString("cover_url"));

                list.add(h);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countHistory(int readerId) {

        try {

            String sql = """
                SELECT COUNT(*)
                FROM Reading_History
                WHERE reader_id = ?
                """;

            PreparedStatement stm = connection.prepareStatement(sql);

            stm.setInt(1, readerId);

            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
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
