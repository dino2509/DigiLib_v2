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
                b.*,
                a.author_id,
                a.author_name,
                c.category_id,
                c.category_name
              
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            ORDER BY b.book_id ASC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStatus(rs.getString("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setCoverUrl(rs.getString("cover_url"));
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
            c.category_name,
            e1.employee_id AS create_by_id,
            e1.full_name  AS create_by_name,
            e2.employee_id AS update_by_id,
            e2.full_name  AS update_by_name
        FROM Book b
        LEFT JOIN Author a ON b.author_id = a.author_id
        LEFT JOIN Category c ON b.category_id = c.category_id
        LEFT JOIN Employee e1 ON e1.employee_id = b.created_by
        LEFT JOIN Employee e2 ON e2.employee_id = b.updated_by
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

                // ===== CREATED BY (BẮT BUỘC) =====
                Employee createBy = new Employee();
                createBy.setEmployeeId(rs.getInt("create_by_id"));
                createBy.setFullName(rs.getString("create_by_name"));
                b.setCreate_by(createBy);

                // ===== UPDATED BY (CÓ THỂ NULL) =====
                int updateById = rs.getInt("update_by_id");
                if (!rs.wasNull()) {
                    Employee updateBy = new Employee();
                    updateBy.setEmployeeId(updateById);
                    updateBy.setFullName(rs.getString("update_by_name"));
                    b.setUpdate_by(updateBy);
                }

                // ===== AUTHOR =====
                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                b.setAuthor(a);

                // ===== CATEGORY =====
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
            ps.setInt(8, b.getTotalPages());
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
            ps.setBigDecimal(6, b.getPrice());
            ps.setString(7, b.getCurrency());
            ps.setString(8, b.getStatus());
            ps.setInt(9, b.getAuthor().getAuthor_id());
            ps.setInt(10, b.getCategory().getCategory_id());

            // ===== UPDATED BY (BẮT BUỘC PHẢI CÓ) =====
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

    //====search====
    public ArrayList<Book> search(String keyword,
            Integer authorId,
            Integer categoryId,
            String status) {

        ArrayList<Book> books = new ArrayList<>();

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

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
        WHERE 1 = 1
    """;

        if (hasKeyword) {
            sql += " AND b.title LIKE ? ESCAPE '\\' ";
        }
        if (authorId != null) {
            sql += " AND b.author_id = ? ";
        }
        if (categoryId != null) {
            sql += " AND b.category_id = ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND b.status = ? ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int index = 1;

            if (hasKeyword) {
                // Escape ký tự đặc biệt cho LIKE
                String safeKeyword = keyword.trim()
                        .replace("\\", "\\\\")
                        .replace("%", "\\%")
                        .replace("_", "\\_");

                ps.setString(index++, "%" + safeKeyword + "%");
            }

            if (authorId != null) {
                ps.setInt(index++, authorId);
            }
            if (categoryId != null) {
                ps.setInt(index++, categoryId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status.trim());
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStatus(rs.getString("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));

                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                b.setAuthor(a);

                Category c = new Category();
                c.setCategory_id(rs.getInt("category_id"));
                c.setCategory_name(rs.getString("category_name"));
                b.setCategory(c);

                books.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    public ArrayList<Book> searchByKeyword(String keyword
    ) {

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
            c.category_name,
            b.cover_url
                 
        FROM Book b
        LEFT JOIN Author a ON b.author_id = a.author_id
        LEFT JOIN Category c ON b.category_id = c.category_id
        WHERE 1 = 1
    """;

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND b.title LIKE  ? ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int index = 1;

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setStatus(rs.getString("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setCoverUrl(rs.getString("cover_url"));
                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                b.setAuthor(a);

                Category c = new Category();
                c.setCategory_id(rs.getInt("category_id"));
                c.setCategory_name(rs.getString("category_name"));
                b.setCategory(c);

                books.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    public int countSearch(String keyword,
            Integer authorId,
            Integer categoryId,
            String status) {

        String sql = """
        SELECT COUNT(*)
        FROM Book b
        WHERE 1 = 1
    """;

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND b.title LIKE ? ";
        }
        if (authorId != null) {
            sql += " AND b.author_id = ? ";
        }
        if (categoryId != null) {
            sql += " AND b.category_id = ? ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND b.status = ? ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }
            if (authorId != null) {
                ps.setInt(i++, authorId);
            }
            if (categoryId != null) {
                ps.setInt(i++, categoryId);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(i++, status);
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

    public int countBooks(String keyword) {

        String sql = """
        SELECT COUNT(*)
        FROM Book
        WHERE (? IS NULL OR title LIKE ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(1, java.sql.Types.NVARCHAR);
                ps.setNull(2, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(1, keyword);
                ps.setString(2, "%" + keyword + "%");
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

    public ArrayList<Book> pagingBooks(String keyword, int pageIndex, int pageSize) {

        ArrayList<Book> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM Book
        WHERE (? IS NULL OR title LIKE ?)
        ORDER BY book_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int i = 1;

            if (keyword == null || keyword.trim().isEmpty()) {
                ps.setNull(i++, java.sql.Types.NVARCHAR);
                ps.setNull(i++, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(i++, keyword);
                ps.setString(i++, "%" + keyword + "%");
            }

            ps.setInt(i++, (pageIndex - 1) * pageSize);
            ps.setInt(i, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setCoverUrl(rs.getString("cover_url"));
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public ArrayList<Book> searchPaging(String keyword,
            Integer authorId,
            Integer categoryId,
            String status,
            int pageIndex,
            int pageSize) {

        ArrayList<Book> books = new ArrayList<>();

        String sql = """
    SELECT 
        b.book_id,
        b.title,
        b.price,
        b.currency,
        b.status,
        b.created_at,
        b.cover_url,
        a.author_id,
        a.author_name,
        c.category_id,
        c.category_name
    FROM Book b
    LEFT JOIN Author a ON b.author_id = a.author_id
    LEFT JOIN Category c ON b.category_id = c.category_id
    WHERE 1 = 1
""";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND b.title LIKE ? ";
        }
        if (authorId != null) {
            sql += " AND b.author_id = ? ";
        }
        if (categoryId != null) {
            sql += " AND b.category_id = ? ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND b.status = ? ";
        }

        sql += """
    ORDER BY b.book_id ASC
    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }
            if (authorId != null) {
                ps.setInt(i++, authorId);
            }
            if (categoryId != null) {
                ps.setInt(i++, categoryId);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(i++, status);
            }

            ps.setInt(i++, (pageIndex - 1) * pageSize);
            ps.setInt(i, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setCurrency(rs.getString("currency"));
                b.setStatus(rs.getString("status"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setCoverUrl(rs.getString("cover_url")); // ✅ FIX ẢNH

                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                b.setAuthor(a);

                Category c = new Category();
                c.setCategory_id(rs.getInt("category_id"));
                c.setCategory_name(rs.getString("category_name"));
                b.setCategory(c);

                books.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
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

    /**
     * Gợi ý sách khác (ưu tiên cùng thể loại), loại trừ chính nó.
     */
    public ArrayList<Book> listRecommended(int bookId, int categoryId, int limit) {
        ArrayList<Book> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.book_id, b.title, b.cover_url, b.currency, b.price "
                + "FROM Book b "
                + "WHERE b.book_id <> ? "
                + "AND b.category_id = ? "
                + "ORDER BY NEWID()";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Math.max(1, limit));
            ps.setInt(2, bookId);
            ps.setInt(3, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = new Book();
                b.setBookId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setCoverUrl(rs.getString("cover_url"));
                b.setCurrency(rs.getString("currency"));
                b.setPrice(rs.getBigDecimal("price"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
