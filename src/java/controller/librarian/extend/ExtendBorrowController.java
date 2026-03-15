package controller.librarian.borrow;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/librarian/extend-borrow")
public class ExtendBorrowController extends HttpServlet {

    private BorrowDBContext borrowDB = new BorrowDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int borrowId = Integer.parseInt(request.getParameter("borrowId"));

        request.setAttribute("borrowId", borrowId);

        request.setAttribute("pageTitle", "Extend Borrow");
        request.setAttribute("activeMenu", "borrows");
        request.setAttribute("contentPage",
                "/view/librarian/borrow/extend-borrow.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int borrowId = Integer.parseInt(request.getParameter("borrowId"));
            Date newDueDate = Date.valueOf(request.getParameter("newDueDate"));

            borrowDB.extendBorrowByBorrowId(borrowId, newDueDate);

            response.sendRedirect(
                    request.getContextPath()
                    + "/librarian/borrow-detail?id=" + borrowId
            );

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(500);

        }
    }
}
