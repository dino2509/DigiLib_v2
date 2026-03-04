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
        maxFileSize = 20 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
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

        request.setAttribute("authors", authorDB.list());
        request.setAttribute("categories", categoryDB.list());

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
//        b.setContentPath(request.getParameter("content_path"));
        // ===== PRICE =====
        String price = request.getParameter("price");
        try {
            if (price != null && !price.isEmpty()) {
                b.setPrice(new BigDecimal(price));
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá không hợp lệ!");
            // forward lại layout (như trên)

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
        // UPLOAD COVER IMAGE
        // =========================
        Part coverPart = request.getPart("cover_url");
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
//                request.getRequestDispatcher("../../view/admin/books/add.jsp").forward(request, response);
//                return;
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
        }

        // =========================
// UPLOAD PDF FILE
// =========================
        Part pdfPart = request.getPart("content_path");

        if (pdfPart != null && pdfPart.getSize() > 0) {

            String contentType = pdfPart.getContentType();
            long MAX_PDF_SIZE = 20 * 1024 * 1024; // 20MB

            // 1️⃣ Check dung lượng
            if (pdfPart.getSize() > MAX_PDF_SIZE) {
                request.setAttribute("error", "File PDF không được vượt quá 20MB!");
                loadFormAgain(request, response);
                return;
            }

            // 2️⃣ Check MIME type
            if (contentType == null || !contentType.equals("application/pdf")) {
                request.setAttribute("error", "Chỉ được upload file PDF!");
                loadFormAgain(request, response);
                return;
            }

            String originalFileName = Paths.get(pdfPart.getSubmittedFileName())
                    .getFileName()
                    .toString();

            if (!originalFileName.toLowerCase().endsWith(".pdf")) {
                request.setAttribute("error", "File phải có định dạng .pdf!");
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

            // 👉 Rename tránh trùng file
            String fileNameNew = "book_" + System.currentTimeMillis() + ".pdf";

            pdfPart.write(uploadDir + File.separator + fileNameNew);

            // 👉 Lưu tên file vào DB
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
