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

        // 🔒 Check login
        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ❗ Validate input
        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        int bookId = Integer.parseInt(idRaw);

        BookDBContext bookDAO = new BookDBContext();

        Book book = bookDAO.get(bookId);

        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/reader/books");
            return;
        }

        // 🔥 CHECK STOCK (QUAN TRỌNG NHẤT)
        int availableCopies = bookDAO.countAvailableCopies(bookId);

        if (availableCopies <= 0) {
            // ❌ Hết sách → quay lại detail + message
            request.getSession().setAttribute("error", "Sách hiện đã hết, không thể mua.");

            response.sendRedirect(request.getContextPath() + "/reader/book-detail?id=" + bookId);
            return;
        }

        // ✅ OK → đi thanh toán
        request.setAttribute("book", book);
        request.setAttribute("totalAmount", book.getPrice());

        request.setAttribute("contentPage", "/view/reader/order/payment-direct.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
