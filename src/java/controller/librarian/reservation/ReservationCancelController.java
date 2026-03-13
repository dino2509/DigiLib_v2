package controller.librarian;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/librarian/reservation-cancel")
public class ReservationCancelController extends HttpServlet {

    ReservationDBContext reservationDB = new ReservationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int reservationId = Integer.parseInt(request.getParameter("id"));

        reservationDB.cancelReservation(reservationId);

        response.sendRedirect(request.getContextPath()
                + "/librarian/reservation-queue");
    }
}
