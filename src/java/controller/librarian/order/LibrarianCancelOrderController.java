package controller.librarian.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import service.EmailService;
import util.EmailTemplate;
import java.text.SimpleDateFormat;

import java.util.List;

@WebServlet("/librarian/order/cancel")
public class LibrarianCancelOrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String reason = request.getParameter("reason");

        if (reason == null || reason.isBlank()) {
            reason = "Không có lý do cụ thể";
        }

        OrderDBContext dao = new OrderDBContext();

        // 🔹 1. hủy đơn
        dao.cancelOrder(orderId);

        // 🔹 2. lấy email + order info
        String email = dao.getReaderEmailByOrder(orderId);
        model.Order order = dao.getOrderById(orderId);
        List<model.OrderBook> items = dao.getOrderBooks(orderId);
        // 🔹 format time

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String createdAt = sdf.format(order.getCreatedAt());
// 🔹 build email
        String html = EmailTemplate.orderCancelled(
                orderId,
                order.getReaderName(), // cần join hoặc lấy thêm
                createdAt,
                dao.getPaymentMethod(orderId),
                items,
                String.valueOf(order.getTotalAmount()),
                order.getCurrency(),
                reason
        );

// 🔹 send
        EmailService.sendAsync(
                email,
                "DigiLib - Order #" + orderId + " Cancelled",
                html
        );

        response.sendRedirect(request.getContextPath() + "/librarian/orders?cancel=1");
    }
}
