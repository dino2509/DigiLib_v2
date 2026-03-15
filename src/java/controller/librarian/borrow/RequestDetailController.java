package controller.librarian.borrow;

import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.borrow.BorrowRequest;
import model.borrow.BorrowRequestItem;

import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/request-detail")
public class RequestDetailController extends HttpServlet {

    private BorrowRequestDBContext dao = new BorrowRequestDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String idParam = request.getParameter("id");

            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/librarian/requests");
                return;
            }

            int id = Integer.parseInt(idParam);

            BorrowRequest borrowRequest = dao.getRequestById(id);

            if (borrowRequest == null) {
                response.sendRedirect(request.getContextPath() + "/librarian/requests");
                return;
            }

            List<BorrowRequestItem> items = dao.getRequestItems(id);

            request.setAttribute("request", borrowRequest);
            request.setAttribute("items", items);

            request.setAttribute("pageTitle", "Borrow Request #" + id);
            request.setAttribute("activeMenu", "borrowRequests");
            request.setAttribute("contentPage", "/view/librarian/borrow/request-detail.jsp");

            request.getRequestDispatcher("/include/librarian/layout.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {

            response.sendRedirect(request.getContextPath() + "/librarian/requests");

        } catch (Exception e) {

            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        }
    }
}
