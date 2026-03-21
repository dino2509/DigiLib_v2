package controller.reader.order;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.CartItem;
import model.Reader;

@WebServlet("/reader/check-order")
public class ReaderCheckOrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        // 🔒 Check login
        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String[] cartItemIds = request.getParameterValues("cartItemIds");

        // ❌ Không chọn item
        if (cartItemIds == null || cartItemIds.length == 0) {
            session.setAttribute("error", "Vui lòng chọn ít nhất 1 sách!");
            response.sendRedirect(request.getContextPath() + "/reader/cart");
            return;
        }

        OrderDBContext orderDAO = new OrderDBContext();

        // 🔥 Lấy danh sách item
        List<CartItem> items = orderDAO.getCartItemsByIds(cartItemIds);

        double total = 0;
        for (CartItem item : items) {
            total += item.getTotal();
        }

        // 👉 gửi sang JSP
        request.setAttribute("items", items);
        request.setAttribute("total", total);
        request.setAttribute("cartItemIds", cartItemIds);

        request.setAttribute("contentPage", "/view/reader/order/check-order.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
