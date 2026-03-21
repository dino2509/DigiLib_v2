package controller.admin;

import dal.BookDBContext;
import dal.AuthorDBContext;
import dal.CategoryDBContext;
import model.Book;
import model.Author;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.ArrayList;
import model.Employee;

@WebServlet(name = "UpdateController", urlPatterns = {"/admin/books/edit"})
@MultipartConfig(
        maxFileSize = 20 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
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

        String imgDir = getServletContext().getRealPath("/img/book");
        File folder = new File(imgDir);

        ArrayList<String> images = new ArrayList<>();
        if (folder.exists() && folder.isDirectory()) {
            for (File f : folder.listFiles()) {
                if (f.isFile()) {
                    String name = f.getName().toLowerCase();
                    if (name.endsWith(".jpg") || name.endsWith(".png")
                            || name.endsWith(".jpeg") || name.endsWith(".webp")) {
                        images.add(f.getName());
                    }
                }
            }
        }

        request.setAttribute("images", images);

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
        String priceStr = request.getParameter("price");
        String currency = request.getParameter("currency");
        String status = request.getParameter("status");

        // ===== ISBN =====
        Integer isbn = null;
        String isbnRaw = request.getParameter("isbn");

        if (isbnRaw != null && !isbnRaw.trim().isEmpty()) {
            if (!isbnRaw.matches("\\d{6,13}")) {
                errors.add("ISBN phải từ 6-13 chữ số");
            } else {
                try {
                    isbn = Integer.parseInt(isbnRaw);
                } catch (Exception e) {
                    errors.add("ISBN không hợp lệ");
                }
            }
        }

        // ======================
        // VALIDATE
        // ======================
        if (title == null || title.trim().length() < 3) {
            errors.add("Title phải có ít nhất 3 ký tự");
        }

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

        int authorId = Integer.parseInt(request.getParameter("author_id"));
        if (authorDB.get(authorId) == null) {
            errors.add("Author không tồn tại");
        }

        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        if (categoryDB.get(categoryId) == null) {
            errors.add("Category không tồn tại");
        }

        // ======================
        // FILE VALIDATION (NEW RULE)
        // ======================
        Part pdfPart = request.getPart("content_upload");
        Part coverPart = request.getPart("cover_upload");

        // ===== PDF 50MB =====
        if (pdfPart != null && pdfPart.getSize() > 0) {

            long MAX_PDF_SIZE = 50 * 1024 * 1024; // ✅ 50MB
            String contentType = pdfPart.getContentType();

            if (pdfPart.getSize() > MAX_PDF_SIZE) {
                errors.add("PDF không được vượt quá 50MB");
            }

            if (contentType == null || !contentType.equals("application/pdf")) {
                errors.add("Chỉ được upload file PDF");
            }

            String name = pdfPart.getSubmittedFileName().toLowerCase();
            if (!name.endsWith(".pdf")) {
                errors.add("File phải có định dạng .pdf");
            }
        }

        // ===== IMAGE 20MB =====
        if (coverPart != null && coverPart.getSize() > 0) {

            long MAX_IMG_SIZE = 20 * 1024 * 1024; // ✅ 20MB
            String contentType = coverPart.getContentType();

            if (coverPart.getSize() > MAX_IMG_SIZE) {
                errors.add("Ảnh không được vượt quá 20MB");
            }

            if (contentType == null || !contentType.startsWith("image/")) {
                errors.add("Chỉ được upload file ảnh");
            }

            String name = coverPart.getSubmittedFileName().toLowerCase();
            if (!(name.endsWith(".jpg") || name.endsWith(".jpeg")
                    || name.endsWith(".png") || name.endsWith(".webp")
                    || name.endsWith(".gif"))) {
                errors.add("Định dạng ảnh không hợp lệ");
            }
        }

        // ======================
        // IF ERROR
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
        // UPDATE OBJECT
        // ======================
        Book b = new Book();
        b.setBookId(bookId);
        b.setTitle(title);
        b.setSummary(summary);
        b.setDescription(description);
        b.setPrice(price);
        b.setCurrency(currency);
        b.setStatus(status);
        b.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        b.setUpdate_by(emp);

        if (isbn != null) {
            b.setIsbn(isbn); // ✅ SET ISBN
        }

        Author a = new Author();
        a.setAuthor_id(authorId);
        b.setAuthor(a);

        Category c = new Category();
        c.setCategory_id(categoryId);
        b.setCategory(c);

        // ======================
        // SAVE PDF
        // ======================
        if (pdfPart != null && pdfPart.getSize() > 0) {

            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\pdf");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String fileName = "book_" + System.currentTimeMillis() + ".pdf";
            pdfPart.write(uploadDir + File.separator + fileName);

            b.setContentPath(fileName);

        } else {
            b.setContentPath(bookDB.get(bookId).getContentPath());
        }

        // ======================
        // SAVE IMAGE
        // ======================
        if (coverPart != null && coverPart.getSize() > 0) {

            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\img\\book");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String original = coverPart.getSubmittedFileName();
            String ext = original.substring(original.lastIndexOf("."));

            String fileName = "book_" + System.currentTimeMillis() + ext;
            coverPart.write(uploadDir + File.separator + fileName);

            b.setCoverUrl(fileName);

        } else {
            b.setCoverUrl(bookDB.get(bookId).getCoverUrl());
        }

        // ======================
        // UPDATE DB
        // ======================
        bookDB.update(b);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void loadFormAgain(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("book_id"));
        Book book = bookDB.get(bookId);

        request.setAttribute("book", book);
        request.setAttribute("authors", authorDB.list());
        request.setAttribute("categories", categoryDB.list());

        request.setAttribute("pageTitle", "Update Book");
        request.setAttribute("activeMenu", "book");
        request.setAttribute("contentPage", "../../view/admin/books/edit.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}
