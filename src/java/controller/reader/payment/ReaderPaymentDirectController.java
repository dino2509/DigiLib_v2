package controller.reader.payment;

import dao.OrderDBContext;
import dao.PaymentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Reader;

@WebServlet("/reader/payment-direct")
public class ReaderPaymentDirectController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader reader = (Reader) request.getSession().getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("bookId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String method = request.getParameter("method");

        OrderDBContext orderDAO = new OrderDBContext();
        PaymentDBContext paymentDAO = new PaymentDBContext();

        // 1️⃣ create order
        int orderId = orderDAO.createOrder(reader.getReaderId(), amount);

        // 2️⃣ insert book into order
        orderDAO.insertOrderBook(orderId, bookId, amount, 1);

        // 3️⃣ create payment
        paymentDAO.createPayment(orderId, amount, method);

        response.sendRedirect(request.getContextPath() + "/reader/orders");
    }
}
