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

@WebServlet(name = "EmployeeAddController", urlPatterns = {"/admin/employees/add"})
public class AddController extends HttpServlet {

    ReaderDBContext readerDB = new ReaderDBContext();
    EmployeeDBContext employeeDB = new EmployeeDBContext();
    RoleDBContext roleDB = new RoleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load danh sách reader
        ArrayList<Reader> readers = readerDB.list();
        
        request.setAttribute("readers", readers);
        ArrayList<Role> roles = roleDB.list();
        request.setAttribute("roles", roles);
        request.getRequestDispatcher("../../view/admin/employees/add.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int readerId = Integer.parseInt(request.getParameter("reader_id"));
        int roleId = Integer.parseInt(request.getParameter("role_id"));

        // 1️⃣ Lấy reader
        Reader r = readerDB.get(readerId);
        if (r == null) {
            response.sendRedirect("add?error=reader_not_found");
            return;
        }

        // 2️⃣ Check đã là employee chưa
        if (employeeDB.existsByEmail(r.getEmail())) {
            response.sendRedirect("add?error=already_employee");
            return;
        }

        // 3️⃣ Copy Reader → Employee
        Employee e = new Employee();
        e.setFullName(r.getFullName());
        e.setEmail(r.getEmail());
        e.setPasswordHash(r.getPasswordHash()); // dùng lại
        e.setStatus("active");
        e.setRoleId(roleId);
        e.setCreatedAt(LocalDateTime.now());

        // 4️⃣ Insert
        employeeDB.insert(e);

        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }
}
