package controller.librarian;

import dal.LibrarianBorrowDBContext;
import dal.ReturnRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import model.Employee;
import model.LibrarianBorrowItem;

@WebServlet(urlPatterns = "/librarian/borrowed-books")
public class BorrowedBooksController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
        if (filter == null || filter.trim().isEmpty()) filter = "borrowing";

        LibrarianBorrowDBContext dao = new LibrarianBorrowDBContext();
        ArrayList<LibrarianBorrowItem> list = dao.listByFilter(filter);

        req.setAttribute("items", list);
        req.setAttribute("filter", filter);

        req.getRequestDispatcher("/view/librarian/borrowed_books.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
        if (filter == null || filter.trim().isEmpty()) filter = "borrowing";

        String action = req.getParameter("action");
        int borrowItemId = parseInt(req.getParameter("borrowItemId"), -1);

        // optional: for pending return request
        int returnRequestId = parseInt(req.getParameter("returnRequestId"), -1);

        java.math.BigDecimal damageAmount = parseBigDecimal(req.getParameter("damageAmount"));
        String damageReason = req.getParameter("damageReason");
        String decisionNote = req.getParameter("decisionNote");

        if (("return".equalsIgnoreCase(action) || "confirm".equalsIgnoreCase(action)) && borrowItemId > 0) {
            ReturnRequestDBContext rrDao = new ReturnRequestDBContext();
            boolean ok = rrDao.confirmOrCreateAndAutoConfirm(emp.getEmployeeId(), borrowItemId, damageAmount, damageReason);

            if (!ok) {
                resp.sendRedirect(req.getContextPath() + "/librarian/borrowed-books?filter=" + filter + "&returnError=1");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/librarian/borrowed-books?filter=" + filter + "&returned=1");
            return;
        }

        if ("reject".equalsIgnoreCase(action) && returnRequestId > 0) {
            ReturnRequestDBContext rrDao = new ReturnRequestDBContext();
            boolean ok = rrDao.reject(emp.getEmployeeId(), returnRequestId,
                    (decisionNote == null || decisionNote.trim().isEmpty()) ? "Từ chối yêu cầu trả sách" : decisionNote);
            if (!ok) {
                resp.sendRedirect(req.getContextPath() + "/librarian/borrowed-books?filter=" + filter + "&rejectError=1");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/librarian/borrowed-books?filter=" + filter + "&rejected=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/librarian/borrowed-books?filter=" + filter);
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private java.math.BigDecimal parseBigDecimal(String s) {
        try {
            if (s == null) return null;
            s = s.trim();
            if (s.isEmpty()) return null;
            java.math.BigDecimal bd = new java.math.BigDecimal(s);
            if (bd.compareTo(java.math.BigDecimal.ZERO) <= 0) return null;
            return bd;
        } catch (Exception e) {
            return null;
        }
    }
}