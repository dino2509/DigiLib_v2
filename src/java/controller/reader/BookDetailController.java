package controller.reader;

import dal.BookDBContext;
import dal.FavoriteDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Book;
import model.Reader;

@WebServlet(urlPatterns = "/reader/books/detail")
public class BookDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");

        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/reader/books");
            return;
        }

        BookDBContext bookDAO = new BookDBContext();
        FavoriteDBContext favDAO = new FavoriteDBContext();

        Book book = bookDAO.get(id);
        if (book == null) {
            resp.sendRedirect(req.getContextPath() + "/reader/books");
            return;
        }

        boolean isFavorite = favDAO.isFavorite(reader.getReaderId(), id);

        req.setAttribute("book", book);
        req.setAttribute("isFavorite", isFavorite);

        req.getRequestDispatcher("/view/reader/book-detail.jsp").forward(req, resp);
    }
}
