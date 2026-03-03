package controller.reader;

import dal.BookDBContext;
import dal.BorrowDBContext;
import dal.BorrowRequestDBContext;
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
import model.BorrowRequest;
import model.BorrowRequestItem;
import model.Reader;

@WebServlet(urlPatterns = "/reader/home")
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Object user = (session == null) ? null : session.getAttribute("user");
        if (!(user instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) user;

        // ===== DAO =====
        BorrowDBContext borrowDAO = new BorrowDBContext();
        ReadingHistoryDBContext historyDAO = new ReadingHistoryDBContext();
        BorrowRequestDBContext requestDAO = new BorrowRequestDBContext();
        BookDBContext bookDAO = new BookDBContext();

        // ===== Stats =====
        int borrowedCount = borrowDAO.countActiveBorrowedItems(reader.getReaderId());
        int dueSoonCount = borrowDAO.countDueSoon(reader.getReaderId(), 3);
        int totalRead = historyDAO.countDistinctBooksRead(reader.getReaderId());

        int overdueCount = borrowDAO.countOverdueBorrowedItems(reader.getReaderId());
        int totalBorrowedItems = borrowDAO.countAllBorrowedItems(reader.getReaderId());

        // ✅ FIX: thay vì gọi countPendingRequestedItemsByReader / countRequestedItemsByReader (không tồn tại),
        // ta tính dựa trên listWithItemsByReaderAndStatus(...) đã có trong BorrowRequestDBContext
        List<BorrowRequest> pendingRequests = requestDAO.listWithItemsByReaderAndStatus(reader.getReaderId(), "pending", 200);
        List<BorrowRequest> allRequests = requestDAO.listWithItemsByReaderAndStatus(reader.getReaderId(), "all", 200);

        int pendingRequestedCount = sumRequestedItems(pendingRequests);
        int totalRequestedCount = sumRequestedItems(allRequests);

        // ===== Recent borrow requests (history) =====
        // FIX: dùng method chữ thường (đúng theo convention và dễ đồng bộ)
        List<BorrowRequest> recentRequests = requestDAO.listRecentWithItemsByReader(reader.getReaderId(), 5);

        // ===== Recommended =====
        List<Book> recommended = bookDAO.listAll();
        if (recommended != null && recommended.size() > 8) {
            recommended = recommended.subList(0, 8);
        }

        // ===== Set attributes =====
        req.setAttribute("borrowedCount", borrowedCount);
        req.setAttribute("dueSoonCount", dueSoonCount);
        req.setAttribute("totalRead", totalRead);

        req.setAttribute("overdueCount", overdueCount);
        req.setAttribute("totalBorrowedItems", totalBorrowedItems);

        req.setAttribute("pendingRequestedCount", pendingRequestedCount);
        req.setAttribute("totalRequestedCount", totalRequestedCount);

        req.setAttribute("recentRequests", recentRequests);
        req.setAttribute("recommended", recommended);

        req.getRequestDispatcher("/view/reader/home.jsp").forward(req, resp);
    }

    private int sumRequestedItems(List<BorrowRequest> requests) {
        int sum = 0;
        if (requests == null) return 0;
        for (BorrowRequest r : requests) {
            if (r == null || r.getItems() == null) continue;
            for (BorrowRequestItem it : r.getItems()) {
                if (it == null) continue;
                sum += Math.max(0, it.getQuantity());
            }
        }
        return sum;
    }
}