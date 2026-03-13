package controller.librarian.payment;

import dao.PaymentDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Payment;

@WebServlet("/librarian/payments")
public class LibrarianPaymentsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PaymentDBContext paymentDB = new PaymentDBContext();

        int page = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        int totalPayments = paymentDB.countPayments();
        int totalPages = (int) Math.ceil((double) totalPayments / pageSize);

        List<Payment> payments = paymentDB.getPaymentsByPage(page, pageSize);

        request.setAttribute("payments", payments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "Payments");
        request.setAttribute("activeMenu", "payments");
        request.setAttribute("contentPage", "/view/librarian/payment/payments.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp").forward(request, response);
    }
}
