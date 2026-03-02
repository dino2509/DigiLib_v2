package controller.reader;

import dal.BookCopyDBContext;
import dal.BookDBContext;
import dal.BorrowDBContext;
import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Book;
import model.Reader;

/**
 * Flow mới:
 * - GET  /reader/borrow/request?bookId=... : trang xác nhận tạo request mượn (hiển thị info + hạn mặc định 14 ngày)
 * - POST /reader/borrow/request            : bấm xác nhận -> tạo Borrow_Request (PENDING)
 */
@WebServlet(urlPatterns = "/reader/borrow/request")
public class BorrowRequestCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        int bookId = parseInt(req.getParameter("bookId"), -1);
        if (bookId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        BookDBContext bookDAO = new BookDBContext();
        Book book = bookDAO.get(bookId);
        if (book == null) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

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

        BookCopyDBContext copyDAO = new BookCopyDBContext();
        int availableCopies = copyDAO.countAvailableByBookId(bookId);
        if (availableCopies <= 0) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&outOfStock=1");
            return;
        }

        BorrowRequestDBContext brDAO = new BorrowRequestDBContext();
        if (brDAO.hasPendingForBook(reader.getReaderId(), bookId)) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowRequested=1");
            return;
        }

        req.setAttribute("book", book);
        req.setAttribute("availableCopies", availableCopies);
        req.setAttribute("defaultBorrowDays", 14);
        req.setAttribute("finePerDay", 5000);
        req.getRequestDispatcher("/view/reader/borrow_request_create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        int bookId = parseInt(req.getParameter("bookId"), -1);
        if (bookId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/books");
            return;
        }

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

        BookCopyDBContext copyDAO = new BookCopyDBContext();
        int availableCopies = copyDAO.countAvailableByBookId(bookId);
        if (availableCopies <= 0) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&outOfStock=1");
            return;
        }

        BorrowRequestDBContext dao = new BorrowRequestDBContext();
        if (dao.hasPendingForBook(reader.getReaderId(), bookId)) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowRequested=1");
            return;
        }

        // FIX: gọi đúng signature (int, int)
        Integer requestId = dao.createSingleBookRequest(reader.getReaderId(), bookId);
        if (requestId == null) {
            resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowError=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&borrowRequested=1");
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