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
import model.BorrowedItem;
import model.Reader;

@WebServlet("/reader/borrowed")
public class ReaderBorrowedController extends HttpServlet {

    private final BorrowDBContext borrowDB = new BorrowDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object sessionUser = (session == null) ? null : session.getAttribute("user");
        if (!(sessionUser instanceof Reader)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) sessionUser;
        ArrayList<BorrowedItem> items = borrowDB.listByReader(reader.getReaderId());

        request.setAttribute("items", items);
        request.setAttribute("count", items.size());
        request.getRequestDispatcher("/view/reader/borrowed.jsp").forward(request, response);
    }
}
