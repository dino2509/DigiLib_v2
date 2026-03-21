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
        String keyword = req.getParameter("keyword");

        if (keyword != null) {
            keyword = keyword.trim();

            // bỏ khoảng trắng dư (nhiều space → 1 space)
            keyword = keyword.replaceAll("\\s+", " ");

            // giới hạn độ dài (tránh spam / lỗi query)
            if (keyword.length() > 100) {
                keyword = keyword.substring(0, 100);
            }

            // nếu rỗng sau trim → set null
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        // ===== FILTER =====
        Integer authorId = null;
        Integer categoryId = null;

        String isbnRaw = req.getParameter("isbn");
        Integer isbn = null;

        if (isbnRaw != null && !isbnRaw.trim().isEmpty()) {
            try {
                isbn = Integer.parseInt(isbnRaw.trim());
            } catch (NumberFormatException e) {
                System.out.println("Invalid ISBN input: " + isbnRaw);
            }
        }

        try {

            if (req.getParameter("author_id") != null && !req.getParameter("author_id").isEmpty()) {
                authorId = Integer.parseInt(req.getParameter("author_id"));
            }

            if (req.getParameter("category_id") != null && !req.getParameter("category_id").isEmpty()) {
                categoryId = Integer.parseInt(req.getParameter("category_id"));
            }
        } catch (Exception ignored) {
        }

        String status = req.getParameter("status");

        // ===== PAGING =====
        int pageSize = 10;
        int pageIndex = 1;

        try {
            pageIndex = Integer.parseInt(req.getParameter("page"));
        } catch (Exception ignored) {
        }

        // ===== DATA =====
        int totalRecords = bookDB.countSearch(keyword, isbn, authorId, categoryId, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        ArrayList<Book> books = bookDB.searchPaging(
                keyword, isbn, authorId, categoryId, status, pageIndex, pageSize
        );

        // ===== FILTER DATA =====
        CategoryDBContext cateDB = new CategoryDBContext();
        AuthorDBContext authDB = new AuthorDBContext();

        req.setAttribute("categories", cateDB.list());
        req.setAttribute("authors", authDB.list());

        // ===== DATA =====
        req.setAttribute("books", books);

        req.setAttribute("keyword", keyword);
        req.setAttribute("isbn", isbn);
        req.setAttribute("authorId", authorId);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("status", status);

        req.setAttribute("pageIndex", pageIndex);
        req.setAttribute("totalPages", totalPages);

        // ===== LAYOUT =====
        req.setAttribute("pageTitle", "Book Management");
        req.setAttribute("activeMenu", "book");
        req.setAttribute("contentPage", "../../view/admin/books/list.jsp");

        req.getRequestDispatcher("/include/admin/layout.jsp").forward(req, resp);
    }
}
