package controller.reader;

import dal.BorrowDBContext;
import dal.BorrowExtendDBContext;
import dal.ReturnRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Set;
import model.Reader;

@WebServlet(urlPatterns = "/reader/borrowed")
public class BorrowedController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Reader reader = (Reader) session.getAttribute("user");

        String currentFilter = normalizeFilter(req.getParameter("filter"));

        BorrowDBContext borrowDAO = new BorrowDBContext();
        ArrayList<model.BorrowedBookItem> items = borrowDAO.listHistoryByReader(reader.getReaderId(), "all");

        ReturnRequestDBContext rrDao = new ReturnRequestDBContext();
        Set<Integer> pendingReturnBorrowItemIds = rrDao.listPendingBorrowItemIdsByReader(reader.getReaderId());

        BorrowExtendDBContext beDao = new BorrowExtendDBContext();
        Set<Integer> pendingExtendBorrowItemIds = beDao.listPendingBorrowItemIdsByReader(reader.getReaderId());

        req.setAttribute("borrowedItems", items);
        req.setAttribute("pendingReturnBorrowItemIds", pendingReturnBorrowItemIds);
        req.setAttribute("pendingExtendBorrowItemIds", pendingExtendBorrowItemIds);
        req.setAttribute("currentFilter", currentFilter);
        req.getRequestDispatcher("/view/reader/borrowed.jsp").forward(req, resp);
    }

    private String normalizeFilter(String filter) {
        if (filter == null || filter.trim().isEmpty()) return "all";
        filter = filter.trim().toLowerCase();
        return switch (filter) {
            case "all", "returned", "borrowing", "overdue" -> filter;
            default -> "all";
        };
    }
}