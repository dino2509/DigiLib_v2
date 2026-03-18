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

            int page = 1;
            int pageSize = 10;

            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {
            }

            if (page < 1) {
                page = 1;
            }

            int totalRecords = dao.countByReader(readerId);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            if (totalPages == 0) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            List<Reservation> reservations
                    = dao.getReservationsByReaderPaging(readerId, page, pageSize);

            request.setAttribute("reservations", reservations);
            request.setAttribute("page", page);
            request.setAttribute("totalPages", totalPages);

            request.setAttribute("reservations", reservations);
            request.setAttribute("activeMenu", "reservations");
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
