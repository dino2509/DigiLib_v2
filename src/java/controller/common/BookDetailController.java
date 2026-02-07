package controller.common;

import dal.BookDBContext;
import dal.BookQADBContext;
import dal.BorrowDBContext;
import dal.BorrowRequestDBContext;
import dal.FavoriteDBContext;
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
import model.Employee;
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
        boolean isLibrarian = false;
        boolean isFavorite = false;
        boolean hasPendingBorrow = false;
        boolean isBorrowingThisBook = false;

        HttpSession session = req.getSession(false);
        Object user = (session == null) ? null : session.getAttribute("user");

        if (user instanceof Reader) {
            isReader = true;
            Reader reader = (Reader) user;

            FavoriteDBContext favDAO = new FavoriteDBContext();
            isFavorite = favDAO.isFavorite(reader.getReaderId(), id);

            BorrowRequestDBContext brDAO = new BorrowRequestDBContext();
            hasPendingBorrow = brDAO.hasPendingForBook(reader.getReaderId(), id);

            BorrowDBContext borrowDAO = new BorrowDBContext();
            isBorrowingThisBook = borrowDAO.isBookCurrentlyBorrowed(reader.getReaderId(), id);
        }

        if (user instanceof Employee) {
            Employee emp = (Employee) user;
            // roleId==2 là Librarian theo dự án của bạn
            isLibrarian = emp.getRoleId() == 2;
        }

        req.setAttribute("book", book);
        req.setAttribute("isReader", isReader);
        req.setAttribute("isLibrarian", isLibrarian);
        req.setAttribute("isFavorite", isFavorite);
        req.setAttribute("hasPendingBorrow", hasPendingBorrow);
        req.setAttribute("isBorrowingThisBook", isBorrowingThisBook);

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
