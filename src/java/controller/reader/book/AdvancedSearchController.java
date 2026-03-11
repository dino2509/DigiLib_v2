package controller.reader.book;

import controller.guest.*;
import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/reader/advanced-search")
public class AdvancedSearchController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    // ===== NORMALIZE KEYWORD =====
    private String normalizeKeyword(String keyword) {

        if (keyword == null) {
            return null;
        }

        keyword = keyword.trim().replaceAll("\\s+", " ");

        if (keyword.isEmpty()) {
            return null;
        }

        return keyword;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== GET PARAM =====
        String field1 = request.getParameter("field1");
        String field2 = request.getParameter("field2");
        String field3 = request.getParameter("field3");
        String field4 = request.getParameter("field4");

        String keyword1 = normalizeKeyword(request.getParameter("keyword1"));
        String keyword2 = normalizeKeyword(request.getParameter("keyword2"));
        String keyword3 = normalizeKeyword(request.getParameter("keyword3"));
        String keyword4 = normalizeKeyword(request.getParameter("keyword4"));

        String logic1 = request.getParameter("logic1");
        String logic2 = request.getParameter("logic2");
        String logic3 = request.getParameter("logic3");

        // ===== PAGING =====
        int page = 1;
        int pageSize = 8;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            page = 1;
        }

        // ===== SEARCH =====
        ArrayList<Book> books = bookDB.advancedSearchPaging(
                field1, keyword1,
                logic1,
                field2, keyword2,
                logic2,
                field3, keyword3,
                logic3,
                field4, keyword4,
                page, pageSize
        );

        // ===== COUNT TOTAL =====
        int totalBooks = bookDB.countAdvancedSearch(
                field1, keyword1,
                logic1,
                field2, keyword2,
                logic2,
                field3, keyword3,
                logic3,
                field4, keyword4
        );

        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

        // ===== SET ATTRIBUTE =====
        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // ===== GIỮ LẠI FORM DATA =====
        request.setAttribute("field1", field1);
        request.setAttribute("field2", field2);
        request.setAttribute("field3", field3);
        request.setAttribute("field4", field4);

        request.setAttribute("keyword1", keyword1);
        request.setAttribute("keyword2", keyword2);
        request.setAttribute("keyword3", keyword3);
        request.setAttribute("keyword4", keyword4);

        request.setAttribute("logic1", logic1);
        request.setAttribute("logic2", logic2);
        request.setAttribute("logic3", logic3);

        // ===== VIEW =====
        request.setAttribute("activeMenu","search");
        request.setAttribute("pageTitle", "Advanced Search Result");
        request.setAttribute("contentPage", "/view/reader/book/advanced-search-result.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}