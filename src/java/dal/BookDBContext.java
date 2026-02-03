package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Author;
import model.Book;
import model.Category;

public class BookDBContext extends DBContext<Book> {

    /**
     * Helper: safely set Integer -> PreparedStatement.
     */
    private static void setNullableInt(PreparedStatement ps, int idx, Integer val) throws SQLException {
        if (val == null) {
            ps.setNull(idx, Types.INTEGER);
        } else {
            ps.setInt(idx, val);
        }
    }

    /**
     * Helper: safely set Double -> PreparedStatement.
     */
    private static void setNullableDouble(PreparedStatement ps, int idx, Double val) throws SQLException {
        if (val == null) {
            ps.setNull(idx, Types.DOUBLE);
        } else {
            ps.setDouble(idx, val);
        }
    }

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
                Object priceObj = rs.getObject("price");
                b.setPrice(priceObj == null ? null : rs.getDouble("price"));
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
                Object priceObj = rs.getObject("price");
                b.setPrice(priceObj == null ? null : rs.getDouble("price"));
                b.setCurrency(rs.getString("currency"));
                Object tpObj = rs.getObject("total_pages");
                b.setTotalPages(tpObj == null ? null : rs.getInt("total_pages"));
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
            setNullableDouble(ps, 6, b.getPrice());
            ps.setString(7, b.getCurrency());
            setNullableInt(ps, 8, b.getTotalPages());
            ps.setInt(9, b.getPreviewPages());
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
            setNullableDouble(ps, 6, b.getPrice());
            ps.setString(7, b.getCurrency());
            ps.setString(8, b.getStatus());
            ps.setInt(9, b.getAuthor().getAuthor_id());
            ps.setInt(10, b.getCategory().getCategory_id());

            if (b.getUpdate_by() == null) {
                throw new IllegalStateException("Book.update_by is null");
            }
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

    // ================== READER FEATURES ==================

    /**
     * Reader: get top-rated active books (for home recommendations).
     */
    public ArrayList<Book> topRated(int limit) {
        ArrayList<Book> books = new ArrayList<>();
        if (limit <= 0) {
            limit = 8;
        }
        int safeLimit = Math.min(Math.max(limit, 1), 50);

        String sql = "\nSELECT TOP " + safeLimit + "\n"
                + "  b.book_id, b.title, b.cover_url, b.total_pages, b.status,\n"
                + "  a.author_id, a.author_name,\n"
                + "  CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating\n"
                + "FROM Book b\n"
                + "LEFT JOIN Author a ON a.author_id = b.author_id\n"
                + "LEFT JOIN Review r ON r.book_id = b.book_id\n"
                + "WHERE b.status = 'active'\n"
                + "GROUP BY b.book_id, b.title, b.cover_url, b.total_pages, b.status, a.author_id, a.author_name\n"
                + "ORDER BY avg_rating DESC, b.book_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setCoverUrl(rs.getString("cover_url"));
                b.setCover(rs.getString("cover_url"));

                Object tpObj = rs.getObject("total_pages");
                b.setTotalPages(tpObj == null ? null : rs.getInt("total_pages"));
                b.setStatus(rs.getString("status"));
                b.setRating(rs.getDouble("avg_rating"));

                int authorId = rs.getInt("author_id");
                if (!rs.wasNull()) {
                    Author a = new Author();
                    a.setAuthor_id(authorId);
                    a.setAuthor_name(rs.getString("author_name"));
                    b.setAuthor(a);
                }
                books.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return books;
    }

    /**
     * Reader: list active books with optional keyword + category filter and pagination.
     */
    public ArrayList<Book> listActive(String keyword, Integer categoryId, int page, int pageSize) {
        ArrayList<Book> books = new ArrayList<>();
        if (page <= 0) {
            page = 1;
        }
        if (pageSize <= 0) {
            pageSize = 12;
        }
        int offset = (page - 1) * pageSize;

        String sql = "\nSELECT\n"
                + "  b.book_id, b.title, b.cover_url, b.total_pages, b.status,\n"
                + "  a.author_id, a.author_name,\n"
                + "  c.category_id, c.category_name,\n"
                + "  CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating\n"
                + "FROM Book b\n"
                + "LEFT JOIN Author a ON a.author_id = b.author_id\n"
                + "LEFT JOIN Category c ON c.category_id = b.category_id\n"
                + "LEFT JOIN Review r ON r.book_id = b.book_id\n"
                + "WHERE b.status = 'active'\n"
                + "  AND (? IS NULL OR b.title LIKE ?)\n"
                + "  AND (? IS NULL OR b.category_id = ?)\n"
                + "GROUP BY b.book_id, b.title, b.cover_url, b.total_pages, b.status,\n"
                + "         a.author_id, a.author_name, c.category_id, c.category_name\n"
                + "ORDER BY b.book_id DESC\n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        String kw = (keyword == null || keyword.isBlank()) ? null : keyword.trim();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (kw == null) {
                ps.setNull(1, Types.VARCHAR);
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(1, kw);
                ps.setString(2, "%" + kw + "%");
            }

            setNullableInt(ps, 3, categoryId);
            setNullableInt(ps, 4, categoryId);

            ps.setInt(5, offset);
            ps.setInt(6, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book b = new Book();
                    b.setBookId(rs.getInt("book_id"));
                    b.setTitle(rs.getString("title"));
                    b.setCoverUrl(rs.getString("cover_url"));
                    b.setCover(rs.getString("cover_url"));

                    Object tpObj = rs.getObject("total_pages");
                    b.setTotalPages(tpObj == null ? null : rs.getInt("total_pages"));
                    b.setStatus(rs.getString("status"));
                    b.setRating(rs.getDouble("avg_rating"));

                    int authorId = rs.getInt("author_id");
                    if (!rs.wasNull()) {
                        Author a = new Author();
                        a.setAuthor_id(authorId);
                        a.setAuthor_name(rs.getString("author_name"));
                        b.setAuthor(a);
                    }

                    int cid = rs.getInt("category_id");
                    if (!rs.wasNull()) {
                        Category c = new Category();
                        c.setCategory_id(cid);
                        c.setCategory_name(rs.getString("category_name"));
                        b.setCategory(c);
                    }

                    books.add(b);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return books;
    }

    /**
     * Reader: count active books matching filters.
     */
    public int countActive(String keyword, Integer categoryId) {
        String sql = "\nSELECT COUNT(*) AS total\n"
                + "FROM Book b\n"
                + "WHERE b.status = 'active'\n"
                + "  AND (? IS NULL OR b.title LIKE ?)\n"
                + "  AND (? IS NULL OR b.category_id = ?)";

        String kw = (keyword == null || keyword.isBlank()) ? null : keyword.trim();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (kw == null) {
                ps.setNull(1, Types.VARCHAR);
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(1, kw);
                ps.setString(2, "%" + kw + "%");
            }
            setNullableInt(ps, 3, categoryId);
            setNullableInt(ps, 4, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Reader: fetch books by ids (used by favorites).
     */
    public ArrayList<Book> getByIds(List<Integer> ids) {
        ArrayList<Book> books = new ArrayList<>();
        if (ids == null || ids.isEmpty()) {
            return books;
        }

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT b.book_id, b.title, b.cover_url, b.total_pages, b.status, a.author_id, a.author_name\n");
        sb.append("FROM Book b\n");
        sb.append("LEFT JOIN Author a ON a.author_id = b.author_id\n");
        sb.append("WHERE b.book_id IN (");
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
        sb.append(")\n");
        sb.append("ORDER BY b.book_id DESC");

        try (PreparedStatement ps = connection.prepareStatement(sb.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book b = new Book();
                    b.setBookId(rs.getInt("book_id"));
                    b.setTitle(rs.getString("title"));
                    b.setCoverUrl(rs.getString("cover_url"));
                    b.setCover(rs.getString("cover_url"));
                    Object tpObj = rs.getObject("total_pages");
                    b.setTotalPages(tpObj == null ? null : rs.getInt("total_pages"));
                    b.setStatus(rs.getString("status"));

                    int authorId = rs.getInt("author_id");
                    if (!rs.wasNull()) {
                        Author a = new Author();
                        a.setAuthor_id(authorId);
                        a.setAuthor_name(rs.getString("author_name"));
                        b.setAuthor(a);
                    }
                    books.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return books;
    }
}
