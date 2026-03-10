package controller.librarian;

import dal.BorrowExtendDBContext;
import dal.LibrarianBorrowDBContext;
import dal.ReturnRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import model.Employee;
import model.LibrarianBorrowItem;

@WebServlet(urlPatterns = "/librarian/borrowed-books")
public class BorrowedBooksController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        String filter = normalizeFilter(req.getParameter("filter"));

        LibrarianBorrowDBContext dao = new LibrarianBorrowDBContext();
        ArrayList<LibrarianBorrowItem> list = dao.listByFilter("all");

        req.setAttribute("items", list);
        req.setAttribute("filter", filter);
        req.getRequestDispatcher("/view/librarian/borrowed_books.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Employee emp = requireLibrarian(req, resp);
        if (emp == null) return;

        String action = req.getParameter("action");
        String filter = normalizeFilter(req.getParameter("filter"));

        int borrowItemId = parseInt(req.getParameter("borrowItemId"), -1);
        int returnRequestId = parseInt(req.getParameter("returnRequestId"), -1);
        int extendDays = parseInt(req.getParameter("extendDays"), -1);

        BigDecimal damageAmount = parseBigDecimal(req.getParameter("damageAmount"));
        String damageReason = trimToNull(req.getParameter("damageReason"));
        String decisionNote = trimToNull(req.getParameter("decisionNote"));

        String redirectBase = req.getContextPath() + "/librarian/borrowed-books?filter=" + filter;

        if (("return".equalsIgnoreCase(action) || "confirm".equalsIgnoreCase(action)) && borrowItemId > 0) {
            ReturnRequestDBContext rrDao = new ReturnRequestDBContext();
            boolean ok = rrDao.confirmOrCreateAndAutoConfirm(
                    emp.getEmployeeId(),
                    borrowItemId,
                    damageAmount,
                    damageReason
            );
            resp.sendRedirect(redirectBase + (ok ? "&returned=1" : "&returnError=1"));
            return;
        }

        if ("reject".equalsIgnoreCase(action) && returnRequestId > 0) {
            ReturnRequestDBContext rrDao = new ReturnRequestDBContext();
            boolean ok = rrDao.reject(
                    emp.getEmployeeId(),
                    returnRequestId,
                    decisionNote == null ? "Từ chối yêu cầu trả sách" : decisionNote
            );
            resp.sendRedirect(redirectBase + (ok ? "&rejected=1" : "&rejectError=1"));
            return;
        }

        if ("extend".equalsIgnoreCase(action) && borrowItemId > 0) {
            if (extendDays < 1) extendDays = 1;
            if (extendDays > 14) extendDays = 14;

            BorrowExtendDBContext dao = new BorrowExtendDBContext();
            Integer id = dao.createByLibrarian(emp.getEmployeeId(), borrowItemId, extendDays);
            resp.sendRedirect(redirectBase + (id != null ? "&extendRequested=1" : "&extendError=1"));
            return;
        }

        resp.sendRedirect(redirectBase);
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

    private String normalizeFilter(String filter) {
        if (filter == null || filter.trim().isEmpty()) return "all";
        filter = filter.trim().toLowerCase();
        return switch (filter) {
            case "all", "borrowing", "overdue", "returned" -> filter;
            default -> "all";
        };
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private BigDecimal parseBigDecimal(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            BigDecimal bd = new BigDecimal(s.trim());
            return bd.compareTo(BigDecimal.ZERO) > 0 ? bd : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}