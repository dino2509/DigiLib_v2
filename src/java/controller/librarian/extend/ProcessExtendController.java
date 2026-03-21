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
import service.EmailService;
import util.EmailTemplate;

@WebServlet("/librarian/process-extend")
public class ProcessExtendController extends HttpServlet {

    private BorrowExtendDBContext dao = new BorrowExtendDBContext();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int extendId = Integer.parseInt(request.getParameter("extendId"));
        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        Employee emp = (Employee) session.getAttribute("user");

        BorrowExtend extend = dao.getExtendById(extendId);

        if (extend == null) {
            response.sendError(404);
            return;
        }

        if ("approve".equals(action)) {

            dao.approveExtend(extendId, emp.getEmployeeId());

            String html = EmailTemplate.extendApproved(
                    extend.getBookTitle(),
                    extend.getIsbn(),
                    extend.getRequestedDueDate()
            );

            EmailService.sendAsync(
                    extend.getReaderEmail(),
                    "Extend Approved",
                    html
            );

        } else if ("reject".equals(action)) {

            String note = request.getParameter("note");

            // ===== VALIDATE BACKEND =====
            if (note == null || note.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Reject reason is required!");
                response.sendRedirect(request.getContextPath() + "/librarian/borrow-extend");
                return;
            }

            if (note.trim().length() < 5) {
                request.getSession().setAttribute("error", "Reason must be at least 5 characters!");
                response.sendRedirect(request.getContextPath() + "/librarian/borrow-extend");
                return;
            }

            // ===== UPDATE DB =====
            dao.rejectExtend(extendId, emp.getEmployeeId(), note);

            // ===== EMAIL =====
            String html = EmailTemplate.extendRejected(
                    extend.getBookTitle(),
                    extend.getIsbn(),
                    note
            );

            EmailService.sendAsync(
                    extend.getReaderEmail(),
                    "Extend Rejected",
                    html
            );
        }
        response.sendRedirect(request.getContextPath() + "/librarian/borrow-extend");
    }
}
