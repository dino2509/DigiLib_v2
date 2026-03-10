package controller.librarian;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/librarian/dashboard")
public class DashboardController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("totalBooks", bookDB.countBooks());

        request.setAttribute("contentPage", "/view/librarian/dashboard.jsp");

        request.getRequestDispatcher("../include/librarian/layout.jsp")
                .forward(request, response);
    }
}
