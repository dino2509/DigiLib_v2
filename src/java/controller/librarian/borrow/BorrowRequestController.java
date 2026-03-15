package controller.librarian.borrow;

import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.borrow.BorrowRequest;

import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/requests")
public class BorrowRequestController extends HttpServlet {

    private BorrowRequestDBContext borrowRequestDAO = new BorrowRequestDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int page = 1;
            int pageSize = 10;

            String pageParam = request.getParameter("page");
            String reader = request.getParameter("reader");
            String status = request.getParameter("status");

            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }

            if (reader == null) {
                reader = "";
            }
            if (status == null) {
                status = "";
            }

            int totalRecords = borrowRequestDAO.countRequests(reader, status);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            List<BorrowRequest> requests
                    = borrowRequestDAO.getRequestsByPage(reader, status, page, pageSize);

            request.setAttribute("requests", requests);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.setAttribute("reader", reader);
            request.setAttribute("status", status);

            request.setAttribute("pageTitle", "Borrow Requests");
            request.setAttribute("activeMenu", "borrowRequests");
            request.setAttribute("contentPage", "/view/librarian/borrow/borrow-requests.jsp");

            request.getRequestDispatcher("/include/librarian/layout.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
