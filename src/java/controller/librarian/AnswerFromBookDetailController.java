package controller.librarian;

import dal.BookQADBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Employee;

/**
 * Librarian trả lời trực tiếp ở /books/detail?id=... (tab Q&A).
 */
@WebServlet(urlPatterns = "/librarian/qna/answer")
public class AnswerFromBookDetailController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Employee)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Employee emp = (Employee) session.getAttribute("user");
        if (emp.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/view/error/403.jsp");
            return;
        }

        int bookId = parseInt(req.getParameter("bookId"), -1);
        int questionId = parseInt(req.getParameter("questionId"), -1);
        String answer = trimToNull(req.getParameter("answer"));

        if (bookId > 0 && questionId > 0 && answer != null) {
            BookQADBContext dao = new BookQADBContext();
            dao.insertAnswer(questionId, emp.getEmployeeId(), answer);
        }

        resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "#qna");
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
