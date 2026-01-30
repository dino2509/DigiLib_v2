package controller.admin.category;

import dal.CategoryDBContext;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CategoryUpdateController",
        urlPatterns = {"/admin/categories/edit"})
public class UpdateController extends HttpServlet {

    private CategoryDBContext categoryDB = new CategoryDBContext();

    // =========================
    // SHOW EDIT FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int category_id = Integer.parseInt(request.getParameter("id"));

        Category category = categoryDB.get(category_id);
        request.setAttribute("category", category);

        request.getRequestDispatcher("../../view/admin/categories/edit.jsp")
                .forward(request, response);
    }

    // =========================
    // HANDLE UPDATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int category_id = Integer.parseInt(request.getParameter("category_id"));
        String category_name = request.getParameter("category_name");
        String description = request.getParameter("description");

        Category c = new Category();
        c.setCategory_id(category_id);
        c.setCategory_name(category_name);
        c.setDescription(description);

        categoryDB.update(c);

        response.sendRedirect(
                request.getContextPath() + "/admin/categories/list"
        );
    }
}
