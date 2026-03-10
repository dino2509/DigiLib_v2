package controller.common;

import dal.CategoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Category;

@WebServlet(urlPatterns = "/categories")
public class CategoriesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CategoryDBContext catDAO = new CategoryDBContext();
        ArrayList<Category> categories = catDAO.listWithBookCount();

        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/view/common/categories.jsp").forward(req, resp);
    }
}
