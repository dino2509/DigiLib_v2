package controller.reader.book;

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

        String field1 = request.getParameter("field1");
        String field2 = request.getParameter("field2");
        String field3 = request.getParameter("field3");

        String keyword1 = normalizeKeyword(request.getParameter("keyword1"));
        String keyword2 = normalizeKeyword(request.getParameter("keyword2"));
        String keyword3 = normalizeKeyword(request.getParameter("keyword3"));

        String logic1 = request.getParameter("logic1");
        String logic2 = request.getParameter("logic2");

        Double priceMin = null;
        Double priceMax = null;
//        if (logic1 == null || logic1.isEmpty()) {
//            logic1 = "AND";
//        }
//
//        if (logic2 == null || logic2.isEmpty()) {
//            logic2 = "AND";
//        }
        try {
            String min = request.getParameter("priceMin");
            if (min != null && !min.isEmpty()) {
                priceMin = Double.parseDouble(min);
                if (priceMin < 0) {
                    priceMin = null;
                }
            }
        } catch (Exception ignored) {
        }

        try {
            String max = request.getParameter("priceMax");
            if (max != null && !max.isEmpty()) {
                priceMax = Double.parseDouble(max);
                if (priceMax < 0) {
                    priceMax = null;
                }
            }
        } catch (Exception ignored) {
        }

        if (priceMin != null && priceMax != null && priceMin > priceMax) {
            double temp = priceMin;
            priceMin = priceMax;
            priceMax = temp;
        }

        boolean freeOnly = "1".equals(request.getParameter("freeOnly"));

        int page = 1;
        int pageSize = 10;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }

        ArrayList<Book> books = bookDB.advancedSearchPaging(
                field1, keyword1,
                logic1,
                field2, keyword2,
                logic2,
                field3, keyword3,
                priceMin, priceMax,
                freeOnly,
                page, pageSize
        );

        int totalBooks = bookDB.countAdvancedSearch(
                field1, keyword1,
                logic1,
                field2, keyword2,
                logic2,
                field3, keyword3,
                priceMin, priceMax,
                freeOnly
        );

        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // giữ lại filter
        request.setAttribute("field1", field1);
        request.setAttribute("field2", field2);
        request.setAttribute("field3", field3);

        request.setAttribute("keyword1", keyword1);
        request.setAttribute("keyword2", keyword2);
        request.setAttribute("keyword3", keyword3);

        request.setAttribute("logic1", logic1);
        request.setAttribute("logic2", logic2);

        request.setAttribute("priceMin", priceMin);
        request.setAttribute("priceMax", priceMax);

        request.setAttribute("freeOnly", freeOnly);

        request.setAttribute("activeMenu", "search");
        request.setAttribute("pageTitle", "Advanced Search");
        request.setAttribute("contentPage", "/view/reader/book/advanced-search-result.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
