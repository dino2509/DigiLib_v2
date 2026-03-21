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

@WebFilter({"/admin/*",
        "/view/*"})
public class AdminAuthorizationFilter implements Filter {

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

        // nếu là Reader → không có quyền admin
        if (userObj instanceof Reader) {
            res.sendRedirect(req.getContextPath() + "/access-denied");
            return;
        }

        // nếu là Employee
        if (userObj instanceof Employee) {

            Employee user = (Employee) userObj;

            int role = user.getRoleId();

            // roleId = 1 → ADMIN
            if (role == 1) {

                chain.doFilter(request, response);
                return;
            }
        }

        // không đủ quyền
        res.sendRedirect(req.getContextPath() + "/access-denied");
    }
}
