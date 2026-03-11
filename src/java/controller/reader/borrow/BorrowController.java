package controller.reader.borrow;

import dal.BookCopyDBContext;
import dal.BorrowRequestDBContext;
import dal.BorrowRequestItemDBContext;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.Reader;

@WebServlet("/reader/borrow")
public class BorrowController extends HttpServlet {

    private BorrowRequestDBContext requestDB = new BorrowRequestDBContext();
    private BorrowRequestItemDBContext itemDB = new BorrowRequestItemDBContext();
    private BookCopyDBContext copyDB = new BookCopyDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int copiesAvailable = copyDB.getAvailableCopies(bookId);

        if (copiesAvailable <= 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/reader/book-detail?id=" + bookId
                    + "&error=out_of_stock");

            return;
        }

        int requestId = requestDB.createBorrowRequest(reader.getReaderId());

        itemDB.addRequestItem(requestId, bookId, 1);

        response.sendRedirect(
                request.getContextPath()
                + "/reader/borrow-requests");

    }

}
