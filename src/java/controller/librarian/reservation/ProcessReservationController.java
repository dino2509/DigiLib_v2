package controller.librarian.reservation;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

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

            if ("cancel".equals(action)) {

                reservationDB.cancelReservation(reservationId);

                response.sendRedirect(request.getContextPath() + "/librarian/reservations");

            } else if ("fulfill".equals(action)) {

                // tạo Borrow Request từ Reservation
                int requestId = reservationDB.fulfillReservation(reservationId);

                // chuyển tới trang xử lý request
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
