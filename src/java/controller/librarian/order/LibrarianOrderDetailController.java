package controller.librarian.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Order;
import model.OrderBook;

@WebServlet("/librarian/order-detail")
public class LibrarianOrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdRaw = request.getParameter("id");

        if (orderIdRaw == null) {
            response.sendRedirect(request.getContextPath() + "/librarian/orders");
            return;
        }

        int orderId;

        try {
            orderId = Integer.parseInt(orderIdRaw);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/librarian/orders");
            return;
        }

        OrderDBContext dao = new OrderDBContext();

        // ✅ CHỈ KHAI BÁO 1 LẦN
        Order order = dao.getOrderById(orderId);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/librarian/orders");
            return;
        }

        List<OrderBook> items = dao.getOrderBooks(orderId);

        request.setAttribute("order", order);
        request.setAttribute("items", items);

        request.setAttribute("contentPage", "/view/librarian/order/order-detail.jsp");
        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
