/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin.reader;

import dal.ReaderDBContext;
import model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;

import java.io.IOException;
import java.nio.file.Paths;

@WebServlet(name = "ReaderUpdateController", urlPatterns = {"/admin/readers/edit"})
@MultipartConfig(
        maxFileSize = 20 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class UpdateController extends HttpServlet {

    private ReaderDBContext readerDB = new ReaderDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int readerId = Integer.parseInt(request.getParameter("id"));
        Reader reader = readerDB.get(readerId);

        request.setAttribute("reader", reader);
        request.setAttribute("pageTitle", "Update Reader");
        request.setAttribute("activeMenu", "reader");
        request.setAttribute("contentPage", "../../view/admin/readers/edit.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int readerId = Integer.parseInt(request.getParameter("reader_id"));
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        Reader old = readerDB.get(readerId);
        if (old == null) {
            response.sendRedirect(request.getContextPath() + "/admin/readers");
            return;
        }

        // ===== VALIDATE =====
        if (fullName == null || fullName.trim().length() < 3) {
            request.setAttribute("error", "Tên phải >= 3 ký tự");
            doGet(request, response);
            return;
        }

        if (phone != null && !phone.isEmpty() && !phone.matches("^[0-9]{9,11}$")) {
            request.setAttribute("error", "SĐT không hợp lệ");
            doGet(request, response);
            return;
        }

        old.setFullName(fullName);
        old.setEmail(email);
        old.setPhone(phone);
        old.setStatus(status);
        old.setRoleId(3);

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

            // DELETE OLD FILE
            if (old.getAvatar() != null) {
                File oldFile = new File(uploadDir + File.separator + old.getAvatar());
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            old.setAvatar(newFile);
        }

        readerDB.update(old);

        response.sendRedirect(request.getContextPath() + "/admin/readers");
    }
}
