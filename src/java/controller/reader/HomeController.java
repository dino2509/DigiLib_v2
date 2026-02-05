package controller.reader;

import dal.BookDBContext;
import dal.BorrowDBContext;
import dal.ReadingHistoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Book;
import model.Reader;
import model.ReadingHistoryEntry;

@WebServlet(urlPatterns = "/reader/home")
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ===== 1. CHECK LOGIN =====
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");

        // ===== 2. LOAD DATA (bám sát DB) =====
        BookDBContext bookDAO = new BookDBContext();
        BorrowDBContext borrowDAO = new BorrowDBContext();
        ReadingHistoryDBContext historyDAO = new ReadingHistoryDBContext();

        // Continue Reading (Reading_History)
        List<ReadingHistoryEntry> continueReading = historyDAO.listRecentByReader(reader.getReaderId(), 5);

        // Stats
        int borrowedCount = borrowDAO.countActiveBorrowedItems(reader.getReaderId());
        int dueSoonCount = borrowDAO.countDueSoon(reader.getReaderId(), 3);
        int totalRead = historyDAO.countDistinctBooksRead(reader.getReaderId());

        // Recommended (tạm: lấy danh sách sách)
        List<Book> recommended = bookDAO.listAll();
        if (recommended.size() > 8) {
            recommended = recommended.subList(0, 8);
        }

        // ===== 3. SET ATTRIBUTE =====
        req.setAttribute("continueReading", continueReading);
        req.setAttribute("borrowedCount", borrowedCount);
        req.setAttribute("dueSoonCount", dueSoonCount);
        req.setAttribute("totalRead", totalRead);
        req.setAttribute("recommended", recommended);

        // ===== 4. FORWARD JSP =====
        req.getRequestDispatcher("/view/reader/home.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
