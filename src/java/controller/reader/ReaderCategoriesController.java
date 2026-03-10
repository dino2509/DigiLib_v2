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

@WebServlet("/reader/categories")
public class ReaderCategoriesController extends HttpServlet {

    private final CategoryDBContext categoryDB = new CategoryDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object sessionUser = (session == null) ? null : session.getAttribute("user");
        if (!(sessionUser instanceof Reader)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ArrayList<Category> categories = categoryDB.list();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/view/reader/categories.jsp").forward(request, response);
    }
}
