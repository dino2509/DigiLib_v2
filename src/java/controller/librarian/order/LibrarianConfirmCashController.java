package controller.librarian.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/order/confirm-cash")
public class LibrarianConfirmCashController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdRaw = request.getParameter("orderId");

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

// 🔹 1. update DB
        dao.confirmCashPayment(orderId);

// 🔹 2. lấy thông tin
        String email = dao.getReaderEmailByOrder(orderId);
        model.Order order = dao.getOrderById(orderId);
        List<model.OrderBook> items = dao.getOrderBooks(orderId);

// 🔹 3. format dữ liệu
        String createdAt = order.getCreatedAt().toString();
        String total = order.getTotalAmount().toString();

// 🔹 4. tạo email
        String html = util.EmailTemplate.paymentInvoice(
                orderId,
                order.getReaderName(),
                "CASH",
                createdAt,
                items,
                total,
                order.getCurrency()
        );

// 🔹 5. gửi mail
        service.EmailService.sendAsync(
                email,
                "Invoice - DigiLib",
                html
        );

        // 🔹 5. Redirect
        response.sendRedirect(request.getContextPath() + "/librarian/orders?success=1");
    }
}
