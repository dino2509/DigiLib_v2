package controller.auth;

import dal.ReaderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Reader;
import util.PasswordUtil;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private ReaderDBContext readerDB = new ReaderDBContext();
    String link = "view/auth/register.jsp";
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(link).forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        
        // 1️⃣ Validate cơ bản
        if (fullName == null || email == null || password == null
                || fullName.isEmpty() || email.isEmpty() || password.isEmpty()) {

            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher(link).forward(request, response);
            return;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Password confirmation does not match!");
            request.getRequestDispatcher(link).forward(request, response);
            return;
        }

        // 2️⃣ Check email tồn tại
        if (isEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher(link).forward(request, response);
            return;
        }

        // 3️⃣ Hash password (BCrypt)
        String hashedPassword = PasswordUtil.hashPassword(password);

        // 4️⃣ Tạo Reader mới
        Reader r = new Reader();
        r.setFullName(fullName);
        r.setEmail(email);
        r.setPasswordHash(hashedPassword);
        r.setStatus("ACTIVE");
        r.setRoleId(3); // USER

        readerDB.insert(r);
        
        // 5️⃣ Redirect login
        response.sendRedirect("login");
    }

    // =========================
    // CHECK EMAIL EXIST
    // =========================
    private boolean isEmailExists(String email) {
        for (Reader r : readerDB.list()) {
            if (r.getEmail().equalsIgnoreCase(email)) {
                return true;
            }
        }
        return false;
    }
}
