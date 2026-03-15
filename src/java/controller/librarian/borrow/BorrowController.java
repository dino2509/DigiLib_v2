package controller.librarian.borrow;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.borrow.Borrow;

import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/borrows")
public class BorrowController extends HttpServlet {

    private BorrowDBContext dao = new BorrowDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int page = 1;
            int pageSize = 10;

            String pageParam = request.getParameter("page");
            String search = request.getParameter("search");
            String status = request.getParameter("status");

            // tránh null
            if (search == null) {
                search = "";
            }
            if (status == null) {
                status = "";
            }

            // parse page
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // total records
            int totalRecords = dao.countBorrows(search, status);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            if (page > totalPages && totalPages != 0) {
                page = totalPages;
            }

            // get data
            List<Borrow> borrows
                    = dao.getBorrowsByPage(search, status, page, pageSize);

            // send data to JSP
            request.setAttribute("borrows", borrows);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            // giữ filter
            request.setAttribute("search", search);
            request.setAttribute("status", status);

            request.setAttribute("pageTitle", "Borrow Records");
            request.setAttribute("activeMenu", "borrows");
            request.setAttribute("contentPage", "/view/librarian/borrow/borrows.jsp");

            request.getRequestDispatcher("/include/librarian/layout.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
