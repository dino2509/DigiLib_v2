package controller.librarian.borrow;

import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;

import java.io.IOException;

@WebServlet("/librarian/request-approve")
public class RequestApproveController extends HttpServlet {

    private BorrowRequestDBContext dao;

    @Override
    public void init() {
        dao = new BorrowRequestDBContext();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Employee emp = (Employee) session.getAttribute("user");
            int employeeId = emp.getEmployeeId();

            String requestIdParam = request.getParameter("requestId");
            String dueDate = request.getParameter("dueDate");
            String note = request.getParameter("note");

            if (requestIdParam == null || dueDate == null || dueDate.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int requestId = Integer.parseInt(requestIdParam);

            dao.approveRequest(requestId, employeeId, dueDate, note);

            response.sendRedirect(request.getContextPath() + "/librarian/requests");

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}