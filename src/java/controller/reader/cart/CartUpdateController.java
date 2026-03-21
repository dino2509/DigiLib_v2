/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reader.cart;

import dao.CartDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nhat
 */
@WebServlet("/reader/cart-update")
public class CartUpdateController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("cartItemId");
        String qtyRaw = request.getParameter("quantity");

        if (idRaw == null || qtyRaw == null) {
            return;
        }

        int cartItemId = Integer.parseInt(idRaw);
        int quantity = Integer.parseInt(qtyRaw);

        if (quantity < 1) {
            quantity = 1;
        }

        CartDBContext dao = new CartDBContext();
        dao.updateQuantity(cartItemId, quantity);
    }
}
