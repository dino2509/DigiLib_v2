package controller.reader.book;

import dal.ReadingHistoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Reader;
import model.ReadingHistory;
@WebServlet(urlPatterns = "/reader/history")
public class ReaderHistoryController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader reader = (Reader) request.getSession().getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int page = 1;
        int pageSize = 8;

        String pageParam = request.getParameter("page");

        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        ReadingHistoryDBContext historyDB = new ReadingHistoryDBContext();

        List<ReadingHistory> history
                = historyDB.getHistoryByReader(reader.getReaderId(), page, pageSize);

        int total = historyDB.countHistory(reader.getReaderId());

        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("history", history);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "Reading History");
        request.setAttribute("activeMenu", "history");
        request.setAttribute("contentPage", "/view/reader/book/history.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }
}
