package controller.guest;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/home/search")
public class SearchController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");

        if (keyword == null) {
            keyword = "";
        }
        if (type == null) {
            type = "all";
        }
        
        
        String keyResult = "";
        keyword = keyword.trim();
        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
            if (!keyword.isEmpty()) {
                keyResult = keyword;
            }
        }
        int page = 1;
        int pageSize = 8;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            page = 1;
        }

        ArrayList<Book> books;
        int totalBooks;

        if (!keyResult.isEmpty()) {

            books = bookDB.searchAdvancedPaging(keyResult, type, page, pageSize);
            totalBooks = bookDB.countSearchAdvanced(keyResult, type);

        } else {

            books = bookDB.getBooksPaging(page, pageSize);
            totalBooks = bookDB.countBooks();
        }

        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.setAttribute("type", type);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "Search Result");
        request.setAttribute("contentPage", "/view/guest/search.jsp");

        request.getRequestDispatcher("/include/guest/layout.jsp")
                .forward(request, response);
    }
}
