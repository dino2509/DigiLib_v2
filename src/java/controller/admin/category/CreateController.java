package controller.admin.category;

import dal.CategoryDBContext;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CategoryCreateController", urlPatterns = {"/admin/categories/add"})
public class CreateController extends HttpServlet {

    private CategoryDBContext categoryDB = new CategoryDBContext();

    // =========================
    // SHOW CREATE FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("../../view/admin/categories/add.jsp")
                .forward(request, response);
    }

    // =========================
    // HANDLE CREATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category_name = request.getParameter("category_name");
        String description = request.getParameter("description");

        Category c = new Category();
        c.setCategory_name(category_name);
        c.setDescription(description);

        categoryDB.insert(c);

        response.sendRedirect(
                request.getContextPath() + "/admin/categories/list"
        );
    }
}
