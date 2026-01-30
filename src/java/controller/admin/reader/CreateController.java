package controller.admin.reader;

import dal.ReaderDBContext;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import model.Reader;
import util.PasswordUtil;

@WebServlet("/admin/readers/add")
public class CreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // hiển thị form
        request.getRequestDispatcher("../../view/admin/reader/add.jsp").forward(request, response);
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
        int roleId = Integer.parseInt(request.getParameter("role_id"));

        // hash password
        String passwordHash = PasswordUtil.hashPassword(password);

        Reader r = new Reader();
        r.setFullName(fullName);
        r.setEmail(email);
        r.setPhone(phone);
        r.setStatus(status);
        r.setRoleId(roleId);
        r.setCreatedAt(LocalDateTime.now());
        r.setPasswordHash(passwordHash);
        ReaderDBContext readerDB = new ReaderDBContext();
        readerDB.insert(r);

        response.sendRedirect(request.getContextPath() + "/admin/readers");
    }
}
