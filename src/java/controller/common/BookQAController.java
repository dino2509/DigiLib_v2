package controller.common;

import dal.BookQADBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;

/**
 * Reader gửi câu hỏi về sách (Q&A).
 */
@WebServlet(urlPatterns = "/books/qna")
public class BookQAController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int bookId = parseInt(req.getParameter("bookId"), -1);
        String question = trimToNull(req.getParameter("question"));
        if (bookId <= 0 || question == null) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId);
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");
        BookQADBContext qaDAO = new BookQADBContext();
        qaDAO.insertQuestion(bookId, reader.getReaderId(), question);

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
