package controller.reader.cart;

import dao.CartDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.CartItem;
import model.Reader;

@WebServlet("/reader/cart")
public class ReaderCartController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // lấy reader từ session
        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CartDBContext cartDAO = new CartDBContext();

        // lấy cart của reader
        int cartId = cartDAO.getCartIdByReader(reader.getReaderId());

        // lấy danh sách item
        List<CartItem> cartItems = cartDAO.getCartItems(cartId);

        // gửi dữ liệu sang JSP
        request.setAttribute("cartItems", cartItems);

        // layout system của project
        request.setAttribute("pageTitle", "My Cart");
        request.setAttribute("activeMenu", "cart");
        request.setAttribute("contentPage", "/view/reader/cart/cart.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }

}
