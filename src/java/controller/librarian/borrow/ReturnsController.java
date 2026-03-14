package controller.librarian.borrow;

import dal.BorrowDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.borrow.BorrowItem;
@WebServlet("/librarian/returns")
public class ReturnsController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BorrowDBContext borrowDB = new BorrowDBContext();

        List<BorrowItem> items = borrowDB.getBorrowItemsNotReturned();

        request.setAttribute("items", items);

        request.setAttribute("pageTitle", "Return Books");
        request.setAttribute("activeMenu", "returns");
        request.setAttribute("contentPage", "/view/librarian/borrow/returns.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp").forward(request, response);
    }
}
