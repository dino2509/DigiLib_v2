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
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        if (search != null && search.trim().isEmpty()) {
            search = null;
        }

        if (status != null && status.trim().isEmpty()) {
            status = null;
        }

        int totalPayments = paymentDB.countPayments(search, status);
        int totalPages = (int) Math.ceil((double) totalPayments / pageSize);

        List<Payment> payments = paymentDB.getPaymentsByPage(page, pageSize, search, status);

        request.setAttribute("payments", payments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("search", search);
        request.setAttribute("status", status);

        request.setAttribute("pageTitle", "Payments");
        request.setAttribute("activeMenu", "payments");
        request.setAttribute("contentPage", "/view/librarian/payment/payments.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
