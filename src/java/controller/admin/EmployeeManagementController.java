package controller.admin;

import dal.EmployeeDBContext;
import model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;

@WebServlet(name = "EmployeeManagementController", urlPatterns = {"/admin/employees"})
public class EmployeeManagementController extends HttpServlet {

    private EmployeeDBContext employeeDB = new EmployeeDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listEmployees(request, response);
        } else {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/admin/employees/add")
                           .forward(request, response);
                    break;

                case "edit":
                    showEditForm(request, response);
                    break;

                case "delete":
                    deleteEmployee(request, response);
                    break;

                default:
                    listEmployees(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            insertEmployee(request, response);
        } else if ("edit".equals(action)) {
            updateEmployee(request, response);
        } else {
            response.sendRedirect("employees");
        }
    }

    // =========================
    // LIST
    // =========================
    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Employee> employees = employeeDB.list();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/admin/employees/list")
               .forward(request, response);
    }

    // =========================
    // SHOW EDIT FORM
    // =========================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int employeeId = Integer.parseInt(request.getParameter("id"));
        Employee employee = employeeDB.get(employeeId);

        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/admin/employees/edit")
               .forward(request, response);
    }

    // =========================
    // INSERT
    // =========================
    private void insertEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Employee employee = extractEmployeeFromRequest(request);
        employee.setCreatedAt(new Timestamp(System.currentTimeMillis()).toLocalDateTime());

        employeeDB.insert(employee);
        response.sendRedirect("employees");
    }

    // =========================
    // UPDATE
    // =========================
    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Employee employee = extractEmployeeFromRequest(request);
        employee.setEmployeeId(Integer.parseInt(request.getParameter("employee_id")));

        employeeDB.update(employee);
        response.sendRedirect("employees");
    }

    // =========================
    // DELETE
    // =========================
    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int employeeId = Integer.parseInt(request.getParameter("id"));
        Employee e = employeeDB.get(employeeId);

        employeeDB.delete(e);
        response.sendRedirect("employees");
    }

    // =========================
    // MAP REQUEST → EMPLOYEE
    // =========================
    private Employee extractEmployeeFromRequest(HttpServletRequest request) {

        Employee e = new Employee();

        e.setFullName(request.getParameter("full_name"));
        e.setEmail(request.getParameter("email"));
        e.setPasswordHash(request.getParameter("password_hash"));
        e.setStatus(request.getParameter("status"));
        e.setRoleId(parseInt(request.getParameter("role_id")));

        return e;
    }

    private Integer parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
