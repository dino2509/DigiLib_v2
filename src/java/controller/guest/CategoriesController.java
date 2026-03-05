package controller.guest;

import dal.CategoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Category;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/categories")
public class CategoriesController extends HttpServlet {

    private CategoryDBContext categoryDB = new CategoryDBContext();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Category> categories = categoryDB.listAll();

        request.setAttribute("categories", categories);

        request.setAttribute("pageTitle", "Categories");
        request.setAttribute("contentPage", "/view/guest/categories.jsp");

        request.getRequestDispatcher("/include/guest/layout.jsp")
                .forward(request, response);
    }
}
