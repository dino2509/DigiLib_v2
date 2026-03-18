package controller.librarian.borrow;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/librarian/return")
public class ReturnBorrowController extends HttpServlet {

    BorrowDBContext dao = new BorrowDBContext();

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int borrowId = Integer.parseInt(request.getParameter("borrowId"));

        dao.returnBorrow(borrowId);

        response.sendRedirect(request.getContextPath()
                + "/librarian/borrows");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
    
}
