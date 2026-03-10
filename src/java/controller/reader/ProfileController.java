package controller.reader;

import dal.ReaderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Reader;

@WebServlet(urlPatterns = "/reader/profile")
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader current = (Reader) session.getAttribute("user");

        // load lại từ DB để đảm bảo bám sát DB (tránh dữ liệu session stale)
        ReaderDBContext readerDB = new ReaderDBContext();
        Reader reader = readerDB.get(current.getReaderId());

        // fallback nếu DB lỗi
        if (reader == null) {
            reader = current;
        }

        req.setAttribute("reader", reader);
        req.getRequestDispatcher("/view/reader/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader current = (Reader) session.getAttribute("user");

        String fullName = trimToNull(req.getParameter("fullName"));
        String phone = trimToNull(req.getParameter("phone"));
        String avatar = trimToNull(req.getParameter("avatar"));

        // Validation tối thiểu
        if (fullName == null) {
            req.setAttribute("error", "Họ tên không được để trống.");
            doGet(req, resp);
            return;
        }
        if (phone != null && phone.length() > 30) {
            req.setAttribute("error", "Số điện thoại không hợp lệ (quá dài).");
            doGet(req, resp);
            return;
        }
        if (avatar != null && avatar.length() > 500) {
            req.setAttribute("error", "URL avatar quá dài.");
            doGet(req, resp);
            return;
        }

        // Load bản ghi thật từ DB, chỉ update các field cho phép.
        ReaderDBContext readerDB = new ReaderDBContext();
        Reader dbReader = readerDB.get(current.getReaderId());
        if (dbReader == null) {
            req.setAttribute("error", "Không tìm thấy tài khoản trong DB.");
            doGet(req, resp);
            return;
        }

        dbReader.setFullName(fullName);
        dbReader.setPhone(phone);
        dbReader.setAvatar(avatar);

        // Giữ nguyên các field hệ thống
        readerDB.update(dbReader);

        // update session để navbar hiển thị đúng tên
        current.setFullName(dbReader.getFullName());
        current.setPhone(dbReader.getPhone());
        current.setAvatar(dbReader.getAvatar());
        session.setAttribute("user", current);

        resp.sendRedirect(req.getContextPath() + "/reader/profile?updated=1");
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
