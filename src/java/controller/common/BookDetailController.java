package controller.common;

import dal.BookDBContext;
import dal.FavoriteDBContext;
import dal.BookQADBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Book;
import model.BookQuestion;
import model.Reader;

@WebServlet(urlPatterns = "/books/detail")
public class BookDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        BookDBContext bookDAO = new BookDBContext();
        Book book = bookDAO.get(id);
        if (book == null) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        boolean isReader = false;
        boolean isFavorite = false;

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") instanceof Reader) {
            isReader = true;
            Reader reader = (Reader) session.getAttribute("user");
            FavoriteDBContext favDAO = new FavoriteDBContext();
            isFavorite = favDAO.isFavorite(reader.getReaderId(), id);
        }

        req.setAttribute("book", book);
        req.setAttribute("isReader", isReader);
        req.setAttribute("isFavorite", isFavorite);

        // Gợi ý sách khác
        if (book.getCategory() != null) {
            req.setAttribute("recommendedBooks", bookDAO.listRecommended(id, book.getCategory().getCategory_id(), 8));
        }

        // Q&A theo sách
        BookQADBContext qaDAO = new BookQADBContext();
        ArrayList<BookQuestion> qas = qaDAO.listByBook(id);
        req.setAttribute("qas", qas);

        req.getRequestDispatcher("/view/common/book-detail.jsp").forward(req, resp);
    }
}
