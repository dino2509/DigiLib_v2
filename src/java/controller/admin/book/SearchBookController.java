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

@WebServlet(name = "SearchBookController", urlPatterns = {"/admin/books/search"})
public class SearchBookController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private AuthorDBContext authorDB = new AuthorDBContext();
    private CategoryDBContext categoryDB = new CategoryDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LẤY THAM SỐ SEARCH =====
        String keyword = request.getParameter("keyword");
        String authorRaw = request.getParameter("author_id");
        String categoryRaw = request.getParameter("category_id");
        String status = request.getParameter("status");

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

        // ===== SEARCH BOOK =====
        ArrayList<Book> books = bookDB.search(
                keyword,
                authorId,
                categoryId,
                status
        );

        // ===== LOAD DATA CHO FILTER =====
        ArrayList<Author> authors = authorDB.list();
        ArrayList<Category> categories = categoryDB.list();

        // ===== SET ATTRIBUTE =====
        request.setAttribute("books", books);
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);

        request.setAttribute("keyword", keyword);
        request.setAttribute("authorId", authorId);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("status", status);

        // ===== FORWARD =====
        

        request.getRequestDispatcher("list")
                .forward(request, response);

    }
}
