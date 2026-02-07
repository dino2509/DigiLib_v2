package controller.librarian;

import dal.BookQADBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.BookQuestion;
import model.Employee;

@WebServlet(urlPatterns = "/librarian/qna")
public class QnAController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        BookQADBContext qaDAO = new BookQADBContext();
        ArrayList<BookQuestion> list = qaDAO.listUnanswered();

        req.setAttribute("questions", list);
        req.getRequestDispatcher("/view/librarian/qna.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        int questionId = parseInt(req.getParameter("questionId"), -1);
        String answer = trimToNull(req.getParameter("answer"));
        if (questionId > 0 && answer != null) {
            BookQADBContext qaDAO = new BookQADBContext();
            qaDAO.insertAnswer(questionId, emp.getEmployeeId(), answer);
        }

        resp.sendRedirect(req.getContextPath() + "/librarian/qna");
    }

    private Employee requireLibrarian(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Employee)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        Employee emp = (Employee) session.getAttribute("user");
        if (emp.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/view/error/403.jsp");
            return null;
        }
        return emp;
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
