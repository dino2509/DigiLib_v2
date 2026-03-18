package controller.librarian.reservation;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/librarian/reservations")
public class ReservationsController extends HttpServlet {

    private ReservationDBContext reservationDB = new ReservationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int page = 1;
            int pageSize = 5;

            String pageParam = request.getParameter("page");
            String search = request.getParameter("search");
            String status = request.getParameter("status");

            if (search == null) {
                search = "";
            }
            if (status == null) {
                status = "";
            }

            search = search.trim();

            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            }

            int totalRecords = reservationDB.countReservations(search, status);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            if (totalPages == 0) {
                totalPages = 1;
            }

            if (page > totalPages) {
                page = totalPages;
            }

            request.setAttribute("reservations",
                    reservationDB.getReservations(search, status, page, pageSize));

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.setAttribute("search", search);
            request.setAttribute("status", status);

            request.setAttribute("activeMenu", "reservations");
            request.setAttribute("pageTitle", "Reservations");
            request.setAttribute("contentPage",
                    "/view/librarian/reservation/reservations.jsp");

            request.getRequestDispatcher("/include/librarian/layout.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }

    }
}
