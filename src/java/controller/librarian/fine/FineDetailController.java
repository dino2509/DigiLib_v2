package controller.librarian.fine;

import dal.FineDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Fine;

import java.io.IOException;

@WebServlet("/librarian/fine-detail")
public class FineDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect("fines");
            return;
        }

        int id;
                   

        try {
            id = Integer.parseInt(idRaw);
        } catch (Exception e) {
            response.sendRedirect("fines");
            return;
        }

        FineDBContext fineDAO = new FineDBContext();
        Fine fine = fineDAO.getFineById(id);

        if (fine == null) {
            response.sendRedirect("fines");
            return;
        }

        request.setAttribute("fine", fine);

        // layout
        request.setAttribute("contentPage", "/view/librarian/fine/detail.jsp");
        request.setAttribute("activeMenu", "fines");
        request.setAttribute("pageTitle", "Fine Detail");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
