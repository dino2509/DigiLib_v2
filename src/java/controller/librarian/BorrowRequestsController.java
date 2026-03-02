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

        String filter = req.getParameter("filter");
        if (filter == null || filter.trim().isEmpty()) filter = "pending";
        filter = normalizeFilter(filter);

        BorrowRequestDBContext dao = new BorrowRequestDBContext();
        ArrayList<BorrowRequest> list = dao.listByStatus(filter, 200);
        req.setAttribute("requests", list);
        req.setAttribute("filter", filter);

        int requestId = parseInt(req.getParameter("requestId"), -1);
        if (requestId > 0) {
            BorrowRequest detail = dao.getWithItems(requestId);
            req.setAttribute("detail", detail);
        }

        req.getRequestDispatcher("/view/librarian/borrow_requests.jsp").forward(req, resp);
    }

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

        String filter = req.getParameter("filter");
        if (filter == null || filter.trim().isEmpty()) filter = "pending";
        filter = normalizeFilter(filter);

        int requestId = parseInt(req.getParameter("requestId"), -1);
        String action = req.getParameter("action");
        String note = trimToNull(req.getParameter("decisionNote"));

        int dueDays = parseInt(req.getParameter("dueDays"), 14);
        if (dueDays < 7) dueDays = 7;
        if (dueDays > 14) dueDays = 14;

        BorrowRequestDBContext dao = new BorrowRequestDBContext();

        if (requestId > 0 && "approve".equalsIgnoreCase(action)) {
            boolean ok = dao.approve(requestId, emp.getEmployeeId(), note, dueDays);
            if (!ok) {
                resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=" + filter + "&requestId=" + requestId + "&error=not_enough_copies");
                return;
            }
            // duyệt xong -> tự chuyển tab approved
            resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=approved");
            return;
        } else if (requestId > 0 && "reject".equalsIgnoreCase(action)) {
            dao.reject(requestId, emp.getEmployeeId(), note);
            // từ chối xong -> tự chuyển tab rejected
            resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=rejected");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=" + filter);
    }

    private String normalizeFilter(String filter) {
        filter = filter.trim().toLowerCase();
        switch (filter) {
            case "pending", "approved", "rejected", "all" -> {
                return filter;
            }
            default -> {
                return "pending";
            }
        }
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
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