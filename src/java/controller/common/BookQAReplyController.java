package controller.common;

import dal.BookQADBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Employee;
import model.Reader;

/**
 * Threaded replies for Book Q&A.
 * - Reader can reply to a question thread that belongs to them.
 * - Librarian can reply to any thread.
 */
@WebServlet(urlPatterns = "/books/qna/reply")
public class BookQAReplyController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int bookId = parseInt(req.getParameter("bookId"), -1);
        int questionId = parseInt(req.getParameter("questionId"), -1);
        String reply = trimToNull(req.getParameter("reply"));

        if (bookId <= 0 || questionId <= 0 || reply == null) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "#qna");
            return;
        }

        Object user = session.getAttribute("user");
        BookQADBContext qaDAO = new BookQADBContext();

        if (user instanceof Reader) {
            Reader r = (Reader) user;
            // only allow replying to own questions
            Integer ownerReaderId = qaDAO.getReaderIdOfQuestion(questionId);
            if (ownerReaderId == null || ownerReaderId != r.getReaderId()) {
                resp.sendRedirect(req.getContextPath() + "/view/error/403.jsp");
                return;
            }
            qaDAO.insertReplyFromReader(questionId, r.getReaderId(), reply);

        } else if (user instanceof Employee) {
            Employee e = (Employee) user;
            // Only LIBRARIAN can reply here (roleId==2 in this project)
            if (e.getRoleId() != 2) {
                resp.sendRedirect(req.getContextPath() + "/view/error/403.jsp");
                return;
            }
            qaDAO.insertReplyFromEmployee(questionId, e.getEmployeeId(), reply);

        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "#qna");
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) {
                return def;
            }
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private String trimToNull(String s) {
        if (s == null) {
            return null;
        }
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
