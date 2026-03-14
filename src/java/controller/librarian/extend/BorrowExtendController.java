package controller.librarian.extend;


import dal.BorrowExtendDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.*;


import java.io.IOException;
import java.util.List;
import model.borrow.BorrowExtend;


@WebServlet(urlPatterns = "/librarian/borrow-extend")
public class BorrowExtendController extends HttpServlet {

    private BorrowExtendDBContext dao = new BorrowExtendDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<BorrowExtend> list = dao.getPendingExtends();

        request.setAttribute("extendList", list);

        request.setAttribute("pageTitle", "Borrow Extend Requests");
        request.setAttribute("activeMenu", "extensions");

        request.setAttribute("contentPage","/view/librarian/borrow/borrow_extend.jsp");

        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }

}
