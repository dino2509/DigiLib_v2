package controller.admin.book;

import dal.BookDBContext;
import dal.AuthorDBContext;
import dal.CategoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;
import model.Author;
import model.Category;

import java.io.IOException;
import java.util.ArrayList;

/// khong dung
@WebServlet(name = "SearchBookController", urlPatterns = {"/admin/books/search"})
public class SearchBookController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private AuthorDBContext authorDB = new AuthorDBContext();
    private CategoryDBContext categoryDB = new CategoryDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String keyResult = null;

        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
            if (!keyword.isEmpty()) {
                keyResult = keyword;
            }
        }

        String authorRaw = request.getParameter("author_id");
        String categoryRaw = request.getParameter("category_id");
        String status = request.getParameter("status");

        if (status != null && status.trim().isEmpty()) {
            status = null;
        }

        Integer authorId = null;
        Integer categoryId = null;

        try {
            if (authorRaw != null && !authorRaw.isEmpty()) {
                authorId = Integer.parseInt(authorRaw);
            }
            if (categoryRaw != null && !categoryRaw.isEmpty()) {
                categoryId = Integer.parseInt(categoryRaw);
            }
        } catch (NumberFormatException e) {
            // ignore
        }

        ArrayList<Book> books = bookDB.search(
                keyResult,
                authorId,
                categoryId,
                status
        );

        request.setAttribute("books", books);
        request.setAttribute("authors", authorDB.list());
        request.setAttribute("categories", categoryDB.list());

        request.setAttribute("keyword", keyword);
        request.setAttribute("authorId", authorId);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("status", status);

        
        
        
        
        
        request.setAttribute("pageTitle", "Search Book");
        request.setAttribute("activeMenu", "book");
        request.setAttribute("contentPage", "../../view/admin/books/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

}
