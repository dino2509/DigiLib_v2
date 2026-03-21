package dal;

import java.sql.*;
import model.Employee;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.Reader;

public class EmployeeDBContext extends DBContext<Employee> {

    public ArrayList<Employee> searchPaging(String keyword, int pageIndex, int pageSize) {

        ArrayList<Employee> list = new ArrayList<>();

        // ===== NORMALIZE KEYWORD =====
        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        StringBuilder sql = new StringBuilder("""
        SELECT employee_id, full_name, email, phone, status, created_at, role_id
        FROM Employee
        WHERE 1=1
    """);

        if (keyword != null) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?) ");
        }

        sql.append("""
        ORDER BY employee_id DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            int i = 1;

            if (keyword != null) {
                ps.setString(i++, "%" + keyword + "%");
                ps.setString(i++, "%" + keyword + "%");
            }

            ps.setInt(i++, (pageIndex - 1) * pageSize);
            ps.setInt(i, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Employee e = new Employee();

                e.setEmployeeId(rs.getInt("employee_id"));
                e.setFullName(rs.getString("full_name"));
                e.setEmail(rs.getString("email"));
                e.setPhone(rs.getString("phone"));
                e.setStatus(rs.getString("status"));

                if (rs.getTimestamp("created_at") != null) {
                    e.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }

                e.setRoleId(rs.getInt("role_id"));

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countSearch(String keyword) {

        // ===== NORMALIZE KEYWORD =====
        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM Employee
        WHERE 1=1
    """);

        if (keyword != null) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?) ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            int i = 1;

            if (keyword != null) {
                ps.setString(i++, "%" + keyword + "%");
                ps.setString(i++, "%" + keyword + "%");
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

    // =========================
    // LIST ALL EMPLOYEES
    // =========================
    @Override
    public ArrayList<Employee> list() {
        ArrayList<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM Employee";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                employees.add(mapEmployee(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return employees;
    }

    // =========================
    // GET EMPLOYEE BY ID
    // =========================
    @Override
    public Employee get(int id) {

        String sql = """
        SELECT e.*, r.role_name
        FROM Employee e
        LEFT JOIN Role r ON e.role_id = r.role_id
        WHERE e.employee_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Employee e = new Employee();

                e.setEmployeeId(rs.getInt("employee_id"));
                e.setFullName(rs.getString("full_name"));
                e.setEmail(rs.getString("email"));
                e.setPasswordHash(rs.getString("password_hash"));
                e.setPhone(rs.getString("phone"));          // ✅ NEW
                e.setAvatar(rs.getString("avatar"));        // ✅ NEW
                e.setStatus(rs.getString("status"));
                e.setRoleId(rs.getInt("role_id"));

                // nếu bạn có field roleName
//                e.setRoleName(rs.getString("role_name"));

                // convert time
                if (rs.getTimestamp("created_at") != null) {
                    e.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }

                return e;
            }

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, "Get Employee failed", ex);
        }

        return null;
    }

    // =========================
    // INSERT EMPLOYEE
    // =========================
    @Override
    public void insert(Employee e) {

        String sql = """
        INSERT INTO Employee
        (full_name, email, password_hash, phone, avatar, status, role_id, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getEmail());
            ps.setString(3, e.getPasswordHash());
            ps.setString(4, e.getPhone());
            ps.setString(5, e.getAvatar());
            ps.setString(6, e.getStatus());
            ps.setInt(7, e.getRoleId());

            // convert LocalDateTime -> Timestamp
            ps.setTimestamp(8, Timestamp.valueOf(e.getCreatedAt()));

            ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // UPDATE EMPLOYEE
    // =========================
    @Override
    public void update(Employee e) {
        String sql = """
            UPDATE Employee
            SET full_name = ?,
                email = ?,
                status = ?,
                role_id = ?,
                     phone = ?
            WHERE employee_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getEmail());
            ps.setString(3, e.getStatus());
            ps.setInt(4, e.getRoleId());
            ps.setString(5, e.getPhone());
            ps.setInt(6, e.getEmployeeId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // DELETE EMPLOYEE (HARD DELETE)
    // =========================
    @Override
    public void delete(Employee e) {
        String sql = "DELETE FROM Employee WHERE employee_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, e.getEmployeeId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM Employee WHERE email = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public void insertFromReader(Reader r, int librarianRoleId) {
        String sql = """
            INSERT INTO Employee
            (full_name, email, password_hash, status, created_at, role_id)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try {
            PreparedStatement stm = connection.prepareStatement(sql);

            stm.setString(1, r.getFullName());
            stm.setString(2, r.getEmail());
            stm.setString(3, r.getPasswordHash());
            stm.setString(4, "ACTIVE");
            stm.setObject(5, LocalDateTime.now());
            stm.setInt(6, librarianRoleId); // LIBRARIAN

            stm.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    public void updateEmployeePassword(int employeeId, String passwordHash) {
        String sql = """
        UPDATE Employee
        SET password_hash = ?
        WHERE employee_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, passwordHash);
            ps.setInt(2, employeeId);

            ps.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    // =========================
    // MAP RESULTSET → EMPLOYEE
    // =========================
    private Employee mapEmployee(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setEmployeeId(rs.getInt("employee_id"));
        e.setFullName(rs.getString("full_name"));
        e.setEmail(rs.getString("email"));
        e.setPasswordHash(rs.getString("password_hash"));
        e.setStatus(rs.getString("status"));
        e.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        e.setRoleId(rs.getInt("role_id"));
        return e;
    }
}
