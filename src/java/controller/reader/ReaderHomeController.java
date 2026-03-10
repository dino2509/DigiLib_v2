package controller.reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

import dal.BookDBContext;
import dal.BorrowDBContext;
import dal.ReadingHistoryDBContext;
import model.Book;
import model.Reader;
import model.ReadingProgress;

@WebServlet("/reader/home")
public class ReaderHomeController extends HttpServlet {

    private final BorrowDBContext borrowDB = new BorrowDBContext();
    private final ReadingHistoryDBContext readingHistoryDB = new ReadingHistoryDBContext();
    private final BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object sessionUser = (session == null) ? null : session.getAttribute("user");
        if (!(sessionUser instanceof Reader)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) sessionUser;
        request.setAttribute("user", reader);

        int borrowedCount = borrowDB.countActiveBorrowed(reader.getReaderId());
        int dueSoonCount = borrowDB.countDueSoon(reader.getReaderId(), 3);
        int readTotal = readingHistoryDB.countDistinctBooksRead(reader.getReaderId());

        request.setAttribute("borrowedCount", borrowedCount);
        request.setAttribute("dueSoonCount", dueSoonCount);
        request.setAttribute("readTotal", readTotal);

        ArrayList<ReadingProgress> continueReading = readingHistoryDB.listByReader(reader.getReaderId(), 4);
        request.setAttribute("continueReading", continueReading);

        ArrayList<Book> recommended = bookDB.topRated(8);
        request.setAttribute("recommendedBooks", recommended);

        request.getRequestDispatcher("/view/reader/home.jsp").forward(request, response);
    }
}
