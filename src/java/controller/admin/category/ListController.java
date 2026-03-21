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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }

        int page = 1;
        int pageSize = 8;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
        }

        int total = categoryDB.count(search);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        ArrayList<Category> categories = categoryDB.search(search, page, pageSize);

        request.setAttribute("categories", categories);
        request.setAttribute("search", search);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "Category Management");
        request.setAttribute("activeMenu", "category");
        request.setAttribute("contentPage", "../../view/admin/categories/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}
