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

            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }

            int totalRecords = borrowRequestDAO.countRequests();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            List<BorrowRequest> requests = borrowRequestDAO.getRequestsByPage(page, pageSize);

            request.setAttribute("requests", requests);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

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
