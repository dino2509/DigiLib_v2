package controller.reader.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.OrderItem;
import model.Reader;

@WebServlet("/reader/orders")
public class ReaderOrdersController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader reader = (Reader) request.getSession().getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDBContext dao = new OrderDBContext();

        List<OrderItem> orders = dao.getOrdersByReader(reader.getReaderId());

        request.setAttribute("orders", orders);

        request.setAttribute("pageTitle", "My Orders");
        request.setAttribute("activeMenu", "orders");
        request.setAttribute("contentPage", "/view/reader/order/orders.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }
}
