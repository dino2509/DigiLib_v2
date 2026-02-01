package controller.admin;

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
import model.Employee;

@WebServlet(name = "UpdateController", urlPatterns = {"/admin/books/edit"})
public class UpdateController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private AuthorDBContext authorDB = new AuthorDBContext();
    private CategoryDBContext categoryDB = new CategoryDBContext();

    // =========================
    // SHOW EDIT FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("id"));

        Book book = bookDB.get(bookId);
        ArrayList<Author> authors = authorDB.list();
        ArrayList<Category> categories = categoryDB.list();

        request.setAttribute("book", book);
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);

        request.setAttribute("pageTitle", "Update Book");
        request.setAttribute("activeMenu", "book");
        request.setAttribute("contentPage", "../../view/admin/books/edit.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    // =========================
    // HANDLE UPDATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Employee emp = (Employee) request.getSession().getAttribute("user");
        if (emp == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Book b = new Book();

        b.setBookId(Integer.parseInt(request.getParameter("book_id")));
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
        b.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

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

        b.setUpdate_by(emp);

        bookDB.update(b);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }
}
