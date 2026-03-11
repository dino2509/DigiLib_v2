package controller.reader.book;

import controller.guest.*;
import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/reader/books")
public class BooksController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        int page = 1;
        int pageSize = 8;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (Exception e) {
            page = 1;
        }

        ArrayList<Book> books;
        int totalBooks;

        if (keyword != null && !keyword.trim().isEmpty()) {

            books = bookDB.searchByKeywordPaging(keyword, page, pageSize);
            totalBooks = bookDB.countSearchBooks(keyword);

        } else {

            books = bookDB.getBooksPaging(page, pageSize);
            totalBooks = bookDB.countBooks();

        }

        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        
        request.setAttribute("activeMenu","books");
        request.setAttribute("pageTitle", "Books");
        request.setAttribute("contentPage", "/view/reader/book/books.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
