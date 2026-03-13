package controller.reader.cart;

import dao.CartDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Reader;

@WebServlet("/reader/cart/add")
public class CartAddController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int bookId = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession();
            Reader reader = (Reader) session.getAttribute("user");

            if (reader == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            CartDBContext cartDAO = new CartDBContext();

            // lấy cart của reader (tự tạo nếu chưa có)
            int cartId = cartDAO.getCartIdByReader(reader.getReaderId());

            // thêm sách vào cart
            cartDAO.addToCart(cartId, bookId);

            response.sendRedirect(request.getContextPath() + "/reader/cart");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reader/books");
        }
    }
}
