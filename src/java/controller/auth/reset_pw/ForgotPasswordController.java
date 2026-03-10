/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth.reset_pw;

import dal.ReaderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;
import model.Reader;
import util.MailUtil;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("view/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        ReaderDBContext rdb = new ReaderDBContext();

        Reader reader = rdb.getReaderByEmail(email);
        if (reader == null) {
            req.setAttribute("error", "Nếu email tồn tại, link reset sẽ được gửi");
            req.getRequestDispatcher("view/auth/forgot-password.jsp").forward(req, resp);
            return;
        }

        String token = UUID.randomUUID().toString();
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);

        rdb.insertResetToken(
                "READER",
                reader.getReaderId(),
                token,
                expiredAt
        );

        String resetLink
                = req.getScheme() + "://"
                + req.getServerName() + ":"
                + req.getServerPort()
                + req.getContextPath()
                + "/reset-password?token=" + token;

        String content
                = "<h3>Reset Password</h3>"
                + "<p>Click link dưới đây để đổi mật khẩu:</p>"
                + "<a href='" + resetLink + "'>Reset Password</a>"
                + "<p>Link hết hạn sau 15 phút</p>";

        MailUtil.send(email, "Reset Password", content);

        req.setAttribute("msg", "Nếu email tồn tại, link reset đã được gửi");
        req.getRequestDispatcher("view/auth/forgot-password.jsp").forward(req, resp);
    }
}
