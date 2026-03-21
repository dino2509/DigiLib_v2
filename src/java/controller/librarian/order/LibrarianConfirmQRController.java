/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.librarian.order;

import dao.OrderDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.EmailService;
import util.EmailTemplate;

@WebServlet("/librarian/confirm-payment")
public class LibrarianConfirmQRController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        OrderDBContext dao = new OrderDBContext();

        // 🔥 update
        dao.updatePaymentStatus(orderId, "SUCCESS", null);
        dao.updateOrderStatus(orderId, "WAITING_PICKUP");

        // 🔥 gửi email
        String email = dao.getReaderEmailByOrder(orderId);

        String html = EmailTemplate.paymentInvoice(
                orderId,
                dao.getReaderName(orderId),
                "QR TRANSFER",
                new java.util.Date().toString(),
                dao.getOrderBooks(orderId),
                String.valueOf(dao.getOrderTotal(orderId)),
                "VND"
        );

        EmailService.sendAsync(
                email,
                "Payment Confirmed - DigiLib",
                html
        );

        response.sendRedirect("orders?success=1");
    }
}
