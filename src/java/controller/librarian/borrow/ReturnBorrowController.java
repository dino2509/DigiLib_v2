package controller.librarian.borrow;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/librarian/return")
public class ReturnBorrowController extends HttpServlet {

    BorrowDBContext dao = new BorrowDBContext();

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("borrowId");

        if (idRaw == null || idRaw.isEmpty()) {
            throw new RuntimeException("borrowId is missing");
        }

        int borrowId = Integer.parseInt(idRaw);
        String condition = request.getParameter("condition");
        String fineRaw = request.getParameter("fineAmount");

        if ("DAMAGED".equals(condition)) {

            BigDecimal fine = BigDecimal.ZERO;

            if (fineRaw != null && !fineRaw.isEmpty()) {
                fine = new BigDecimal(fineRaw);
            }

//            dao.createDamageFine(borrowId, fine);
        }

        dao.returnBorrow(borrowId);

        response.sendRedirect(request.getContextPath()
                + "/librarian/borrows");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

}
