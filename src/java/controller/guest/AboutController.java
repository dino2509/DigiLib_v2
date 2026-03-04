package controller.guest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/about")
public class AboutController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Giới thiệu");
        request.setAttribute("contentPage", "/view/guest/about.jsp");

        request.getRequestDispatcher("/include/guest/layout.jsp")
                .forward(request, response);
    }
}
