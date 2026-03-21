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

        int page = 1;
        int pageSize = 10;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
        }

        OrderDBContext dao = new OrderDBContext();

        int totalOrders = dao.countOrdersByReader(reader.getReaderId());
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        List<OrderItem> orders = dao.getOrdersByReaderPaging(
                reader.getReaderId(), page, pageSize
        );

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
         request.setAttribute("activeMenu", "orders");
        
        request.setAttribute("contentPage", "/view/reader/order/orders.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }
}
