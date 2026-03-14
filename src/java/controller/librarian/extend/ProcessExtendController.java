package controller.librarian.extend;

import dal.BorrowDBContext;
import dal.BorrowExtendDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.borrow.Borrow;
import model.borrow.BorrowDetailItem;

import java.io.IOException;
import java.util.List;
import model.Employee;
import model.borrow.BorrowExtend;

@WebServlet("/librarian/process-extend")
public class ProcessExtendController extends HttpServlet {

    private BorrowExtendDBContext dao = new BorrowExtendDBContext();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int extendId = Integer.parseInt(request.getParameter("extendId"));
        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        Employee emp = (Employee) session.getAttribute("user");

        if ("approve".equals(action)) {
            dao.approveExtend(extendId, emp.getEmployeeId());
        } else if ("reject".equals(action)) {
            dao.rejectExtend(extendId, emp.getEmployeeId());
        }

        response.sendRedirect(request.getContextPath() + "/librarian/borrow-extend");
    }
}
