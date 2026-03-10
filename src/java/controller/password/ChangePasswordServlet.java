/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller.password;

import dal.ReaderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;
import util.PasswordUtil;


@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect("login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Check confirm password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            
            request.getRequestDispatcher("/view/auth/change-password.jsp").forward(request, response);
            return;
        }

        // 2. Check mật khẩu hiện tại
        if (!PasswordUtil.checkPassword(currentPassword, reader.getPasswordHash())) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng");
            request.getRequestDispatcher("/view/auth/change-password.jsp").forward(request, response);
            return;
        }

        // 3. Update mật khẩu mới
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        
        ReaderDBContext readerDB = new ReaderDBContext();
        readerDB.updatePassword(reader.getReaderId(), hashedPassword);


        request.setAttribute("success", "Đổi mật khẩu thành công");
        request.getRequestDispatcher("/reader/home").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("view/auth/change-password.jsp").forward(req, resp);
    }
    
    
}
