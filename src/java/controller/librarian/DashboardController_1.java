package controller.librarian;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import dal.FineDBContext;
import model.Employee;

@WebServlet(urlPatterns = "/librarian/dashboard")
public class DashboardController_1 extends HttpServlet {

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

        // ===== Fines overview for dashboard =====
        FineDBContext fineDao = new FineDBContext();
        // Update/create overdue fines for current overdue borrow items
        fineDao.refreshOverdueFinesForBorrowingItems();

        BigDecimal[] totals = fineDao.getTotals();
        int[] counts = fineDao.getCounts();

        req.setAttribute("unpaidTotal", totals[0]);
        req.setAttribute("paidTotal", totals[1]);
        req.setAttribute("unpaidCount", counts[0]);
        req.setAttribute("paidCount", counts[1]);

        req.getRequestDispatcher("/view/librarian/dashboard.jsp").forward(req, resp);
    }
}