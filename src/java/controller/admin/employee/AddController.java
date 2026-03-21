package controller.admin.employee;

import dal.EmployeeDBContext;
import dal.ReaderDBContext;
import dal.RoleDBContext;
import model.Employee;
import model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import model.Role;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@MultipartConfig(
        maxFileSize = 20 * 1024 * 1024, // 20MB
        maxRequestSize = 25 * 1024 * 1024
)
@WebServlet(name = "EmployeeAddController", urlPatterns = {"/admin/employees/add"})
public class AddController extends HttpServlet {

    EmployeeDBContext employeeDB = new EmployeeDBContext();
    RoleDBContext roleDB = new RoleDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("roles", roleDB.list());

        request.setAttribute("pageTitle", "Add Employee");
        request.setAttribute("activeMenu", "employee");
        request.setAttribute("contentPage", "../../view/admin/employees/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String phone = request.getParameter("phone");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String status = request.getParameter("status");
        int roleId = Integer.parseInt(request.getParameter("role_id"));

        // validate
        if (fullName == null || fullName.trim().length() < 3) {
            request.setAttribute("error", "Full name must be at least 3 characters");
            doGet(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            doGet(request, response);
            return;
        }

        // check email duplicate
        if (employeeDB.existsByEmail(email)) {
            request.setAttribute("error", "Email already exists");
            doGet(request, response);
            return;
        }

        // hash password
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

        Employee e = new Employee();
        e.setFullName(fullName);
        e.setEmail(email);
        e.setPasswordHash(passwordHash);
        e.setStatus(status);
        e.setRoleId(roleId);
        e.setCreatedAt(LocalDateTime.now());
e.setPhone(phone);
        Part avatarPart = request.getPart("avatar");

        if (avatarPart != null && avatarPart.getSize() > 0) {

            long MAX_FILE_SIZE = 20 * 1024 * 1024; // 20MB

            // ===== SIZE CHECK =====
            if (avatarPart.getSize() > MAX_FILE_SIZE) {
                request.setAttribute("error", "Avatar không được vượt quá 20MB!");
                doGet(request, response);
                return;
            }

            // ===== TYPE CHECK =====
            String contentType = avatarPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                request.setAttribute("error", "Chỉ được upload file ảnh!");
                doGet(request, response);
                return;
            }

            // ===== FILE NAME =====
            String fileName = java.nio.file.Paths
                    .get(avatarPart.getSubmittedFileName())
                    .getFileName()
                    .toString()
                    .toLowerCase();

            // ===== EXTENSION CHECK =====
            if (!(fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")
                    || fileName.endsWith(".png") || fileName.endsWith(".gif")
                    || fileName.endsWith(".webp"))) {

                request.setAttribute("error", "Định dạng ảnh không hợp lệ!");
                doGet(request, response);
                return;
            }

            // ===== PATH (GIỐNG BOOK) =====
            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\img\\avatar");

            java.io.File dir = new java.io.File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // ===== RENAME FILE =====
            String ext = fileName.substring(fileName.lastIndexOf("."));
            String fileNameNew = "avatar_" + System.currentTimeMillis() + ext;

            // ===== SAVE =====
            avatarPart.write(uploadDir + java.io.File.separator + fileNameNew);

            // ===== SET MODEL =====
            e.setAvatar(fileNameNew);
        }

        employeeDB.insert(e);

        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }
}
