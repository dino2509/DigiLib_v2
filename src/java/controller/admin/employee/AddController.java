package controller.admin.employee;

import dal.EmployeeDBContext;
import dal.ReaderDBContext;
import dal.RoleDBContext;
import model.Employee;
import model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import model.Role;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "EmployeeAddController", urlPatterns = {"/admin/employees/add"})
public class AddController extends HttpServlet {

    EmployeeDBContext employeeDB = new EmployeeDBContext();
    RoleDBContext roleDB = new RoleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("roles", roleDB.list());

        request.setAttribute("pageTitle", "Add Employee");
        request.setAttribute("activeMenu", "employee");
        request.setAttribute("contentPage", "../../view/admin/employees/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String status = request.getParameter("status");
        int roleId = Integer.parseInt(request.getParameter("role_id"));

        // validate
        if (fullName == null || fullName.trim().length() < 3) {
            request.setAttribute("error", "Full name must be at least 3 characters");
            doGet(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            doGet(request, response);
            return;
        }

        // check email duplicate
        if (employeeDB.existsByEmail(email)) {
            request.setAttribute("error", "Email already exists");
            doGet(request, response);
            return;
        }

        // hash password
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

        Employee e = new Employee();
        e.setFullName(fullName);
        e.setEmail(email);
        e.setPasswordHash(passwordHash);
        e.setStatus(status);
        e.setRoleId(roleId);
        e.setCreatedAt(LocalDateTime.now());

        employeeDB.insert(e);

        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }
}
