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

        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        int totalOrders = orderDB.countOrders();

        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        List<Order> orders = orderDB.getOrdersByPage(page, pageSize);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "Orders Management");
        request.setAttribute("activeMenu", "orders");
        request.setAttribute("contentPage", "/view/librarian/order/orders.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp").forward(request, response);
    }
}
