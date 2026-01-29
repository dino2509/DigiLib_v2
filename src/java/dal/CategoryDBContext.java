package dal;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CategoryDBContext extends DBContext<Category> {

    // =========================
    // LIST ALL CATEGORIES
    // =========================
    @Override
    public ArrayList<Category> list() {
        ArrayList<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description FROM Category";

        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategory_id(rs.getInt("category_id"));
                c.setCategory_name(rs.getString("category_name"));
                c.setDescription(rs.getString("description"));
                categories.add(c);
            }

        } catch (SQLException ex) {
            Logger.getLogger(CategoryDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return categories;
    }

    // =========================
    // GET CATEGORY BY ID
    // =========================
    @Override
    public Category get(int id) {
        String sql = "SELECT category_id, category_name, description FROM Category WHERE category_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                Category c = new Category();
                c.setCategory_id(rs.getInt("category_id"));
                c.setCategory_name(rs.getString("category_name"));
                c.setDescription(rs.getString("description"));
                return c;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // =========================
    // INSERT CATEGORY
    // =========================
    @Override
    public void insert(Category model) {
        String sql = "INSERT INTO Category (category_name, description) VALUES (?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getCategory_name());
            stm.setString(2, model.getDescription());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // UPDATE CATEGORY
    // =========================
    @Override
    public void update(Category model) {
        String sql = "UPDATE Category SET category_name = ?, description = ? WHERE category_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getCategory_name());
            stm.setString(2, model.getDescription());
            stm.setInt(3, model.getCategory_id());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // DELETE CATEGORY
    // =========================
    @Override
    public void delete(Category model) {
        String sql = "DELETE FROM Category WHERE category_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getCategory_id());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
