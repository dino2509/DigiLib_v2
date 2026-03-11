package controller.reader.book;

import controller.guest.*;
import dal.CategoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Category;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/reader/categories")
public class CategoriesController extends HttpServlet {

    private CategoryDBContext categoryDB = new CategoryDBContext();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Category> categories = categoryDB.listAll();

        request.setAttribute("categories", categories);
        request.setAttribute("activeMenu","categories");
        request.setAttribute("pageTitle", "Categories");
        request.setAttribute("contentPage", "/view/reader/book/categories.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
