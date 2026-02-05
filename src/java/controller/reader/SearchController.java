package controller.reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * /reader/search: alias cho /reader/books (giữ URL đúng như feature tree).
 */
@WebServlet(urlPatterns = "/reader/search")
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getQueryString();
        String target = req.getContextPath() + "/reader/books" + (query != null ? "?" + query : "");
        resp.sendRedirect(target);
    }
}
