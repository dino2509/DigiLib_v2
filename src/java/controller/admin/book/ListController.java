package controller.admin.book;

import dal.AuthorDBContext;
import dal.CategoryDBContext;
import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Author;
import model.Category;
import model.Book;

@WebServlet(urlPatterns = "/admin/books/list")
public class ListController extends HttpServlet {

    private final BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ===== FILTER PARAMS =====
        String keyword = req.getParameter("keyword");
        
        String keyResult = null;

        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
            if (!keyword.isEmpty()) {
                keyResult = keyword;
            }
        }
        Integer authorId = null;
        Integer categoryId = null;

        try {
            String a = req.getParameter("author_id");
            if (a != null && !a.isEmpty()) {
                authorId = Integer.parseInt(a);
            }

            String c = req.getParameter("category_id");
            if (c != null && !c.isEmpty()) {
                categoryId = Integer.parseInt(c);
            }
           
        } catch (Exception e) {
            // ignore parse error
        }
         String status = req.getParameter("status");
        // ===== PAGING =====
        int pageSize = 10;
        int pageIndex = 1;

        String pageRaw = req.getParameter("page");
        if (pageRaw != null) {
            try {
                pageIndex = Integer.parseInt(pageRaw);
            } catch (Exception e) {
                pageIndex = 1;
            }
        }

        // ===== DATA =====
        int totalRecords = bookDB.countSearch(keyResult, authorId, categoryId, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        ArrayList<Book> books = bookDB.searchPaging(keyResult, authorId, categoryId, status, pageIndex, pageSize);
               

        // ===== LOAD FILTER DATA =====
        CategoryDBContext cateDB = new CategoryDBContext();
        AuthorDBContext authDB = new AuthorDBContext();

        ArrayList<Category> categories = cateDB.list();
        ArrayList<Author> authors = authDB.list();

        // ===== SET ATTRIBUTES =====
        req.setAttribute("books", books);

        req.setAttribute("categories", categories);
        req.setAttribute("authors", authors);

        req.setAttribute("keyword", keyword);
        req.setAttribute("authorId", authorId);
        req.setAttribute("categoryId", categoryId);

        req.setAttribute("pageIndex", pageIndex);
        req.setAttribute("totalPages", totalPages);

        // ===== LAYOUT =====
        req.setAttribute("pageTitle", "Book Management");
        req.setAttribute("activeMenu", "book");
        req.setAttribute("contentPage", "../../view/admin/books/list.jsp");

        req.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}