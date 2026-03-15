package controller.librarian.borrow;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.borrow.Borrow;
import model.borrow.BorrowDetailItem;

import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/borrow-detail")
public class BorrowDetailController extends HttpServlet {

    BorrowDBContext dao = new BorrowDBContext();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int borrowId = Integer.parseInt(request.getParameter("id"));

        Borrow borrow = dao.getBorrow(borrowId);
        List<BorrowDetailItem> items = dao.getBorrowItems(borrowId);

        request.setAttribute("borrow", borrow);
        request.setAttribute("items", items);

        request.setAttribute("pageTitle", "Borrow Detail #" + borrowId);
        request.setAttribute("activeMenu", "borrows");
        request.setAttribute("contentPage", "/view/librarian/borrow/borrow-detail.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
