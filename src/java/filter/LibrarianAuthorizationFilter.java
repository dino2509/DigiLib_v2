package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

import jakarta.servlet.annotation.WebFilter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Employee;
import model.Reader;

@WebFilter("/librarian/*")
public class LibrarianAuthorizationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        // chưa login
        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");

        // session không có user
        if (userObj == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // nếu là Reader → không có quyền librarian
        if (userObj instanceof Reader) {
            res.sendRedirect(req.getContextPath() + "/access-denied");
            return;
        }

        // nếu là Employee
        if (userObj instanceof Employee) {

            Employee user = (Employee) userObj;
            int role = user.getRoleId();

            // roleId 1 = ADMIN
            // roleId 2 = LIBRARIAN
            if (role == 1 || role == 2) {

                chain.doFilter(request, response);
                return;
            }
        }

        // không đủ quyền
        res.sendRedirect(req.getContextPath() + "/access-denied");
    }
}