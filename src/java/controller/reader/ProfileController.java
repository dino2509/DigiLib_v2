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
        doGet(req, resp);
    }
}
