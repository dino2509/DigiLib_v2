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

        if ("return".equalsIgnoreCase(action) && borrowItemId > 0) {
            ReturnRequestDBContext rrDao = new ReturnRequestDBContext();
            boolean ok = rrDao.confirmOrCreateAndAutoConfirm(emp.getEmployeeId(), borrowItemId);

            if (!ok) {
                resp.sendRedirect(req.getContextPath() + "/librarian/borrowed-books?filter=" + filter + "&returnError=1");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/librarian/borrowed-books?filter=" + filter + "&returned=1");
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
}