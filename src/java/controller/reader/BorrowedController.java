package controller.reader;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.BorrowedBookItem;
import model.Reader;

@WebServlet(urlPatterns = "/reader/borrowed")
public class BorrowedController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");

        BorrowDBContext borrowDAO = new BorrowDBContext();
        ArrayList<BorrowedBookItem> items = borrowDAO.listActiveByReader(reader.getReaderId());

        req.setAttribute("borrowedItems", items);
        req.getRequestDispatcher("/view/reader/borrowed.jsp").forward(req, resp);
    }
}
