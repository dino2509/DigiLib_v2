package controller.reader.book;

import dal.BookDBContext;
import dal.BookCopyDBContext;
//import dal.ReviewDBContext;
//import dal.ReadingHistoryDBContext;
import dal.BorrowDBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import model.Book;
import model.Reader;
//import model.Review;

@WebServlet("/reader/book-detail")
public class BookDetailController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private BookCopyDBContext copyDB = new BookCopyDBContext();
//    private ReviewDBContext reviewDB = new ReviewDBContext();
//    private BorrowDBContext borrowDB = new BorrowDBContext();
//    private ReadingHistoryDBContext historyDB = new ReadingHistoryDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("id"));

        Book book = bookDB.get(bookId);

        // Số bản copy còn
        int copiesAvailable = copyDB.getAvailableCopies(bookId);

        // Lấy review
//        List<Review> reviews = reviewDB.getReviewsByBook(bookId);

        // Rating trung bình
//        double avgRating = reviewDB.getAverageRating(bookId);

        // Kiểm tra reader login
        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("reader");

        boolean hasReturned = false;
        boolean hasRead = false;

        if (reader != null) {

//            int readerId = reader.getReaderId();

            // đã trả sách chưa
//            hasReturned = borrowDB.hasReturned(readerId, bookId);

            // đã đọc ebook chưa
//            hasRead = historyDB.hasRead(readerId, bookId);
        }

        request.setAttribute("book", book);
        request.setAttribute("copiesAvailable", copiesAvailable);
//        request.setAttribute("reviews", reviews);
//        request.setAttribute("avgRating", avgRating);
//        request.setAttribute("hasReturned", hasReturned);
//        request.setAttribute("hasRead", hasRead);

        request.setAttribute("pageTitle", book.getTitle());
        request.setAttribute("activeMenu", "books");
        request.setAttribute("contentPage", "/view/book/book-detail.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}