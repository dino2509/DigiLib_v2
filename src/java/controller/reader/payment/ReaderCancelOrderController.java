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

@WebServlet("/reader/cancel-order")
public class ReaderCancelOrderController extends HttpServlet {

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

        // 🔒 check ownership
        if (!dao.isOrderOwnedByReader(orderId, reader.getReaderId())) {
            response.sendRedirect("error");
            return;
        }

        // 🔥 chỉ cho hủy nếu chưa thanh toán
        String status = dao.getOrderStatus(orderId);

        if (!"WAITING_PAYMENT".equals(status)) {
            response.sendRedirect("orders?error=cannot_cancel");
            return;
        }

        // 🔥 update DB
        dao.updateOrderStatus(orderId, "FAILED");
        dao.updatePaymentStatus(orderId, "FAILED", null);

        // 🔥 redirect
        response.sendRedirect("orders?msg=cancelled");
    }
}
