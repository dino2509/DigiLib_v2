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

@WebServlet("/reader/books/*")
public class ReaderBooksController extends HttpServlet {

    private final BookDBContext bookDB = new BookDBContext();
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

        String pathInfo = request.getPathInfo(); // null, "/", "/5"
        if (pathInfo != null && pathInfo.length() > 1) {
            handleDetail(request, response, pathInfo);
        } else {
            handleList(request, response);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q = request.getParameter("q");
        Integer categoryId = null;
        String categoryStr = request.getParameter("categoryId");
        if (categoryStr != null && !categoryStr.isBlank()) {
            try {
                categoryId = Integer.parseInt(categoryStr);
            } catch (NumberFormatException ignore) {
            }
        }

        int page = 1;
        int pageSize = 12;
        try {
            String p = request.getParameter("page");
            if (p != null) page = Integer.parseInt(p);
        } catch (NumberFormatException ignore) {
        }

        ArrayList<Book> books = bookDB.listActive(q, categoryId, page, pageSize);
        int total = bookDB.countActive(q, categoryId);
        int totalPages = (int) Math.ceil(total / (double) pageSize);

        ArrayList<Category> categories = categoryDB.list();

        request.setAttribute("books", books);
        request.setAttribute("q", q);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("categories", categories);

        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("total", total);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/view/reader/books.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        String[] parts = pathInfo.split("/");
        if (parts.length < 2) {
            response.sendRedirect(request.getContextPath() + "/reader/books");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(parts[1]);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/reader/books");
            return;
        }

        Book book = bookDB.get(bookId);
        if (book == null) {
            response.sendError(404);
            return;
        }

        request.setAttribute("book", book);
        request.getRequestDispatcher("/view/reader/book-detail.jsp").forward(request, response);
    }
}
