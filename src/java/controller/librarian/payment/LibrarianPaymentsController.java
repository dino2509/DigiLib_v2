package controller.librarian.payment;

import dao.PaymentDBContext;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Payment;

@WebServlet("/librarian/payments")
public class LibrarianPaymentsController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PaymentDBContext paymentDB = new PaymentDBContext();

        int page = 1;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }

        String search = trimParam(request.getParameter("search"));
        String status = trimParam(request.getParameter("status"));

        int total = paymentDB.countPayments(search, status);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        List<Payment> payments
                = paymentDB.getPaymentsByPage(page, PAGE_SIZE, search, status);

        request.setAttribute("payments", payments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.setAttribute("contentPage",
                "/view/librarian/payment/payments.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }

    private String trimParam(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }
}
