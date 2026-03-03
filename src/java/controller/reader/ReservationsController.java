package controller.reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Deprecated endpoint: /reader/reservations
 * Yêu cầu mới: bỏ trang reservations, gộp vào /reader/borrow-requests
 *
 * -> Controller này chỉ giữ lại để không lỗi route/compile, và tự redirect.
 */
@WebServlet(urlPatterns = "/reader/reservations")
public class ReservationsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/reader/borrow-requests?filter=reserved");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/reader/borrow-requests?filter=reserved");
    }
}