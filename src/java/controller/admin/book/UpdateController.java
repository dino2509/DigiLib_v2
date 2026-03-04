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
        String coverUrl = request.getParameter("cover_url");
//        String contentPath = request.getParameter("content_path");
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

//      
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
//        b.setContentPath(contentPath);
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

        // =========================
// UPLOAD PDF FILE
// =========================
        Part pdfPart = request.getPart("content_upload");

        if (pdfPart != null && pdfPart.getSize() > 0) {

            String contentType = pdfPart.getContentType();
            long MAX_PDF_SIZE = 20 * 1024 * 1024;

            // 1️⃣ Check dung lượng
            if (pdfPart.getSize() > MAX_PDF_SIZE) {
                errors.add("PDF không được vượt quá 20MB");
            }

            // 2️⃣ Check MIME
            if (contentType == null || !contentType.equals("application/pdf")) {
                errors.add("Chỉ được upload file PDF");
            }

            String originalFileName = Paths.get(pdfPart.getSubmittedFileName())
                    .getFileName()
                    .toString();

            if (!originalFileName.toLowerCase().endsWith(".pdf")) {
                errors.add("File phải có định dạng .pdf");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                loadFormAgain(request, response);
                return;
            }

            // 📂 Thư mục lưu PDF
            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\pdf");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // Rename tránh trùng
            String fileNameNew = "book_" + System.currentTimeMillis() + ".pdf";

            pdfPart.write(uploadDir + File.separator + fileNameNew);

            b.setContentPath(fileNameNew);

        } else {
            // Không upload mới → giữ file cũ
            Book old = bookDB.get(bookId);
            b.setContentPath(old.getContentPath());
        }

        Part coverPart = request.getPart("cover_upload");
        String selectedCover = request.getParameter("cover_select");

        if (coverPart != null && coverPart.getSize() > 0) {
            String contentType = coverPart.getContentType();

            long MAX_FILE_SIZE = 2 * 1024 * 1024; // 2MB

            // 1️⃣ Check dung lượng
            if (coverPart.getSize() > MAX_FILE_SIZE) {
                request.setAttribute("error", "Ảnh không được vượt quá 2MB!");
                loadFormAgain(request, response);
                return;
            }
            if (contentType == null || !contentType.startsWith("image/")) {
                request.setAttribute("error", "Chỉ được upload file ảnh!");
                loadFormAgain(request, response);
                return;
            }

            String fileName = Paths.get(coverPart.getSubmittedFileName())
                    .getFileName()
                    .toString()
                    .toLowerCase();

            if (!(fileName.endsWith(".jpg")
                    || fileName.endsWith(".jpeg")
                    || fileName.endsWith(".png")
                    || fileName.endsWith(".gif")
                    || fileName.endsWith(".webp"))) {

                request.setAttribute("error", "Định dạng ảnh không hợp lệ!");

                request.setAttribute("error", "Chỉ được upload file ảnh!");
                loadFormAgain(request, response);
                return;
            }

            String uploadDir
                    = getServletContext().getRealPath("/") // build/web
                            .replace("build\\web", "web\\img\\book");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String originalFileName = Paths.get(coverPart.getSubmittedFileName())
                    .getFileName()
                    .toString();

            String extension = originalFileName.substring(
                    originalFileName.lastIndexOf(".")
            );

            String fileNameNew = "book_" + System.currentTimeMillis() + extension;

            coverPart.write(uploadDir + File.separator + fileNameNew);

            // 👉 CHỈ LƯU TÊN FILE
            b.setCoverUrl(fileNameNew);
        } else if (selectedCover != null && !selectedCover.isEmpty()) {
            b.setCoverUrl(selectedCover);
        } else {
            Book old = bookDB.get(bookId);
            b.setCoverUrl(old.getCoverUrl());
        }

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
