package controller.admin.book;

import dal.BookDBContext;
import dal.AuthorDBContext;
import dal.CategoryDBContext;
import model.Book;
import model.Author;
import model.Category;

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

        request.getRequestDispatcher("../../view/admin/books/add.jsp")
               .forward(request, response);
    }

    // =========================
    // HANDLE CREATE BOOK
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Book b = new Book();

        b.setTitle(request.getParameter("title"));
        b.setSummary(request.getParameter("summary"));
        b.setDescription(request.getParameter("description"));
        b.setCoverUrl(request.getParameter("cover_url"));
        b.setContentPath(request.getParameter("content_path"));

        String price = request.getParameter("price");
        if (price != null && !price.isEmpty()) {
            b.setPrice(new BigDecimal(price));
        }

        b.setCurrency(request.getParameter("currency"));
        b.setStatus(request.getParameter("status"));
        b.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        // Author
        int authorId = Integer.parseInt(request.getParameter("author_id"));
        Author a = new Author();
        a.setAuthor_id(authorId);
        b.setAuthor(a);

        // Category
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        Category c = new Category();
        c.setCategory_id(categoryId);
        b.setCategory(c);

        bookDB.insert(b);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }
}
