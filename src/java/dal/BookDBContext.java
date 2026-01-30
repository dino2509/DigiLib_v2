package dal;

import model.Book;
import model.Author;
import model.Category;
import model.Employee;

import java.sql.*;
import java.util.ArrayList;

public class BookDBContext extends DBContext<Book> {

    // ================== LIST ALL (ADMIN) ==================
    public ArrayList<Book> listAll() {
        ArrayList<Book> books = new ArrayList<>();

        String sql = """
            SELECT 
                b.book_id,
                b.title,
                b.price,
                b.status,
                b.created_at,
                a.author_id,
                a.author_name,
                c.category_id,
                c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            ORDER BY b.book_id DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStatus(rs.getString("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));

                // ===== AUTHOR =====
                int authorId = rs.getInt("author_id");
                if (!rs.wasNull()) {
                    Author a = new Author();
                    a.setAuthor_id(authorId);
                    a.setAuthor_name(rs.getString("author_name"));
                    b.setAuthor(a);
                }

                // ===== CATEGORY =====
                int categoryId = rs.getInt("category_id");
                if (!rs.wasNull()) {
                    Category c = new Category();
                    c.setCategory_id(categoryId);
                    c.setCategory_name(rs.getString("category_name"));
                    b.setCategory(c);
                }

                books.add(b);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return books;
    }

    // ================== READ ALL (BASIC) ==================
    @Override
    public ArrayList<Book> list() {
        ArrayList<Book> books = new ArrayList<>();
        String sql = "SELECT book_id FROM Book";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                books.add(get(rs.getInt("book_id")));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    // ================== READ BY ID ==================
    @Override
    public Book get(int id) {

        String sql = """
            SELECT 
                b.*,
                a.author_name,
                c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            WHERE b.book_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
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

                // AUTHOR
                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                b.setAuthor(a);

                // CATEGORY
                Category c = new Category();
                c.setCategory_id(rs.getInt("category_id"));
                c.setCategory_name(rs.getString("category_name"));
                b.setCategory(c);

                return b;
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
             author_id, category_id, created_by, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())
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
            ps.setInt(11, b.getAuthor().getAuthor_id());
            ps.setInt(12, b.getCategory().getCategory_id());
            ps.setInt(13, b.getCreate_by().getEmployeeId());

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
                status = ?,
                author_id = ?,
                category_id = ?,
                updated_by = ?,
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
            ps.setString(8, b.getStatus());
            ps.setInt(9, b.getAuthor().getAuthor_id());
            ps.setInt(10, b.getCategory().getCategory_id());
            ps.setInt(11, b.getUpdate_by().getEmployeeId());
            ps.setInt(12, b.getBookId());

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
}
