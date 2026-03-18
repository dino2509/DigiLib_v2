
package controller.librarian.fine;

import dal.FineDBContext;
import dao.PaymentDBContext;
import dal.NotificationDBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Fine;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;

@WebServlet("/librarian/pay-fine")
public class PayFineController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null) {
            response.sendRedirect("fines");
            return;
        }

        int fineId = Integer.parseInt(idRaw);

        FineDBContext fineDAO = new FineDBContext();
        Fine fine = fineDAO.getFineById(fineId);

        if (fine == null) {
            response.sendRedirect("fines");
            return;
        }

        request.setAttribute("fine", fine);

        request.setAttribute("contentPage", "/view/librarian/fine/pay.jsp");
        request.setAttribute("activeMenu", "fines");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int fineId = Integer.parseInt(request.getParameter("fineId"));
        String method = request.getParameter("paymentMethod");

        FineDBContext fineDAO = new FineDBContext();
        PaymentDBContext paymentDAO = new PaymentDBContext();
        NotificationDBContext notiDAO = new NotificationDBContext();

        Fine fine = fineDAO.getFineById(fineId);

        if (fine == null || "PAID".equals(fine.getStatus())) {
            response.sendRedirect("fines");
            return;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());

        // giả lập employee login
        HttpSession session = request.getSession();
        Integer employeeId = (Integer) session.getAttribute("employeeId");

        // ========================
        // 1. UPDATE FINE
        // ========================
        fineDAO.markAsPaid(fineId, employeeId, now);

        // ========================
        // 2. INSERT PAYMENT
        // ========================
        paymentDAO.insertFinePayment(
                fine.getAmount(),
                method,
                now
        );

        // ========================
        // 3. NOTIFICATION
        // ========================
        notiDAO.insertNotification(0, method, method, method);
        notiDAO.insertNotification(
                fine.getReaderId(),
                "Fine Paid",
                "Your fine has been paid successfully.",
                "FINE"
        );

        response.sendRedirect("fine-detail?id=" + fineId);
    }
}
