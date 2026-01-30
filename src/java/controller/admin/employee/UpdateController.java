package controller.admin.employee;

import dal.EmployeeDBContext;
import dal.RoleDBContext;
import model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import model.Role;

@WebServlet(name = "EmployeeUpdateController",
            urlPatterns = {"/admin/employees/edit"})
public class UpdateController extends HttpServlet {

    private EmployeeDBContext employeeDB = new EmployeeDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int employeeId = Integer.parseInt(request.getParameter("id"));
        
        Employee employee = employeeDB.get(employeeId);
        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }
        RoleDBContext roleDB = new RoleDBContext();
        ArrayList<Role> roles = roleDB.list();
        request.setAttribute("roles", roles);
        request.setAttribute("employee", employee);
        request.getRequestDispatcher("../../view/admin/employees/edit.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int employeeId = Integer.parseInt(request.getParameter("employee_id"));
        int roleId     = Integer.parseInt(request.getParameter("role_id"));
        String status  = request.getParameter("status");
        String fullName = request.getParameter("full_name");

        // 1️⃣ Lấy employee cũ từ DB (KHÔNG tin form)
        Employee old = employeeDB.get(employeeId);
        if (old == null) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        // 2️⃣ Update các field cho phép
        old.setFullName(fullName);
        old.setRoleId(roleId);
        old.setStatus(status);

        // 3️⃣ Update DB
        employeeDB.update(old);

        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }
}
