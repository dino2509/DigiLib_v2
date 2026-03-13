package controller.librarian;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/librarian/reservations")
public class ReservationsController extends HttpServlet {

    ReservationDBContext reservationDB = new ReservationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("reservations",
                reservationDB.getAllReservations());
request.setAttribute("activeMenu", "reservations");
        request.setAttribute("pageTitle", "Reservations");
        request.setAttribute("contentPage", "/view/librarian/reservation/reservations.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
