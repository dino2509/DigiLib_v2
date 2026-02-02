package controller.admin.role;

import dal.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Role;

@WebServlet("/admin/roles")
public class ListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoleDBContext rdb = new RoleDBContext();
        ArrayList<Role> roles = rdb.list();

        request.setAttribute("roles", roles);
        request.setAttribute("pageTitle", "Role Management");
        request.setAttribute("activeMenu", "role");
        request.setAttribute("contentPage", "../../view/admin/roles/list.jsp");
        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../view/admin/role/list.jsp").forward(request, response);
    }
}
