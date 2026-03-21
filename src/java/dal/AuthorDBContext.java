package dal;

import model.Author;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuthorDBContext extends DBContext<Author> {

    public ArrayList<Author> search(String search, int page, int pageSize) {
        ArrayList<Author> list = new ArrayList<>();

        String sql = """
        SELECT * FROM Author
        WHERE author_name LIKE ?
        ORDER BY author_id DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + search + "%");
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                a.setBio(rs.getString("bio"));
                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int count(String search) {
        String sql = "SELECT COUNT(*) FROM Author WHERE author_name LIKE ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + search + "%");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // LIST ALL AUTHORS
    // =========================
    @Override
    public ArrayList<Author> list() {
        ArrayList<Author> authors = new ArrayList<>();
        String sql = "SELECT author_id, author_name, bio FROM Author";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                a.setBio(rs.getString("bio"));
                authors.add(a);
            }
        } catch (SQLException ex) {
            Logger.getLogger(AuthorDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return authors;
    }

    // =========================
    // GET AUTHOR BY ID
    // =========================
    @Override
    public Author get(int id) {
        String sql = "SELECT author_id, author_name, bio FROM Author WHERE author_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Author a = new Author();
                a.setAuthor_id(rs.getInt("author_id"));
                a.setAuthor_name(rs.getString("author_name"));
                a.setBio(rs.getString("bio"));
                return a;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AuthorDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // =========================
    // INSERT AUTHOR
    // =========================
    @Override
    public void insert(Author model) {
        String sql = "INSERT INTO Author(author_name, bio) VALUES (?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getAuthor_name());
            ps.setString(2, model.getBio());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AuthorDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // UPDATE AUTHOR
    // =========================
    @Override
    public void update(Author model) {
        String sql = "UPDATE Author SET author_name = ?, bio = ? WHERE author_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getAuthor_name());
            ps.setString(2, model.getBio());
            ps.setInt(3, model.getAuthor_id());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AuthorDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // DELETE AUTHOR
    // =========================
    @Override
    public void delete(Author model) {
        String sql = "DELETE FROM Author WHERE author_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getAuthor_id());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AuthorDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
