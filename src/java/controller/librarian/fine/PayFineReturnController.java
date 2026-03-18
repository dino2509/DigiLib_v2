package controller.librarian.borrow;

import dal.BorrowDBContext;
import dal.FineDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/librarian/pay-fine-returns")
public class PayFineReturnController extends HttpServlet {
    
    

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int borrowId = Integer.parseInt(request.getParameter("id"));

        FineDBContext fineDAO = new FineDBContext();
        BorrowDBContext borrowDAO = new BorrowDBContext();

        // 1. check overdue
        int overdueDays = borrowDAO.getOverdueDaysByBorrowId(borrowId);

        if (overdueDays <= 0) {
            response.sendRedirect("borrows");
            return;
        }

        // 2. check đã có fine chưa
        Integer fineId = fineDAO.getFineByBorrowId(borrowId);

        if (fineId == null) {

            BigDecimal rate = fineDAO.getOverdueRate(); // 5000
            BigDecimal amount = rate.multiply(BigDecimal.valueOf(overdueDays));

            fineId = fineDAO.createOverdueFine(borrowId, amount, overdueDays);
        }

        // 3. redirect sang payment
        response.sendRedirect("pay-fine-payment?id=" + fineId);
    }
}
