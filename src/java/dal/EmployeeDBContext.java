package dal;

import model.Employee;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;

public class EmployeeDBContext extends DBContext<Employee> {

    // =========================
    // LIST ALL EMPLOYEES
    // =========================
    @Override
    public ArrayList<Employee> list() {
        ArrayList<Employee> employees = new ArrayList<>();
        String sql = "SELECT * FROM Employee";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
        String sql = "SELECT * FROM Employee WHERE employee_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapEmployee(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName())
                  .log(Level.SEVERE, null, ex);
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
            (full_name, email, password_hash, status, role_id)
            VALUES (?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getEmail());
            ps.setString(3, e.getPasswordHash());
            ps.setString(4, e.getStatus());
            ps.setInt(5, e.getRoleId());

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
                role_id = ?
            WHERE employee_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, e.getFullName());
            ps.setString(2, e.getEmail());
            ps.setString(3, e.getStatus());
            ps.setInt(4, e.getRoleId());
            ps.setInt(5, e.getEmployeeId());

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
