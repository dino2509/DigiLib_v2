package controller.reader;

import dao.CartDBContext;
import dao.OrderDBContext;
import dao.PaymentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.CartItem;
import model.Reader;

@WebServlet("/reader/payment")
public class ReaderPaymentController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader reader = (Reader) request.getSession().getAttribute("user");

        CartDBContext cartDAO = new CartDBContext();
        OrderDBContext orderDAO = new OrderDBContext();
        PaymentDBContext paymentDAO = new PaymentDBContext();

        int cartId = cartDAO.getCartIdByReader(reader.getReaderId());

        List<CartItem> items = orderDAO.getCartItemsWithPrice(cartId);

        double total = 0;

        for (CartItem item : items) {
            total += item.getPrice() * item.getQuantity();
        }

        // 1️⃣ create order
        int orderId = orderDAO.createOrder(reader.getReaderId(), total);

        // 2️⃣ insert books
        for (CartItem item : items) {

            orderDAO.insertOrderBook(
                    orderId,
                    item.getBookId(),
                    item.getPrice(),
                    item.getQuantity()
            );
        }

        // 3️⃣ create payment
        String method = request.getParameter("method");
        paymentDAO.createPayment(orderId, total, method);

        // 4️⃣ clear cart
        orderDAO.clearCart(cartId);

        response.sendRedirect(request.getContextPath() + "/reader/orders");
    }
}
