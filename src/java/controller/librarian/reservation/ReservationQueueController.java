package controller.librarian.reservation;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/librarian/reservation-queue")
public class ReservationQueueController extends HttpServlet {

    ReservationDBContext reservationDB = new ReservationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("queue",
                reservationDB.getReservationQueue());
        request.setAttribute("activeMenu", "reservations-queue");
        request.setAttribute("pageTitle", "Reservation Queue");
        request.setAttribute("contentPage",
                "/view/librarian/reservation/reservation-queue.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
