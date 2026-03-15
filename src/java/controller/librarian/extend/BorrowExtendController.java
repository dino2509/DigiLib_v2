package controller.librarian.extend;

import dal.BorrowExtendDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.borrow.BorrowExtend;

@WebServlet("/librarian/borrow-extend")
public class BorrowExtendController extends HttpServlet {

    private BorrowExtendDBContext dao = new BorrowExtendDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int page = 1;
            int pageSize = 6;

            String pageParam = request.getParameter("page");
            String search = request.getParameter("search");
            String status = request.getParameter("status");

            if (search == null) {
                search = "";
            }
            if (status == null) {
                status = "";
            }

            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }

            int totalRecords = dao.countExtendRequests(search, status);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            List<BorrowExtend> extendList
                    = dao.getExtendRequests(search, status, page, pageSize);

            request.setAttribute("extendList", extendList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.setAttribute("search", search);
            request.setAttribute("status", status);

            request.setAttribute("pageTitle", "Borrow Extend Requests");
            request.setAttribute("activeMenu", "extend");
            request.setAttribute("contentPage",
                    "/view/librarian/borrow/borrow_extend.jsp");

            request.getRequestDispatcher("/include/librarian/layout.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }

    }
}
