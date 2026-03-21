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

@WebServlet("/librarian/order/complete")
public class LibrarianCompleteOrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        OrderDBContext dao = new OrderDBContext();

        // 🔥 check status hiện tại
        String status = dao.getOrderStatus(orderId);

        if (!"WAITING_PICKUP".equals(status)) {
            response.sendRedirect("orders?error=invalid_state");
            return;
        }

        // 🔥 update
        dao.updateOrderStatus(orderId, "COMPLETED");

        response.sendRedirect(request.getContextPath() + "/librarian/orders?success=completed");
    }
}
