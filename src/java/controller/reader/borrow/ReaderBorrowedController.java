package controller.reader;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.BorrowItem;
import model.Reader;

import java.io.IOException;
import java.util.List;

@WebServlet("/reader/borrowed")
public class ReaderBorrowedController extends HttpServlet {

    private BorrowDBContext dao = new BorrowDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();
            Reader reader = (Reader) session.getAttribute("user");

            int readerId = reader.getReaderId();

            List<BorrowItem> borrowedBooks = dao.getBorrowedBooks(readerId);

            request.setAttribute("borrowedBooks", borrowedBooks);

            request.setAttribute("pageTitle", "My Borrowed Books");
            request.setAttribute("activeMenu", "borrowed");
            request.setAttribute("contentPage", "/view/reader/borrow/borrowed.jsp");

            request.getRequestDispatcher("/include/reader/layout.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
