package controller.reader.order;

import dao.CartDBContext;
import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.CartItem;
import model.Reader;

@WebServlet("/reader/checkout")
public class ReaderCheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String[] cartItemIds = request.getParameterValues("cartItemIds");

        if (cartItemIds == null || cartItemIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/reader/cart");
            return;
        }

        OrderDBContext orderDAO = new OrderDBContext();

        // lấy danh sách item được chọn
        List<CartItem> items = orderDAO.getCartItemsByIds(cartItemIds);

        double total = 0;

        for (CartItem item : items) {
            total += item.getPrice() * item.getQuantity();
        }

        request.setAttribute("items", items);
        request.setAttribute("total", total);
        request.setAttribute("cartItemIds", cartItemIds);

        request.setAttribute("contentPage", "/view/reader/order/payment.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }
}
