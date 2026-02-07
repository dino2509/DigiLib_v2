package controller.librarian;

import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.BorrowRequest;
import model.Employee;

@WebServlet(urlPatterns = "/librarian/borrow-requests")
public class BorrowRequestsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        BorrowRequestDBContext dao = new BorrowRequestDBContext();
        ArrayList<BorrowRequest> list = dao.listPending();
        req.setAttribute("requests", list);

        int requestId = parseInt(req.getParameter("requestId"), -1);
        if (requestId > 0) {
            BorrowRequest detail = dao.getWithItems(requestId);
            req.setAttribute("detail", detail);
        }

        req.getRequestDispatcher("/view/librarian/borrow_requests.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        int requestId = parseInt(req.getParameter("requestId"), -1);
        String action = req.getParameter("action");
        String note = trimToNull(req.getParameter("decisionNote"));

        BorrowRequestDBContext dao = new BorrowRequestDBContext();

        if (requestId > 0 && "approve".equalsIgnoreCase(action)) {
            boolean ok = dao.approve(requestId, emp.getEmployeeId(), note, 14);
            if (!ok) {
                resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?requestId=" + requestId + "&error=not_enough_copies");
                return;
            }
        } else if (requestId > 0 && "reject".equalsIgnoreCase(action)) {
            dao.reject(requestId, emp.getEmployeeId(), note);
        }

        resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests");
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
