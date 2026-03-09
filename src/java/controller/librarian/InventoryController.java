package controller.librarian;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Employee;
import model.InventoryBookRow;

@WebServlet(urlPatterns = "/librarian/inventory")
public class InventoryController extends HttpServlet {

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

        String q = req.getParameter("q");
        int page = parseInt(req.getParameter("page"), 1);
        if (page < 1) page = 1;

        int pageSize = 20;
        int offset = (page - 1) * pageSize;

        BookDBContext bookDAO = new BookDBContext();
        int total = bookDAO.countInventoryRows(q);
        ArrayList<InventoryBookRow> rows = bookDAO.listInventoryRows(q, offset, pageSize);

        int totalPages = (int) Math.ceil(total / (double) pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        req.setAttribute("q", q);
        req.setAttribute("rows", rows);
        req.setAttribute("page", page);
        req.setAttribute("total", total);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/view/librarian/inventory.jsp").forward(req, resp);
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