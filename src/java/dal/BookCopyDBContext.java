package dal;

import java.sql.*;
import java.util.ArrayList;
import model.BookCopy;

public class BookCopyDBContext extends DBContext<BookCopy> {

    @Override
    public ArrayList<BookCopy> list() {
        ArrayList<BookCopy> list = new ArrayList<>();
        String sql = "SELECT copy_id, book_id, copy_code, status, created_at FROM BookCopy";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BookCopy bc = new BookCopy();
                bc.setCopyId(rs.getInt("copy_id"));
                bc.setBookId(rs.getInt("book_id"));
                bc.setCopyCode(rs.getString("copy_code"));
                bc.setStatus(rs.getString("status"));
                bc.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                list.add(bc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<BookCopy> listByBookId(int bookId) {
        ArrayList<BookCopy> list = new ArrayList<>();
        String sql = "SELECT * FROM BookCopy WHERE book_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookCopy bc = new BookCopy();
                bc.setCopyId(rs.getInt("copy_id"));
                bc.setBookId(rs.getInt("book_id"));
                bc.setCopyCode(rs.getString("copy_code"));
                bc.setStatus(rs.getString("status"));
                bc.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                list.add(bc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public BookCopy get(int id) {
        String sql = "SELECT copy_id, book_id, copy_code, status, created_at "
                + "FROM BookCopy WHERE copy_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                BookCopy bc = new BookCopy();
                bc.setCopyId(rs.getInt("copy_id"));
                bc.setBookId(rs.getInt("book_id"));
                bc.setCopyCode(rs.getString("copy_code"));
                bc.setStatus(rs.getString("status"));
                bc.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return bc;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void insert(BookCopy model) {
        String sql = "INSERT INTO BookCopy (book_id, copy_code, status, created_at) "
                + "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getBookId());
            ps.setString(2, model.getCopyCode());
            ps.setString(3, model.getStatus());
            ps.setTimestamp(4, Timestamp.valueOf(model.getCreatedAt()));
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(BookCopy model) {
        String sql = "UPDATE BookCopy "
                + "SET book_id = ?, copy_code = ?, status = ? "
                + "WHERE copy_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getBookId());
            ps.setString(2, model.getCopyCode());
            ps.setString(3, model.getStatus());
            ps.setInt(4, model.getCopyId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(BookCopy model) {
        String sql = "DELETE FROM BookCopy WHERE copy_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getCopyId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
