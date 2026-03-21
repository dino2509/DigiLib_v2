package controller.admin.reader;

import dal.ReaderDBContext;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import model.Reader;
import util.PasswordUtil;

@WebServlet("/admin/readers/add")
@MultipartConfig(
        maxFileSize = 20 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class CreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Add Reader");
        request.setAttribute("activeMenu", "reader");
        request.setAttribute("contentPage", "../../view/admin/readers/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        // ===== VALIDATE =====
        if (fullName == null || fullName.trim().length() < 3) {
            request.setAttribute("error", "Tên phải >= 3 ký tự");
            doGet(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu >= 6 ký tự");
            doGet(request, response);
            return;
        }

        if (phone != null && !phone.isEmpty() && !phone.matches("^[0-9]{9,11}$")) {
            request.setAttribute("error", "SĐT không hợp lệ");
            doGet(request, response);
            return;
        }

        ReaderDBContext readerDB = new ReaderDBContext();

        if (readerDB.existsByEmail(email)) {
            request.setAttribute("error", "Email đã tồn tại");
            doGet(request, response);
            return;
        }

        String passwordHash = PasswordUtil.hashPassword(password);

        Reader r = new Reader();
        r.setFullName(fullName);
        r.setEmail(email);
        r.setPhone(phone);
        r.setStatus(status);
        r.setRoleId(3); // FIX ROLE
        r.setCreatedAt(LocalDateTime.now());
        r.setPasswordHash(passwordHash);

        // ===== UPLOAD AVATAR =====
        Part avatarPart = request.getPart("avatar");

        if (avatarPart != null && avatarPart.getSize() > 0) {

            String fileName = Paths.get(avatarPart.getSubmittedFileName())
                    .getFileName().toString().toLowerCase();

            if (!fileName.matches(".*\\.(jpg|jpeg|png|gif|webp)$")) {
                request.setAttribute("error", "Ảnh không hợp lệ");
                doGet(request, response);
                return;
            }

            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\img\\avatar");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String ext = fileName.substring(fileName.lastIndexOf("."));
            String newFile = "reader_" + System.currentTimeMillis() + ext;

            avatarPart.write(uploadDir + File.separator + newFile);

            r.setAvatar(newFile);
        }

        readerDB.insert(r);

        response.sendRedirect(request.getContextPath() + "/admin/readers");
    }
}
