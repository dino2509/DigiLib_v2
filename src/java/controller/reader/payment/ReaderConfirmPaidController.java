/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reader.payment;

import dao.OrderDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reader;
import service.EmailService;
import util.EmailTemplate;

@WebServlet("/reader/confirm-paid")
public class ReaderConfirmPaidController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect("login");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        OrderDBContext dao = new OrderDBContext();

        // 🔥 1. expire trước
        dao.expireQRPayments();

        // 🔒 2. check ownership
        if (!dao.isOrderOwnedByReader(orderId, reader.getReaderId())) {
            response.sendRedirect("error");
            return;
        }

        // 🔥 3. check status hiện tại
        String orderStatus = dao.getOrderStatus(orderId);
        String paymentStatus = dao.getPaymentStatus(orderId);

        // ❌ không cho confirm nếu đã xử lý
        if (!"WAITING_PAYMENT".equals(orderStatus) || !"PENDING".equals(paymentStatus)) {
            response.sendRedirect("orders?error=invalid_state");
            return;
        }

        // 🔥 4. check expired
        if (dao.isOrderExpired(orderId)) {
            response.sendRedirect("orders?error=expired");
            return;
        }

        // 🔥 5. update (transaction-safe)
        dao.confirmQRPayment(orderId);

        // 🔥 6. gửi email
        String html = EmailTemplate.paymentInvoice(
                orderId,
                reader.getFullName(),
                "QR TRANSFER",
                new java.util.Date().toString(),
                dao.getOrderBooks(orderId),
                String.valueOf(dao.getOrderTotal(orderId)),
                "VND"
        );

        EmailService.sendAsync(
                reader.getEmail(),
                "Payment Successful - DigiLib",
                html
        );

        response.sendRedirect("../view/reader/payment/success.jsp?orderId=" + orderId);
    }
}
