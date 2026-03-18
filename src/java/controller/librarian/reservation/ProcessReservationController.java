package controller.librarian.reservation;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.EmailService;
import util.EmailTemplate;
import model.Reservation;
import java.io.IOException;

@WebServlet("/librarian/process-reservation")
public class ProcessReservationController extends HttpServlet {

    private ReservationDBContext reservationDB = new ReservationDBContext();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            String action = request.getParameter("action");

            // 🔥 lấy info để gửi mail
            Reservation r = reservationDB.getReservationDetail(reservationId);

            if (r == null) {
                response.sendError(404);
                return;
            }

            if ("cancel".equals(action)) {

                reservationDB.cancelReservation(reservationId);

                // 📧 send email
                String html = EmailTemplate.reservationCancelled(r.getBookTitle());

                EmailService.sendAsync(
                        r.getReaderEmail(),
                        "Reservation Cancelled",
                        html
                );

                response.sendRedirect(request.getContextPath() + "/librarian/reservations");

            } else if ("fulfill".equals(action)) {

                int requestId = reservationDB.fulfillReservation(reservationId);

                // 📧 send email
                String html = EmailTemplate.reservationFulfilled(
                        r.getBookTitle(),
                        r.getQuantity()
                );

                EmailService.sendAsync(
                        r.getReaderEmail(),
                        "Reservation Fulfilled",
                        html
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/librarian/request-detail?id=" + requestId
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
