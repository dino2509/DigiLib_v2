package controller.reader.cart;

import dao.CartDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Reader;

@WebServlet("/reader/cart-remove")
public class CartRemoveController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idRaw = request.getParameter("cartItemId");

        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reader/cart");
            return;
        }

        int cartItemId = Integer.parseInt(idRaw);

        CartDBContext cartDAO = new CartDBContext();

        boolean success = cartDAO.removeCartItem(cartItemId);

        if (!success) {
            session.setAttribute("error", "Không thể xoá sản phẩm!");
        }

        response.sendRedirect(request.getContextPath() + "/reader/cart");
    }
}