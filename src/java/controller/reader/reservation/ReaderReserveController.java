package controller.reader.reservation;

import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Reader;

import java.io.IOException;

@WebServlet("/reader/reserve")
public class ReaderReserveController extends HttpServlet {

    ReservationDBContext reservationDB = new ReservationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookId = request.getParameter("id");
        request.setAttribute("bookId", bookId);
        request.setAttribute("activeMenu", "reservations");
        request.setAttribute("pageTitle", "Reserve Book");
        request.setAttribute("contentPage", "/view/reader/reservation/reserve.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        int readerId = reader.getReaderId();
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        reservationDB.createReservation(readerId, bookId, quantity);

        response.sendRedirect(request.getContextPath() + "/reader/reservations");
    }
}
