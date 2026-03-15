package controller.librarian.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import model.Order;

@WebServlet("/librarian/orders")
public class LibrarianOrdersController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        OrderDBContext orderDB = new OrderDBContext();

        int page = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        if (search != null && search.trim().isEmpty()) {
            search = null;
        }

        if (status != null && status.trim().isEmpty()) {
            status = null;
        }

        int totalOrders = orderDB.countOrders(search, status);

        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        List<Order> orders = orderDB.getOrdersByPage(page, pageSize, search, status);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.setAttribute("pageTitle", "Orders Management");
        request.setAttribute("activeMenu", "orders");
        request.setAttribute("contentPage", "/view/librarian/order/orders.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
