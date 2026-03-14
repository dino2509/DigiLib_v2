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

            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }

            int totalRecords = dao.countBorrows();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            List<Borrow> borrows = dao.getBorrowsByPage(page, pageSize);

            request.setAttribute("borrows", borrows);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

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
