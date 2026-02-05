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

        request.setCharacterEncoding("UTF-8");

        ArrayList<String> errors = new ArrayList<>();

        // ======================
        // GET PARAMS
        // ======================
        int bookId = Integer.parseInt(request.getParameter("book_id"));
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String description = request.getParameter("description");
        String coverUrl = request.getParameter("cover_url");
        String contentPath = request.getParameter("content_path");
        String priceStr = request.getParameter("price");
        String currency = request.getParameter("currency");
        String status = request.getParameter("status");

        // ======================
        // VALIDATE
        // ======================
        if (title == null || title.trim().length() < 3) {
            errors.add("Title phải có ít nhất 3 ký tự");
        }

//        if (summary == null || summary.trim().isEmpty()) {
//            errors.add("Summary không được để trống");
//        }
//
//        if (description == null || description.trim().isEmpty()) {
//            errors.add("Description không được để trống");
//        }

        BigDecimal price = null;
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) < 0) {
                    errors.add("Price không được nhỏ hơn 0");
                }
            } catch (NumberFormatException e) {
                errors.add("Price không hợp lệ");
            }
        }

        if (currency != null && !currency.matches("VND|USD")) {
            errors.add("Currency không hợp lệ");
        }

//        if (status == null || !status.matches("Active|Inactive")) {
//            errors.add("Status không hợp lệ");
//        }

//        if (coverUrl != null && !coverUrl.trim().isEmpty()) {
//            if (!coverUrl.matches("^(http|https)://.*$")) {
//                errors.add("Cover URL không hợp lệ");
//            }
//        }

//        if (contentPath != null && contentPath.contains("..")) {
//            errors.add("Content path không hợp lệ");
//        }

        int authorId = Integer.parseInt(request.getParameter("author_id"));
        if (authorDB.get(authorId) == null) {
            errors.add("Author không tồn tại");
        }

        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        if (categoryDB.get(categoryId) == null) {
            errors.add("Category không tồn tại");
        }

        // ======================
        // IF ERROR → BACK TO FORM
        // ======================
        if (!errors.isEmpty()) {
            Book book = bookDB.get(bookId);

            request.setAttribute("errors", errors);
            request.setAttribute("book", book);
            request.setAttribute("authors", authorDB.list());
            request.setAttribute("categories", categoryDB.list());

            request.setAttribute("pageTitle", "Update Book");
            request.setAttribute("activeMenu", "book");
            request.setAttribute("contentPage", "../../view/admin/books/edit.jsp");

            request.getRequestDispatcher("/include/admin/layout.jsp")
                    .forward(request, response);
            return;
        }

        // ======================
        // UPDATE
        // ======================
        Book b = new Book();
        b.setBookId(bookId);
        b.setTitle(title);
        b.setSummary(summary);
        b.setDescription(description);
        b.setCoverUrl(coverUrl);
        b.setContentPath(contentPath);
        b.setPrice(price);
        b.setCurrency(currency);
        b.setStatus(status);
        b.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

        Author a = new Author();
        a.setAuthor_id(authorId);
        b.setAuthor(a);

        Category c = new Category();
        c.setCategory_id(categoryId);
        b.setCategory(c);

        b.setUpdate_by(emp);

        bookDB.update(b);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

}
