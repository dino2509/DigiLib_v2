package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;

public class BookDBContext extends DBContext<Book> {

    private static final Logger LOGGER = Logger.getLogger(BookDBContext.class.getName());

    @Override
    public ArrayList<Book> list() {
        return listActive(null, null, 1, 20);
    }

    public ArrayList<Book> listActive(String keyword, Integer categoryId, int page, int pageSize) {
        ArrayList<Book> books = new ArrayList<>();

        if (page <= 0) page = 1;
        if (pageSize <= 0) pageSize = 12;

        StringBuilder sql = new StringBuilder();
        sql.append("\nSELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency,\n")
           .append("       a.author_name, c.category_id, c.category_name,\n")
           .append("       CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating,\n")
           .append("       COUNT(r.review_id) AS review_count\n")
           .append("FROM Book b\n")
           .append("LEFT JOIN Author a ON a.author_id = b.author_id\n")
           .append("LEFT JOIN Category c ON c.category_id = b.category_id\n")
           .append("LEFT JOIN Review r ON r.book_id = b.book_id\n")
           .append("WHERE b.status = 'active'\n");

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("  AND (b.title LIKE ? OR a.author_name LIKE ? OR c.category_name LIKE ?)\n");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (categoryId != null) {
            sql.append("  AND b.category_id = ?\n");
            params.add(categoryId);
        }

        sql.append("GROUP BY b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency, a.author_name, c.category_id, c.category_name\n")
           .append("ORDER BY b.created_at DESC\n")
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY\n");

        int offset = (page - 1) * pageSize;
        params.add(offset);
        params.add(pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapBook(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return books;
    }

    public int countActive(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT b.book_id) AS total\n")
           .append("FROM Book b\n")
           .append("LEFT JOIN Author a ON a.author_id = b.author_id\n")
           .append("LEFT JOIN Category c ON c.category_id = b.category_id\n")
           .append("WHERE b.status = 'active'\n");

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("  AND (b.title LIKE ? OR a.author_name LIKE ? OR c.category_name LIKE ?)\n");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (categoryId != null) {
            sql.append("  AND b.category_id = ?\n");
            params.add(categoryId);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public ArrayList<Book> topRated(int limit) {
        ArrayList<Book> books = new ArrayList<>();
        if (limit <= 0) limit = 8;

        String sql = "\nSELECT TOP (?) b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency,\n" +
                     "       a.author_name, c.category_id, c.category_name,\n" +
                     "       CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating,\n" +
                     "       COUNT(r.review_id) AS review_count\n" +
                     "FROM Book b\n" +
                     "LEFT JOIN Author a ON a.author_id = b.author_id\n" +
                     "LEFT JOIN Category c ON c.category_id = b.category_id\n" +
                     "LEFT JOIN Review r ON r.book_id = b.book_id\n" +
                     "WHERE b.status = 'active'\n" +
                     "GROUP BY b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency, a.author_name, c.category_id, c.category_name\n" +
                     "ORDER BY avg_rating DESC, review_count DESC, b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapBook(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return books;
    }

    @Override
    public Book get(int id) {
        String sql = "\nSELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency,\n" +
                     "       a.author_id, a.author_name, c.category_id, c.category_name,\n" +
                     "       CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating,\n" +
                     "       COUNT(r.review_id) AS review_count\n" +
                     "FROM Book b\n" +
                     "LEFT JOIN Author a ON a.author_id = b.author_id\n" +
                     "LEFT JOIN Category c ON c.category_id = b.category_id\n" +
                     "LEFT JOIN Review r ON r.book_id = b.book_id\n" +
                     "WHERE b.book_id = ?\n" +
                     "GROUP BY b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency, a.author_id, a.author_name, c.category_id, c.category_name";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<Book> getByIds(List<Integer> ids) {
        ArrayList<Book> books = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return books;

        StringBuilder in = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) in.append(",");
            in.append("?");
        }

        String sql = "\nSELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency,\n" +
                     "       a.author_name, c.category_id, c.category_name,\n" +
                     "       CAST(ISNULL(AVG(CAST(r.rating AS float)), 0) AS float) AS avg_rating,\n" +
                     "       COUNT(r.review_id) AS review_count\n" +
                     "FROM Book b\n" +
                     "LEFT JOIN Author a ON a.author_id = b.author_id\n" +
                     "LEFT JOIN Category c ON c.category_id = b.category_id\n" +
                     "LEFT JOIN Review r ON r.book_id = b.book_id\n" +
                     "WHERE b.book_id IN (" + in + ")\n" +
                     "GROUP BY b.book_id, b.title, b.summary, b.description, b.cover_url, b.total_pages, b.price, b.currency, a.author_name, c.category_id, c.category_name\n" +
                     "ORDER BY b.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapBook(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
        }

        return books;
    }

    @Override
    public void insert(Book model) {
        throw new UnsupportedOperationException("Not supported in this module.");
    }

    @Override
    public void update(Book model) {
        throw new UnsupportedOperationException("Not supported in this module.");
    }

    @Override
    public void delete(Book model) {
        throw new UnsupportedOperationException("Not supported in this module.");
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setSummary(rs.getString("summary"));
        b.setDescription(rs.getString("description"));
        b.setCoverUrl(rs.getString("cover_url"));

        int tp = rs.getInt("total_pages");
        b.setTotalPages(rs.wasNull() ? null : tp);

        b.setAuthor(rs.getString("author_name"));

        int catId = rs.getInt("category_id");
        b.setCategoryId(rs.wasNull() ? null : catId);
        b.setCategoryName(rs.getString("category_name"));

        b.setRating(rs.getDouble("avg_rating"));

        int rc = rs.getInt("review_count");
        b.setReviewCount(rs.wasNull() ? null : rc);

        double price = rs.getDouble("price");
        b.setPrice(rs.wasNull() ? null : price);
        b.setCurrency(rs.getString("currency"));

        try {
            int authorId = rs.getInt("author_id");
            b.setAuthorId(rs.wasNull() ? null : authorId);
        } catch (SQLException ignore) {
        }

        return b;
    }
}
