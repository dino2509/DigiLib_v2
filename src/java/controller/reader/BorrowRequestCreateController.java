package controller.reader;

import dal.BorrowDBContext;
import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;

/**
 * Reader tạo yêu cầu mượn sách từ trang Book Detail.
 */
@WebServlet(urlPatterns = "/reader/borrow/request")
public class BorrowRequestCreateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");
        int bookId = parseInt(req.getParameter("bookId"), -1);
        String note = trimToNull(req.getParameter("note"));

        if (bookId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        // Nếu đang mượn rồi -> không tạo request
        BorrowDBContext borrowDAO = new BorrowDBContext();
        if (borrowDAO.isBookCurrentlyBorrowed(reader.getReaderId(), bookId)) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&alreadyBorrowing=1");
            return;
        }

        BorrowRequestDBContext dao = new BorrowRequestDBContext();
        if (dao.hasPendingForBook(reader.getReaderId(), bookId)) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowRequested=1");
            return;
        }

        Integer requestId = dao.createSingleBookRequest(reader.getReaderId(), bookId, note);
        if (requestId == null) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowError=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowRequested=1");
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
