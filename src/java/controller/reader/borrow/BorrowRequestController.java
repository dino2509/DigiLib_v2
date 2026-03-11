package controller.reader.borrow;

import dal.BookDBContext;
import dal.BorrowRequestDBContext;
import dal.BorrowRequestItemDBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import model.Book;
import model.Reader;

@WebServlet("/reader/request")
public class BorrowRequestController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private BorrowRequestDBContext requestDB = new BorrowRequestDBContext();
    private BorrowRequestItemDBContext itemDB = new BorrowRequestItemDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("id"));

        Book book = bookDB.get(bookId);

        request.setAttribute("book", book);

        request.setAttribute("pageTitle", "Borrow Request");
        request.setAttribute("activeMenu", "borrowed");
        request.setAttribute("contentPage", "/view/reader/borrow/request.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String note = request.getParameter("note");

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        requestDB.createBorrowRequest(reader.getReaderId(), note);

        int requestId = requestDB.getLastBorrowRequestId(reader.getReaderId());

        if (requestId != -1) {
            itemDB.addRequestItem(requestId, bookId, quantity);
        }

        response.sendRedirect(request.getContextPath() + "/reader/borrow-requests");
    }
}
