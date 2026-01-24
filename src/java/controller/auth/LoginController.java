package controller.auth;

import dal.EmployeeDBContext;
import dal.ReaderAccountDBContext;
import dal.ReaderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Employee;
import model.Reader;
import model.ReaderAccount;
import util.PasswordUtil;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private final EmployeeDBContext employeeDB = new EmployeeDBContext();
    private final ReaderDBContext readerDB = new ReaderDBContext();
    private final ReaderAccountDBContext readerAccountDB = new ReaderAccountDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        Object user = null;

        if ("local".equals(type)) {
            user = loginLocal(request);
        } else if ("google".equals(type)) {
            user = loginGoogle(request);
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            
            // ===== ROLE-BASED REDIRECT =====
            if (user instanceof Employee) {
                 Employee e = (Employee) user;
                switch (e.getRoleId()) {
                    case 1: // ADMIN
                        response.sendRedirect("admin/dashboard");
                        break;

                    case 2: // LIBRARIAN
                        response.sendRedirect("librarian/dashboard");
                        break;

//                    case 3: // SELLER
//                        response.sendRedirect("view/seller/dashboard.jsp");
//                        break;

                    default:
                        response.sendRedirect("view/error/403.jsp");
                        break;
                }

            } else if (user instanceof Reader) {
                response.sendRedirect("reader/home");
            }

        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("view/auth/login.jsp")
                    .forward(request, response);
        }
    }

    private Object loginLocal(HttpServletRequest request) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        for (Employee e : employeeDB.list()) {
            if (e.getEmail().equalsIgnoreCase(email)
                    && PasswordUtil.checkPassword(password, e.getPasswordHash())) {
                return e;
            }
        }

        for (Reader r : readerDB.list()) {
            if (r.getEmail().equalsIgnoreCase(email)
                    && PasswordUtil.checkPassword(password, r.getPasswordHash())) {
                return r;
            }
        }

        return null;
    }

    private Reader loginGoogle(HttpServletRequest request) {
        String provider = "google";
        String providerUserId = request.getParameter("providerUserId");

        ReaderAccount acc
                = readerAccountDB.getByProviderAndProviderUserId(provider, providerUserId);

        if (acc != null) {
            return readerDB.get(acc.getReaderId());
        }
        return null;
    }
}
