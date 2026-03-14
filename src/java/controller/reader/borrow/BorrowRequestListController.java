package controller.reader.borrow;

import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import model.borrow.BorrowRequest;
import model.Reader;

@WebServlet("/reader/borrow-requests")
public class BorrowRequestListController extends HttpServlet {

    private BorrowRequestDBContext requestDB = new BorrowRequestDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<BorrowRequest> requests
                = requestDB.getRequestsByReader(reader.getReaderId());

        request.setAttribute("requests", requests);

        request.setAttribute("pageTitle", "Borrow Requests");
        request.setAttribute("activeMenu", "borrow-requests");
        request.setAttribute("contentPage", "/view/reader/borrow/borrow-requests.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
