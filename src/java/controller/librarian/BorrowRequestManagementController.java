package controller.librarian;

import dal.BorrowRequestDBContext;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import model.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/borrow-requests")
public class BorrowRequestManagementController extends HttpServlet {

    BorrowRequestDBContext brDB = new BorrowRequestDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<BorrowRequest> list = brDB.getAllRequests();

        request.setAttribute("requests", list);

        request.getRequestDispatcher("/view/librarian/borrows/borrowRequests.jsp")
                .forward(request, response);
    }

}
