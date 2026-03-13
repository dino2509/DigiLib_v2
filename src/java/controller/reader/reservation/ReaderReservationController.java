package controller.reader;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Reader;
import model.Reservation;

import java.io.IOException;
import java.util.List;

@WebServlet("/reader/reservations")
public class ReaderReservationController extends HttpServlet {

    private ReservationDBContext dao = new ReservationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();
            Reader reader = (Reader) session.getAttribute("user");

            int readerId = reader.getReaderId();

            List<Reservation> reservations
                    = dao.getReservationsByReader(readerId);

            request.setAttribute("reservations", reservations);

            request.setAttribute("pageTitle", "My Reservations");
            request.setAttribute("contentPage", "/view/reader/reservation/reservations.jsp");

            request.getRequestDispatcher("/include/reader/layout.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
