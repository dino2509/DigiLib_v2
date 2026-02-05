package controller.reader;

import dal.BookDBContext;
import dal.CategoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Book;
import model.Category;
import model.Reader;

@WebServlet(urlPatterns = "/reader/books")
public class BooksController extends HttpServlet {

    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String q = req.getParameter("q");
        Integer categoryId = parseIntOrNull(req.getParameter("categoryId"));
        Integer authorId = parseIntOrNull(req.getParameter("authorId"));
        String status = req.getParameter("status");

        int page = parseIntOrDefault(req.getParameter("page"), 1);
        if (page < 1) page = 1;

        BookDBContext bookDAO = new BookDBContext();
        CategoryDBContext catDAO = new CategoryDBContext();

        int total = bookDAO.countSearch(q, authorId, categoryId, status);
        int totalPages = (int) Math.ceil(total / (double) PAGE_SIZE);

        ArrayList<Book> books = bookDAO.searchPaging(q, authorId, categoryId, status, page, PAGE_SIZE);
        ArrayList<Category> categories = catDAO.list();

        req.setAttribute("q", q);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("authorId", authorId);
        req.setAttribute("status", status);

        req.setAttribute("books", books);
        req.setAttribute("categories", categories);

        req.setAttribute("page", page);
        req.setAttribute("pageSize", PAGE_SIZE);
        req.setAttribute("total", total);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/view/reader/books.jsp").forward(req, resp);
    }

    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
