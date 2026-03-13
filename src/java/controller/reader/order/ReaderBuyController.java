package controller.reader.order;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Book;
import model.Reader;

@WebServlet("/reader/buy")
public class ReaderBuyController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("id"));

        BookDBContext bookDAO = new BookDBContext();

        Book book = bookDAO.get(bookId);

        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/reader/books");
            return;
        }

        request.setAttribute("book", book);
        request.setAttribute("totalAmount", book.getPrice());

        request.setAttribute("contentPage", "/view/reader/order/payment-direct.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
