package controller.guest;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(urlPatterns = "/home/search")
public class SearchController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LẤY KEYWORD =====
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        // Tránh null
        if (keyword == null) {
            keyword = "";
        }

        keyword = keyword.trim().replaceAll("\\s+", " ");
        String keyResult = keyword.toLowerCase();

        // ===== SEARCH =====
        ArrayList<Book> books;

        if (!keyword.isEmpty()) {

            books = bookDB.searchAdvanced(keyword, type);

        } else {

            books = bookDB.getFeaturedBooks();

        }

        // ===== SET ATTRIBUTE =====
        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.setAttribute("type", type);
        request.setAttribute("pageTitle", "Search Result");
        request.setAttribute("contentPage", "/view/guest/search.jsp");

        // ===== FORWARD VỀ LAYOUT =====
        request.getRequestDispatcher("/include/guest/layout.jsp")
                .forward(request, response);
    }
}
