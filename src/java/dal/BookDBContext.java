package dal;

import model.Book;
import java.sql.*;
import java.util.ArrayList;

public class BookDBContext extends DBContext<Book> {

    // ================== READ ALL ==================
    @Override
    public ArrayList<Book> list() {
        ArrayList<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM Book";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                books.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    // ================== READ BY ID ==================
    @Override
    public Book get(int id) {
        String sql = "SELECT * FROM Book WHERE book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ================== CREATE ==================
    @Override
    public void insert(Book b) {
        String sql = """
            INSERT INTO Book
            (title, summary, description, cover_url, content_path,
             price, currency, total_pages, preview_pages, status,
             author_id, category_id, created_at)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,GETDATE())
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getSummary());
            ps.setString(3, b.getDescription());
            ps.setString(4, b.getCoverUrl());
            ps.setString(5, b.getContentPath());
            ps.setBigDecimal(6, b.getPrice());
            ps.setString(7, b.getCurrency());
            ps.setObject(8, b.getTotalPages());
            ps.setObject(9, b.getPreviewPages());
            ps.setString(10, b.getStatus());
            ps.setObject(11, b.getAuthorId());
            ps.setObject(12, b.getCategoryId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ================== UPDATE ==================
    @Override
    public void update(Book b) {
        String sql = """
            UPDATE Book SET
                title = ?,
                summary = ?,
                description = ?,
                cover_url = ?,
                content_path = ?,
                price = ?,
                currency = ?,
                total_pages = ?,
                preview_pages = ?,
                status = ?,
                author_id = ?,
                category_id = ?,
                updated_at = GETDATE()
            WHERE book_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getSummary());
            ps.setString(3, b.getDescription());
            ps.setString(4, b.getCoverUrl());
            ps.setString(5, b.getContentPath());
            ps.setBigDecimal(6, b.getPrice());
            ps.setString(7, b.getCurrency());
            ps.setObject(8, b.getTotalPages());
            ps.setObject(9, b.getPreviewPages());
            ps.setString(10, b.getStatus());
            ps.setObject(11, b.getAuthorId());
            ps.setObject(12, b.getCategoryId());
            ps.setInt(13, b.getBookId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ================== DELETE ==================
    @Override
    public void delete(Book b) {
        String sql = "DELETE FROM Book WHERE book_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, b.getBookId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ================== MAP RESULTSET ==================
    private Book map(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setBookId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setSummary(rs.getString("summary"));
        b.setDescription(rs.getString("description"));
        b.setCoverUrl(rs.getString("cover_url"));
        b.setContentPath(rs.getString("content_path"));
        b.setPrice(rs.getBigDecimal("price"));
        b.setCurrency(rs.getString("currency"));
        b.setTotalPages(rs.getInt("total_pages"));
        b.setPreviewPages(rs.getInt("preview_pages"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));
        b.setAuthorId(rs.getInt("author_id"));
        b.setCategoryId(rs.getInt("category_id"));
        return b;
    }
}
