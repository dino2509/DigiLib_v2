package controller.reader.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import model.CartItem;
import model.OrderBook;
import model.Reader;
import service.EmailService;
import util.EmailTemplate;

@WebServlet("/reader/checkout")
public class ReaderCheckoutController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");

        OrderDBContext orderDAO = new OrderDBContext();
        String[] cartItemIds = request.getParameterValues("cartItemIds");

        if (cartItemIds == null || cartItemIds.length == 0) {
            response.sendRedirect("cart?error=empty");
            return;
        }

        List<CartItem> items = orderDAO.getCartItemsByIds(cartItemIds);

        if (items == null || items.isEmpty()) {
            response.sendRedirect("cart?error=no_items");
            return;
        }

        double total = items.stream()
                .mapToDouble(i -> i.getPrice() * i.getQuantity())
                .sum();

        if ("CASH".equals(paymentMethod)) {

            int orderId = orderDAO.createFullOrder(
                    reader.getReaderId(),
                    items,
                    total,
                    "CASH"
            );

            // 🔹 CASH flow
            orderDAO.updateOrderStatus(orderId, "WAITING_PAYMENT");
            orderDAO.updatePaymentStatus(orderId, "PENDING", null);

            // 🔹 Xóa cart
            orderDAO.removeCartItems(cartItemIds);

            // 🔹 gửi mail
            // 🔹 Lấy order books
            List<model.OrderBook> orderBooks = orderDAO.getOrderBooks(orderId);

// 🔹 format time
            String createdAt = LocalDateTime.now()
                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

// 🔹 build email HTML
            String html = EmailTemplate.waitingPayment(
                    orderId,
                    reader.getFullName(),
                    createdAt,
                    orderBooks,
                    String.valueOf(total),
                    "VND"
            );

// 🔹 send async email
            EmailService.sendAsync(
                    reader.getEmail(),
                    "DigiLib - Order #" + orderId + " Waiting for Payment",
                    html
            );
            request.setAttribute("orderId", orderId);
            request.setAttribute("contentPage", "/view/reader/payment/cash-success.jsp");

            request.getRequestDispatcher("/include/reader/layout.jsp")
                    .forward(request, response);

        } else if ("QR".equals(paymentMethod)) {

            int orderId = orderDAO.createFullOrderQR(
                    reader.getReaderId(),
                    items,
                    total,
                    "QR"
            );

            orderDAO.updateOrderStatus(orderId, "WAITING_PAYMENT");
            orderDAO.updatePaymentStatus(orderId, "PENDING", null);
            orderDAO.removeCartItems(cartItemIds);

            model.Order order = orderDAO.getOrderById(orderId);
            List<OrderBook> orderBooks = orderDAO.getOrderBooks(orderId);

            String qrUrl = orderDAO.generateQRUrl(orderId, total);

            request.setAttribute("order", order);
            request.setAttribute("items", orderBooks);
            request.setAttribute("qrUrl", qrUrl);

            request.setAttribute("contentPage", "/view/reader/payment/qr-payment.jsp");

            request.getRequestDispatcher("/include/reader/layout.jsp")
                    .forward(request, response);
        }
    }
}
