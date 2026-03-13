package controller.librarian.reservation;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/librarian/reservation-fulfill")
public class ReservationFulfillController extends HttpServlet {

    ReservationDBContext reservationDB = new ReservationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int reservationId = Integer.parseInt(request.getParameter("id"));

        reservationDB.fulfillReservation(reservationId);

        response.sendRedirect(request.getContextPath()
                + "/librarian/reservation-queue");
    }
}
