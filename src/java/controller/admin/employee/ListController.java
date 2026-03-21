package controller.admin.employee;

import dal.EmployeeDBContext;
import dal.RoleDBContext;
import model.Employee;
import model.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "EmployeeListController", urlPatterns = {"/admin/employee/list"})
public class ListController extends HttpServlet {

    private final EmployeeDBContext employeeDB = new EmployeeDBContext();
    private final RoleDBContext roleDB = new RoleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // =========================
        // 1. SEARCH
        // =========================
        String keyword = request.getParameter("keyword");

        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        // =========================
        // 2. PAGINATION
        // =========================
        int pageSize = 10;
        int pageIndex = 1;

        try {
            pageIndex = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }

        int totalRecords = employeeDB.countSearch(keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // FIX BUG PAGE = 0
        if (totalPages == 0) {
            totalPages = 1;
        }

        if (pageIndex < 1) {
            pageIndex = 1;
        }

        if (pageIndex > totalPages) {
            pageIndex = totalPages;
        }

        // =========================
        // 3. DATA
        // =========================
        ArrayList<Employee> employees
                = employeeDB.searchPaging(keyword, pageIndex, pageSize);

        ArrayList<Role> roles = roleDB.list();

        // =========================
        // 4. SET ATTRIBUTE
        // =========================
        request.setAttribute("employees", employees);
        request.setAttribute("roles", roles);

        request.setAttribute("keyword", keyword);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);

        // =========================
        // 5. LAYOUT
        // =========================
        request.setAttribute("pageTitle", "Employee Management");
        request.setAttribute("activeMenu", "employee");

        // 🔥 PATH CHUẨN
        request.setAttribute("contentPage", "/view/admin/employees/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}
