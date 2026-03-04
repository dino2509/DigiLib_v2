package controller.guest;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/advanced-search")
public class AdvancedSearchController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LẤY PARAM =====
        String field1 = request.getParameter("field1");
        String field2 = request.getParameter("field2");
        String field3 = request.getParameter("field3");
        String field4 = request.getParameter("field4");

        String keyword1 = request.getParameter("keyword1");
        String keyword2 = request.getParameter("keyword2");
        String keyword3 = request.getParameter("keyword3");
        String keyword4 = request.getParameter("keyword4");

        String logic1 = request.getParameter("logic1");
        String logic2 = request.getParameter("logic2");
        String logic3 = request.getParameter("logic3");

        // ===== SEARCH =====
        ArrayList<Book> books = bookDB.advancedSearch(
                field1, keyword1,
                logic1,
                field2, keyword2,
                logic2,
                field3, keyword3,
                logic3,
                field4, keyword4
        );

        // ===== SET ATTRIBUTE =====
        request.setAttribute("books", books);

        request.setAttribute("pageTitle", "Advanced Search Result");
        request.setAttribute("contentPage", "/view/guest/advanced-search-result.jsp");

        request.getRequestDispatcher("/include/guest/layout.jsp")
                .forward(request, response);
    }

}
