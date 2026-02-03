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

@WebServlet(name = "EmployeeListController", urlPatterns = {"/admin/employees/list"})
public class ListController extends HttpServlet {

    private EmployeeDBContext employeeDB = new EmployeeDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Employee> employees = employeeDB.list();
        RoleDBContext roleDB = new RoleDBContext();
        ArrayList<Role> roles = roleDB.list();
        request.setAttribute("roles", roles);
        request.setAttribute("employees", employees);
        request.setAttribute("pageTitle", "Employee Management");
        request.setAttribute("activeMenu", "employee");
        request.setAttribute("contentPage", "../../view/admin/employees/list.jsp");
        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/employees/list.jsp")
//               .forward(request, response);
    }
}
