package controller.reader;

import dal.CategoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Category;
import model.Reader;

@WebServlet(urlPatterns = "/reader/categories")
public class CategoriesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        CategoryDBContext catDAO = new CategoryDBContext();
        ArrayList<Category> categories = catDAO.listWithBookCount();

        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/view/reader/categories.jsp").forward(req, resp);
    }
}
