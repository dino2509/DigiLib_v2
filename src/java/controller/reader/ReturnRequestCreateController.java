package controller.reader;

import dal.ReturnRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;

/**
 * Reader bấm "Trả sách" ở /reader/borrowed -> tạo Return_Request (PENDING).
 */
@WebServlet(urlPatterns = "/reader/return/request")
public class ReturnRequestCreateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Reader reader = requireReader(req, resp);
        if (reader == null) return;

        int borrowItemId = parseInt(req.getParameter("borrowItemId"), -1);
        String filter = normalizeFilter(req.getParameter("filter"));

        if (borrowItemId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/reader/borrowed?filter=" + filter + "&returnError=1");
            return;
        }

        ReturnRequestDBContext dao = new ReturnRequestDBContext();
        Integer id = dao.createByReader(reader.getReaderId(), borrowItemId);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/reader/borrowed?filter=" + filter + "&returnError=1");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/reader/borrowed?filter=" + filter + "&returnRequested=1");
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