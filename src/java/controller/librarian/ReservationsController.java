package controller.librarian;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Deprecated endpoint: /librarian/reservations
 * Yêu cầu mới: bỏ trang reservations, gộp vào /librarian/borrow-requests
 *
 * -> Controller này chỉ giữ lại để không lỗi route/compile, và tự redirect.
 */
@WebServlet(urlPatterns = "/librarian/reservations")
public class ReservationsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=reserved");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/librarian/borrow-requests?filter=reserved");
    }
}