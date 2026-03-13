package controller.librarian.borrow;

import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;

import java.io.IOException;

@WebServlet("/librarian/request-reject")
public class RequestRejectController extends HttpServlet {

    private BorrowRequestDBContext dao = new BorrowRequestDBContext();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String note = request.getParameter("note");

            HttpSession session = request.getSession();
            Employee emp = (Employee) session.getAttribute("user");

            int employeeId = emp.getEmployeeId();

            dao.rejectRequest(requestId, employeeId, note);

            response.sendRedirect(
                    request.getContextPath() + "/librarian/requests"
            );

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}