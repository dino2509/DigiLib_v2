package controller.reader;

import dal.BookCopyDBContext;
import dal.BorrowDBContext;
import dal.BorrowRequestDBContext;
import dal.ReservationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;

/**
 * POST /reader/reserve-or-borrow
 *
 * - Nếu còn copy AVAILABLE => tạo Borrow_Request (PENDING)
 * - Nếu hết copy => tạo Reservation_Request (WAITING)
 *
 * Nút bấm ở /books/detail?id=... sẽ mở confirm modal rồi submit vào đây.
 */
@WebServlet(urlPatterns = "/reader/reserve-or-borrow")
public class ReserveOrBorrowController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        int bookId = parseInt(req.getParameter("bookId"), -1);
        if (bookId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        // Các ràng buộc giống flow mượn
        BorrowDBContext borrowDAO = new BorrowDBContext();

        if (borrowDAO.countOverdueBorrowedItems(reader.getReaderId()) > 0) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&hasOverdue=1");
            return;
        }

        if (borrowDAO.countActiveBorrowedItems(reader.getReaderId()) >= 3) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&reachBorrowLimit=1");
            return;
        }

        if (borrowDAO.isBookCurrentlyBorrowed(reader.getReaderId(), bookId)) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&alreadyBorrowing=1");
            return;
        }

        // Check tồn kho
        BookCopyDBContext copyDAO = new BookCopyDBContext();
        int availableCopies = copyDAO.countAvailableByBookId(bookId);

        if (availableCopies > 0) {
            // ✅ Tạo Borrow Request ngay
            BorrowRequestDBContext brDAO = new BorrowRequestDBContext();

            if (brDAO.hasPendingForBook(reader.getReaderId(), bookId)) {
                resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowRequested=1");
                return;
            }

            Integer requestId = brDAO.createSingleBookRequest(reader.getReaderId(), bookId);
            if (requestId == null) {
                resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowError=1");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowRequested=1");
            return;
        }

        // ✅ Hết copy => tạo Reservation WAITING
        ReservationDBContext resDao = new ReservationDBContext();
        Integer rid = resDao.createWaiting(reader.getReaderId(), bookId);

        if (rid == null) {
            // đã có WAITING hoặc lỗi
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&reserveExists=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&reserved=1");
    }

    private Reader requireReader(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (Reader) session.getAttribute("user");
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }
}