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

    int page = 1;
    int pageSize = 6;

    String pageParam = request.getParameter("page");

    if(pageParam != null){
        page = Integer.parseInt(pageParam);
    }

    int totalRecords = dao.countExtendRequests();
    int totalPages = (int)Math.ceil((double)totalRecords/pageSize);

    List<BorrowExtend> extendList =
            dao.getExtendRequests(page,pageSize);

    request.setAttribute("extendList",extendList);
    request.setAttribute("currentPage",page);
    request.setAttribute("totalPages",totalPages);

    request.setAttribute("pageTitle","Borrow Extend Requests");
    request.setAttribute("activeMenu","extend");
    request.setAttribute("contentPage",
            "/view/librarian/borrow/borrow_extend.jsp");

    request.getRequestDispatcher("/include/librarian/layout.jsp")
            .forward(request,response);
}
}
