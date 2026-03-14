package controller.reader;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.borrow.BorrowItem;
import model.Reader;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reader/borrowed")
public class BorrowedController extends HttpServlet {

    private BorrowDBContext dao;

    @Override
    public void init() throws ServletException {
        dao = new BorrowDBContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Reader reader = (Reader) session.getAttribute("user");

        int readerId = reader.getReaderId();

        int page = 1;
        int pageSize = 5;

        String pageParam = request.getParameter("page");

        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        int totalRecords = dao.countBorrowedBooks(readerId);

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        List<BorrowItem> borrowedBooks
                = dao.getBorrowedBooks(readerId, page, pageSize);

        request.setAttribute("borrowedBooks", borrowedBooks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "My Borrowed Books");
        request.setAttribute("activeMenu", "borrowed");
        request.setAttribute("contentPage", "/view/reader/borrow/borrowed.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
