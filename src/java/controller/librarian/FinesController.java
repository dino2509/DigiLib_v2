package controller.librarian;

import dal.FineDBContext;
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
import model.Fine;

@WebServlet(urlPatterns = "/librarian/fines")
public class FinesController extends HttpServlet {

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

        String tab = req.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) tab = "UNPAID";
        tab = tab.trim().toUpperCase();
        if (!tab.equals("UNPAID") && !tab.equals("PAID") && !tab.equals("ALL")) tab = "UNPAID";

        FineDBContext fineDao = new FineDBContext();
        // keep overdue fines up to date
        fineDao.refreshOverdueFinesForBorrowingItems();

        ArrayList<Fine> fines = fineDao.listByStatus(tab);
        BigDecimal[] totals = fineDao.getTotals();
        int[] counts = fineDao.getCounts();

        req.setAttribute("tab", tab);
        req.setAttribute("fines", fines);
        req.setAttribute("unpaidTotal", totals[0]);
        req.setAttribute("paidTotal", totals[1]);
        req.setAttribute("unpaidCount", counts[0]);
        req.setAttribute("paidCount", counts[1]);

        req.getRequestDispatcher("/view/librarian/fines.jsp").forward(req, resp);
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

        String action = req.getParameter("action");
        int fineId = parseInt(req.getParameter("fineId"), -1);
        String tab = req.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) tab = "UNPAID";

        if ("paid".equalsIgnoreCase(action) && fineId > 0) {
            FineDBContext fineDao = new FineDBContext();
            boolean ok = fineDao.markPaid(fineId, emp.getEmployeeId());
            if (!ok) {
                resp.sendRedirect(req.getContextPath() + "/librarian/fines?tab=" + tab + "&payError=1");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/librarian/fines?tab=" + tab + "&paid=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/librarian/fines?tab=" + tab);
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