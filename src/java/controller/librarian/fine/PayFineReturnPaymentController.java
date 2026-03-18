package controller.librarian.fine;

import dal.BorrowDBContext;
import dal.FineDBContext;
import dao.PaymentDBContext;
import dal.NotificationDBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Fine;
import model.Employee;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Timestamp;
import service.EmailService;

@WebServlet("/librarian/pay-fine-payment")
public class PayFineReturnPaymentController extends HttpServlet {

    // ========================
    // 🔥 GET → HIỂN THỊ PAGE
    // ========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null) {
            response.sendRedirect("fines");
            return;
        }

        int fineId;

        try {
            fineId = Integer.parseInt(idRaw);
        } catch (Exception e) {
            response.sendRedirect("fines");
            return;
        }

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

    // ========================
    // 🔥 POST → THANH TOÁN
    // ========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fineIdRaw = request.getParameter("id");
        String method = request.getParameter("paymentMethod");

        if (fineIdRaw == null || method == null || method.isEmpty()) {
            response.sendRedirect("fines");
            return;
        }

        int fineId;

        try {
            fineId = Integer.parseInt(fineIdRaw);
        } catch (Exception e) {
            response.sendRedirect("fines");
            return;
        }

        FineDBContext fineDAO = new FineDBContext();
        BorrowDBContext borrowDAO = new BorrowDBContext();
        PaymentDBContext paymentDAO = new PaymentDBContext();
        NotificationDBContext notiDAO = new NotificationDBContext();

        Fine fine = fineDAO.getFineById(fineId);

        if (fine == null || "PAID".equalsIgnoreCase(fine.getStatus())) {
            response.sendRedirect("fines");
            return;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());

        // ========================
        // 🔥 LẤY EMPLOYEE TỪ SESSION
        // ========================
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("user");

        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int employeeId = employee.getEmployeeId();

        Connection conn = null;
        if (paymentDAO.existsByFineId(fineId)) {
            response.sendRedirect("fines");
            return;
        }
        try {

            // ========================
            // 🔥 START TRANSACTION
            // ========================
            conn = fineDAO.getConnection();
            conn.setAutoCommit(false);

            borrowDAO.setConnection(conn);
            paymentDAO.setConnection(conn);
            notiDAO.setConnection(conn);
            fineDAO.setConnection(conn);

            // ========================
            // 1. UPDATE FINE
            // ========================
            fineDAO.markAsPaid(fineId, employeeId, now);

            // ========================
            // 2. INSERT PAYMENT
            // ========================
            paymentDAO.insertFinePayment(
                    fineId,
                    fine.getAmount(),
                    method
                 
            );

            // ========================
            // 3. RETURN BOOK
            // ========================
            int borrowId = borrowDAO.getBorrowIdByFine(fineId);

            if (borrowId > 0) {
                borrowDAO.returnAllItemsByBorrowId(borrowId, now);
                borrowDAO.updateBookCopyAvailable(borrowId);
                borrowDAO.updateBorrowStatusReturned(borrowId);
            }

            // ========================
            // 4. NOTIFICATION
            // ========================
            notiDAO.insertNotification(
                    fine.getReaderId(),
                    "Payment Successful",
                    "Your overdue fine has been paid successfully.",
                    "FINE"
            );

            // ========================
// 5. SEND EMAIL
// ========================
            EmailService emailService = new EmailService();

            String email = fine.getReaderEmail(); // ⚠️ cần có field này

            String subject = "Library - Fine Payment Successful";
            String content
                    = "<div style='font-family:Arial;'>"
                    + "<h2 style='color:#ff7a00;'>Payment Successful</h2>"
                    + "<p>Your overdue fine has been paid successfully.</p>"
                    + "<p><b>Amount:</b> " + fine.getAmount() + " VND</p>"
                    + "<hr>"
                    + "<p style='color:#888;'>Digital Library System</p>"
                    + "</div>";

            emailService.sendAsync(email, subject, content);

            // ========================
            // 🔥 COMMIT
            // ========================
            conn.commit();

        } catch (Exception e) {

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            response.sendError(500);
            return;

        } finally {

            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // ========================
        // 🔥 REDIRECT ĐÚNG
        // ========================
        int borrowId = borrowDAO.getBorrowIdByFine(fineId);

        response.sendRedirect("borrow-detail?id=" + borrowId);
    }
}
