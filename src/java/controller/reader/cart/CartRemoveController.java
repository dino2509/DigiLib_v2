package controller.reader.cart;

import dao.CartDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reader/cart-remove")
public class CartRemoveController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));

        CartDBContext dao = new CartDBContext();

        dao.removeCartItem(cartItemId);

        response.sendRedirect(request.getContextPath() + "/reader/cart");
    }
}
