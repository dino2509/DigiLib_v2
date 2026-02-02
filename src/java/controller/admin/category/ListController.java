package controller.admin.category;

import dal.CategoryDBContext;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "CategoryListController", urlPatterns = {"/admin/categories/list"})
public class ListController extends HttpServlet {

    private CategoryDBContext categoryDB = new CategoryDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Category> categories = categoryDB.list();

        request.setAttribute("categories", categories);
        request.setAttribute("pageTitle", "Category Management");
        request.setAttribute("activeMenu", "category");
        request.setAttribute("contentPage", "../../view/admin/categories/list.jsp");
        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/categories/list.jsp")
//               .forward(request, response);
    }
}
