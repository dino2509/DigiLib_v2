package controller.admin;

import dal.CategoryDBContext;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "CategoryManagementController", urlPatterns = {"/admin/categories"})
public class CategoryManagementController extends HttpServlet {

    private CategoryDBContext categoryDB = new CategoryDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listCategories(request, response);
        } else {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/admin/categories/add")
                           .forward(request, response);
                    break;

                case "edit":
                    showEditForm(request, response);
                    break;

                case "delete":
                    deleteCategory(request, response);
                    break;

                default:
                    listCategories(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            insertCategory(request, response);
        } else if ("edit".equals(action)) {
            updateCategory(request, response);
        } else {
            response.sendRedirect("categories");
        }
    }

    // =========================
    // LIST
    // =========================
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Category> categories = categoryDB.list();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/categories/list")
               .forward(request, response);
    }

    // =========================
    // SHOW EDIT FORM
    // =========================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDB.get(categoryId);

        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/categories/edit")
               .forward(request, response);
    }

    // =========================
    // INSERT
    // =========================
    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Category category = extractCategoryFromRequest(request);
        categoryDB.insert(category);

        response.sendRedirect("categories");
    }

    // =========================
    // UPDATE
    // =========================
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Category category = extractCategoryFromRequest(request);
        category.setCategory_id(
                Integer.parseInt(request.getParameter("category_id"))
        );

        categoryDB.update(category);
        response.sendRedirect("categories");
    }

    // =========================
    // DELETE
    // =========================
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDB.get(categoryId);

        categoryDB.delete(category);
        response.sendRedirect("categories");
    }

    // =========================
    // MAP REQUEST → CATEGORY
    // =========================
    private Category extractCategoryFromRequest(HttpServletRequest request) {

        Category c = new Category();
        c.setCategory_name(request.getParameter("category_name"));
        c.setDescription(request.getParameter("description"));

        return c;
    }
}
