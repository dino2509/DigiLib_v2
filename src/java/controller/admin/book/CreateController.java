package controller.admin.book;

import dal.BookDBContext;
import dal.AuthorDBContext;
import dal.CategoryDBContext;
import model.Book;
import model.Author;
import model.Category;
import model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;

@WebServlet(name = "CreateController", urlPatterns = {"/admin/books/add"})
public class CreateController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private AuthorDBContext authorDB = new AuthorDBContext();
    private CategoryDBContext categoryDB = new CategoryDBContext();

    // =========================
    // SHOW CREATE FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Author> authors = authorDB.list();
        ArrayList<Category> categories = categoryDB.list();

        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);

//        request.getRequestDispatcher("../../view/admin/books/add.jsp")
//                .forward(request, response);
        request.setAttribute("pageTitle", "Add Book");
        request.setAttribute("activeMenu", "book");
        request.setAttribute("contentPage", "../../view/admin/books/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);

    }

    // =========================
    // HANDLE CREATE BOOK
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== CHECK LOGIN =====
        Employee emp = (Employee) request.getSession().getAttribute("user");
        if (emp == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Book b = new Book();

        // ===== BASIC INFO =====
        b.setTitle(request.getParameter("title"));
        b.setSummary(request.getParameter("summary"));
        b.setDescription(request.getParameter("description"));
        b.setCoverUrl(request.getParameter("cover_url"));
        b.setContentPath(request.getParameter("content_path"));

        // ===== PRICE =====
        String price = request.getParameter("price");
        if (price != null && !price.isEmpty()) {
            b.setPrice(new BigDecimal(price));
        }

        b.setCurrency(request.getParameter("currency"));
        b.setStatus(request.getParameter("status"));

        // ===== TIME =====
        b.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        // ===== AUTHOR =====
        String authorRaw = request.getParameter("author_id");
        if (authorRaw != null && !authorRaw.isEmpty()) {
            Author a = new Author();
            a.setAuthor_id(Integer.parseInt(authorRaw));
            b.setAuthor(a);
        }

        // ===== CATEGORY =====
        String categoryRaw = request.getParameter("category_id");
        if (categoryRaw != null && !categoryRaw.isEmpty()) {
            Category c = new Category();
            c.setCategory_id(Integer.parseInt(categoryRaw));
            b.setCategory(c);
        }

        // ===== CREATED BY (QUAN TRỌNG NHẤT) =====
        b.setCreate_by(emp);

        bookDB.insert(b);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }
}
