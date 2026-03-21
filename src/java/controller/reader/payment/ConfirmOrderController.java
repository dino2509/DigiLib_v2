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
import java.util.List;
import model.CartItem;
import model.Reader;

@WebServlet("/reader/checkout/confirm")
public class ConfirmOrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        String[] cartItemIds = request.getParameterValues("cartItemIds");

        OrderDBContext orderDAO = new OrderDBContext();

        List<CartItem> items = orderDAO.getCartItemsByIds(cartItemIds);

        double total = items.stream()
                .mapToDouble(i -> i.getPrice() * i.getQuantity())
                .sum();

        // 👉 Tạo full order
        int orderId = orderDAO.createFullOrder(
                reader.getReaderId(),
                items,
                total,
                "CASH"
        );

        orderDAO.updatePaymentStatus(orderId, "PENDING");

        orderDAO.removeCartItems(cartItemIds);

        // 👉 gửi mail
        orderDAO.sendInvoiceEmail(reader.getEmail(), orderId);

        response.sendRedirect(request.getContextPath() + "/reader/order/success");
    }
}
