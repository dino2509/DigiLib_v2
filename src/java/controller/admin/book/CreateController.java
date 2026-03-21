package controller.admin.book;

import dal.BookDBContext;
import dal.AuthorDBContext;
import dal.CategoryDBContext;
import model.Book;
import model.Author;
import model.Category;
import model.Employee;

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

@WebServlet(name = "CreateController", urlPatterns = {"/admin/books/add"})
@MultipartConfig(
        maxFileSize = 50 * 1024 * 1024, // 50MB
        maxRequestSize = 70 * 1024 * 1024 // tổng request
)
public class CreateController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private AuthorDBContext authorDB = new AuthorDBContext();
    private CategoryDBContext categoryDB = new CategoryDBContext();

    // =========================
    // SHOW FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("authors", authorDB.list());
        request.setAttribute("categories", categoryDB.list());

        request.setAttribute("pageTitle", "Add Book");
        request.setAttribute("activeMenu", "book");
        request.setAttribute("contentPage", "../../view/admin/books/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    // =========================
    // HANDLE CREATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LOGIN CHECK =====
        Employee emp = (Employee) request.getSession().getAttribute("user");
        if (emp == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Book b = new Book();

        // ===== BASIC =====
        b.setTitle(request.getParameter("title"));
        b.setSummary(request.getParameter("summary"));
        b.setDescription(request.getParameter("description"));

        // ===== ISBN =====
        String isbnRaw = request.getParameter("isbn");
        if (isbnRaw != null && !isbnRaw.trim().isEmpty()) {
            try {
                int isbn = Integer.parseInt(isbnRaw.trim());

                if (isbnRaw.length() < 6 || isbnRaw.length() > 13) {
                    request.setAttribute("error", "ISBN phải từ 6-13 chữ số!");
                    loadFormAgain(request, response);
                    return;
                }

                b.setIsbn(isbn);
            } catch (Exception e) {
                request.setAttribute("error", "ISBN không hợp lệ!");
                loadFormAgain(request, response);
                return;
            }
        } else {
            b.setIsbn(0);
        }

        // ===== PRICE =====
        String price = request.getParameter("price");
        try {
            if (price != null && !price.isEmpty()) {
                b.setPrice(new BigDecimal(price));
            }
        } catch (Exception e) {
            request.setAttribute("error", "Giá không hợp lệ!");
            loadFormAgain(request, response);
            return;
        }

        b.setCurrency(request.getParameter("currency"));
        b.setStatus(request.getParameter("status"));
        b.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        b.setCreate_by(emp);

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

        // =========================
        // UPLOAD COVER (20MB)
        // =========================
        Part coverPart = request.getPart("cover_url");

        if (coverPart != null && coverPart.getSize() > 0) {

            long MAX_FILE_SIZE = 20 * 1024 * 1024; // 20MB

            if (coverPart.getSize() > MAX_FILE_SIZE) {
                request.setAttribute("error", "Ảnh không được vượt quá 20MB!");
                loadFormAgain(request, response);
                return;
            }

            String contentType = coverPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                request.setAttribute("error", "Chỉ được upload file ảnh!");
                loadFormAgain(request, response);
                return;
            }

            String fileName = Paths.get(coverPart.getSubmittedFileName())
                    .getFileName().toString().toLowerCase();

            if (!(fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")
                    || fileName.endsWith(".png") || fileName.endsWith(".gif")
                    || fileName.endsWith(".webp"))) {

                request.setAttribute("error", "Định dạng ảnh không hợp lệ!");
                loadFormAgain(request, response);
                return;
            }

            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\img\\book");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String ext = fileName.substring(fileName.lastIndexOf("."));
            String fileNameNew = "book_" + System.currentTimeMillis() + ext;

            coverPart.write(uploadDir + File.separator + fileNameNew);

            b.setCoverUrl(fileNameNew);
        }

        // =========================
        // UPLOAD PDF (50MB)
        // =========================
        Part pdfPart = request.getPart("content_path");

        if (pdfPart != null && pdfPart.getSize() > 0) {

            long MAX_PDF_SIZE = 50 * 1024 * 1024; // 50MB

            if (pdfPart.getSize() > MAX_PDF_SIZE) {
                request.setAttribute("error", "PDF không được vượt quá 50MB!");
                loadFormAgain(request, response);
                return;
            }

            String contentType = pdfPart.getContentType();
            if (contentType == null || !contentType.equals("application/pdf")) {
                request.setAttribute("error", "Chỉ được upload PDF!");
                loadFormAgain(request, response);
                return;
            }

            String original = Paths.get(pdfPart.getSubmittedFileName())
                    .getFileName().toString();

            if (!original.toLowerCase().endsWith(".pdf")) {
                request.setAttribute("error", "File phải là .pdf!");
                loadFormAgain(request, response);
                return;
            }

            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\pdf");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String fileNameNew = "book_" + System.currentTimeMillis() + ".pdf";

            pdfPart.write(uploadDir + File.separator + fileNameNew);

            b.setContentPath(fileNameNew);
        }

        // ===== INSERT =====
        bookDB.insert(b);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void loadFormAgain(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("authors", authorDB.list());
        request.setAttribute("categories", categoryDB.list());

        request.setAttribute("pageTitle", "Add Book");
        request.setAttribute("activeMenu", "book");
        request.setAttribute("contentPage", "../../view/admin/books/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}
