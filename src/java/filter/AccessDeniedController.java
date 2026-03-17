package filter;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/access-denied")
public class AccessDeniedController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "message",
                "You do not have permission to access this page."
        );

        request.getRequestDispatcher(
                "/view/notification/access-denied.jsp"
        ).forward(request, response);
    }

}