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

@WebServlet("/librarian/request-reject")
public class RequestRejectController extends HttpServlet {

    private BorrowRequestDBContext dao = new BorrowRequestDBContext();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ===== SESSION CHECK =====
            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // ===== INPUT =====
            String requestIdParam = request.getParameter("requestId");
            String note = request.getParameter("note");

            if (requestIdParam == null || requestIdParam.isBlank()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int requestId = Integer.parseInt(requestIdParam);

            Employee emp = (Employee) session.getAttribute("user");
            int employeeId = emp.getEmployeeId();

            // ===== 1. BUSINESS =====
            dao.rejectRequest(requestId, employeeId, note);

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

            if (info != null) {

                // title
                if (info.getTitle() != null && !info.getTitle().isBlank()) {
                    title = info.getTitle();
                }

                // isbn (INT → STRING)
                if (info.getIsbn() != 0) {
                    isbn = info.getIsbn();
                    
                }

            } else {
                System.out.println("⚠️ BorrowInfo NULL for requestId=" + requestId);
            }

            // ===== 4. EMAIL (SAFE) =====
            if (email != null && !email.isBlank()) {

                try {

                    String html = EmailTemplate.borrowRejected(
                            title,
                            isbn,
                            note
                    );

                    EmailService.sendAsync(
                            email,
                            "DigiLib - Borrow Rejected",
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
                    "Borrow Rejected",
                    "Book: " + title + " has been rejected",
                    "BORROW_REJECTED"
            );

            // ===== REDIRECT =====
            response.sendRedirect(
                    request.getContextPath() + "/librarian/requests"
            );

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
