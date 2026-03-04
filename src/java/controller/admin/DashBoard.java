package controller.admin;

import dal.DashboardDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = "/admin/dashboard")
public class DashBoard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        DashboardDBContext db = new DashboardDBContext();

        int totalBooks = db.countBooks();
        int totalReaders = db.countReaders();
        int totalBorrowed = db.countBorrowing();
        int totalOrders = db.countOrders();

        req.setAttribute("totalBooks", totalBooks);
        req.setAttribute("totalReaders", totalReaders);
        req.setAttribute("totalBorrowed", totalBorrowed);
        req.setAttribute("totalOrders", totalOrders);

        req.setAttribute("pageTitle", "Dashboard");
        req.setAttribute("activeMenu", "dashboard");
        req.setAttribute("contentPage", "../../view/admin/dashboard.jsp");

        req.getRequestDispatcher("../include/admin/layout.jsp")
                .forward(req, resp);
    }
}
