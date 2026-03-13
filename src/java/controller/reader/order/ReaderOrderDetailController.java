/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.reader.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.OrderBook;

@WebServlet("/reader/order-detail")
public class ReaderOrderDetailController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("id"));

        OrderDBContext dao = new OrderDBContext();

        List<OrderBook> items = dao.getOrderBooks(orderId);

        request.setAttribute("items", items);

        request.setAttribute("contentPage", "/view/reader/order/order-detail.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }
}
