package controller.librarian.borrow;

import dal.BorrowRequestDBContext;
import dal.NotificationDBContext;
import dal.ReaderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.BorrowInfo;
import model.Employee;
import service.EmailService;
import util.EmailTemplate;

import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/librarian/request-approve")
public class RequestApproveController extends HttpServlet {

    private BorrowRequestDBContext dao;

    @Override
    public void init() {
        dao = new BorrowRequestDBContext();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Employee emp = (Employee) session.getAttribute("user");
            int employeeId = emp.getEmployeeId();

            String requestIdParam = request.getParameter("requestId");
            String dueDate = request.getParameter("dueDate");
            String note = request.getParameter("note");

            if (requestIdParam == null || dueDate == null || dueDate.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int requestId = Integer.parseInt(requestIdParam);

            // ===== 1. BUSINESS =====
            dao.approveRequest(requestId, employeeId, dueDate, note);

            // ===== 2. GET READER =====
            int readerId = dao.getReaderIdByRequestId(requestId);

            ReaderDBContext readerDAO = new ReaderDBContext();
            String email = readerDAO.getEmailById(readerId);

            if (email == null || email.isBlank()) {
                System.out.println("⚠️ Email is null for readerId=" + readerId);
            }

            // ===== 3. GET BOOK INFO =====
            BorrowInfo info = dao.getBorrowInfo(requestId);

            String title = "Unknown Book";
            int isbn = 0;
            String formattedDate = dueDate; // fallback

            if (info != null) {
                if (info.getTitle() != null) {
                    title = info.getTitle();
                }
                if (info.getIsbn()!= 0) {
                    isbn = info.getIsbn();
                }

                if (info.getDueDate() != null) {
                    formattedDate = new SimpleDateFormat("dd/MM/yyyy")
                            .format(dueDate);
                }
            } else {
                System.out.println("⚠️ BorrowInfo NULL for requestId=" + requestId);
            }

            // ===== 4. EMAIL (SAFE) =====
            if (email != null && !email.isBlank()) {

                try {
                    String html = EmailTemplate.borrowApproved(title, isbn, formattedDate);

                    EmailService.sendAsync(
                            email,
                            "DigiLib - Borrow Approved",
                            html
                    );

                } catch (Exception mailEx) {
                    System.out.println("❌ Email send failed:");
                    mailEx.printStackTrace();
                }
            }

            // ===== 5. NOTIFICATION =====
            NotificationDBContext notiDAO = new NotificationDBContext();
            notiDAO.insertNotification(
                    readerId,
                    "Borrow Approved",
                    "Book: " + title + " has been approved",
                    "BORROW_APPROVED"
            );

            response.sendRedirect(request.getContextPath() + "/librarian/requests");

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
