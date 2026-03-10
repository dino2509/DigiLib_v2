package controller.reader;

import dal.BorrowExtendDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;

@WebServlet(urlPatterns = {"/reader/extend/request", "/reader/borrow/extend-request"})
public class BorrowExtendRequestCreateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        int borrowItemId = parseInt(req.getParameter("borrowItemId"), -1);
        int extendDays = parseInt(req.getParameter("extendDays"), -1);
        String filter = normalizeFilter(req.getParameter("filter"));

        if (borrowItemId <= 0 || extendDays < 1 || extendDays > 7) {
            resp.sendRedirect(req.getContextPath() + "/reader/borrowed?filter=" + filter + "&extendError=1");
            return;
        }

        BorrowExtendDBContext dao = new BorrowExtendDBContext();
        Integer id = dao.createByReader(reader.getReaderId(), borrowItemId, extendDays);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/reader/borrowed?filter=" + filter + "&extendError=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reader/borrowed?filter=" + filter + "&extendRequested=1");
    }

    private Reader requireReader(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (Reader) session.getAttribute("user");
    }

    private String normalizeFilter(String filter) {
        if (filter == null || filter.trim().isEmpty()) return "all";
        filter = filter.trim().toLowerCase();
        return switch (filter) {
            case "all", "returned", "borrowing", "overdue" -> filter;
            default -> "all";
        };
    }

    private int parseInt(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }
}