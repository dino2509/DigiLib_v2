package controller.admin.employee;

import dal.EmployeeDBContext;
import dal.RoleDBContext;
import model.Employee;
import model.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;

@WebServlet(name = "EmployeeUpdateController",
        urlPatterns = {"/admin/employees/edit"})
@MultipartConfig(
        maxFileSize = 20 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class UpdateController extends HttpServlet {

    private EmployeeDBContext employeeDB = new EmployeeDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int employeeId = Integer.parseInt(request.getParameter("id"));

        Employee employee = employeeDB.get(employeeId);
        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        RoleDBContext roleDB = new RoleDBContext();
        ArrayList<Role> roles = roleDB.list();

        request.setAttribute("roles", roles);
        request.setAttribute("employee", employee);
        request.setAttribute("pageTitle", "Update Employee");
        request.setAttribute("activeMenu", "employee");
        request.setAttribute("contentPage", "../../view/admin/employees/edit.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int employeeId = Integer.parseInt(request.getParameter("employee_id"));
        int roleId = Integer.parseInt(request.getParameter("role_id"));
        String status = request.getParameter("status");
        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");

        Employee old = employeeDB.get(employeeId);
        if (old == null) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        old.setFullName(fullName);
        old.setRoleId(roleId);
        old.setStatus(status);
        old.setPhone(phone);

        // ================= UPLOAD AVATAR =================
        Part avatarPart = request.getPart("avatar");

        if (avatarPart != null && avatarPart.getSize() > 0) {

            long MAX_FILE_SIZE = 20 * 1024 * 1024;

            // SIZE
            if (avatarPart.getSize() > MAX_FILE_SIZE) {
                request.setAttribute("error", "Avatar must be under 20MB");
                doGet(request, response);
                return;
            }

            // TYPE
            String contentType = avatarPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                request.setAttribute("error", "Only image files allowed");
                doGet(request, response);
                return;
            }

            // EXT
            String fileName = Paths.get(avatarPart.getSubmittedFileName())
                    .getFileName().toString().toLowerCase();

            if (!(fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")
                    || fileName.endsWith(".png") || fileName.endsWith(".gif")
                    || fileName.endsWith(".webp"))) {

                request.setAttribute("error", "Invalid image format");
                doGet(request, response);
                return;
            }

            // ===== SAVE =====
            String uploadDir = getServletContext().getRealPath("/")
                    .replace("build\\web", "web\\img\\avatar");

            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String ext = fileName.substring(fileName.lastIndexOf("."));
            String newFile = "avatar_" + System.currentTimeMillis() + ext;

            avatarPart.write(uploadDir + File.separator + newFile);

            // delete old
            if (old.getAvatar() != null) {
                File oldFile = new File(uploadDir + File.separator + old.getAvatar());
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            old.setAvatar(newFile);
        }
        // ===== VALIDATE NAME =====
        if (fullName == null || fullName.trim().length() < 3) {
            request.setAttribute("error", "Full name must be at least 3 characters");
            doGet(request, response);
            return;
        }

// ===== VALIDATE PHONE =====
        if (phone != null && !phone.isEmpty()) {
            if (!phone.matches("^[0-9]{9,11}$")) {
                request.setAttribute("error", "Phone must be 9-11 digits");
                doGet(request, response);
                return;
            }
        }

        employeeDB.update(old);

        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }
}
