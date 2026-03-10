package controller.reader;

import dal.BookCopyDBContext;
import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;

/**
 * Reader đặt trước sách khi kho hết copy.
 *
 * POST /reader/reservation/create (bookId)
 */
@WebServlet(urlPatterns = "/reader/reservation/create")
public class ReservationCreateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        int bookId = parseInt(req.getParameter("bookId"), -1);
        if (bookId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        // Nếu đã có copy AVAILABLE thì ưu tiên flow mượn
        BookCopyDBContext copyDAO = new BookCopyDBContext();
        int available = copyDAO.countAvailableByBookId(bookId);
        if (available > 0) {
            resp.sendRedirect(req.getContextPath() + "/reader/borrow/request?bookId=" + bookId);
            return;
        }

        ReservationDBContext resDao = new ReservationDBContext();
        Integer rid = resDao.createWaiting(reader.getReaderId(), bookId);
        if (rid == null) {
            // đã có WAITING hoặc lỗi
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&reserveExists=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&reserved=1");
    }

    private Reader requireReader(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (Reader) session.getAttribute("user");
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }
}