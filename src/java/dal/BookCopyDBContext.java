package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.BookCopy;

public class BookCopyDBContext extends DBContext<BookCopy> {

    public ArrayList<BookCopy> listPaging(Integer bookId, String status, int page, int pageSize) {

        ArrayList<BookCopy> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT bc.copy_id,
               bc.book_id,
               b.title AS book_title,
               bc.copy_code,
               bc.status,
               bc.created_at
        FROM BookCopy bc
        JOIN Book b ON bc.book_id = b.book_id
        WHERE 1=1
    """);

        if (bookId != null) {
            sql.append(" AND bc.book_id = ?");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND bc.status = ?");
        }

        sql.append("""
        ORDER BY bc.copy_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """);

        try {

            PreparedStatement ps = connection.prepareStatement(sql.toString());

            int index = 1;

            if (bookId != null) {
                ps.setInt(index++, bookId);
            }

            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BookCopy c = new BookCopy();

                c.setCopyId(rs.getInt("copy_id"));
                c.setBookId(rs.getInt("book_id"));
                c.setBookTitle(rs.getString("book_title"));
                c.setCopyCode(rs.getString("copy_code"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int count(Integer bookId, String status) {

        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM BookCopy bc
        JOIN Book b ON bc.book_id = b.book_id
        WHERE 1=1
    """);

        if (bookId != null) {
            sql.append(" AND bc.book_id = ?");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND bc.status = ?");
        }

        try {

            PreparedStatement ps = connection.prepareStatement(sql.toString());

            int index = 1;

            if (bookId != null) {
                ps.setInt(index++, bookId);
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

    public int getNextCopyNumber(int bookId) {

        String sql = """
        SELECT COUNT(*) + 1
        FROM BookCopy
        WHERE book_id = ?
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, bookId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 1;
    }

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

    public int getAvailableCopies(int bookId) {

        String sql = """
        SELECT COUNT(*)
        FROM BookCopy
        WHERE book_id = ?
        AND status = 'available'
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, bookId);

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
