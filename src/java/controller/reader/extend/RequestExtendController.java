package controller.reader;

import dal.BorrowExtendDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Reader;

import java.io.IOException;

@WebServlet("/reader/request-extend")
public class RequestExtendController extends HttpServlet {

    private BorrowExtendDBContext dao;

    @Override
    public void init() throws ServletException {
        dao = new BorrowExtendDBContext();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");

        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String borrowItemIdStr = request.getParameter("borrowItemId");
        String requestedDate = request.getParameter("requestedDate");

        if (borrowItemIdStr == null || requestedDate == null) {
            response.sendRedirect(request.getContextPath() + "/reader/borrowed");
            return;
        }

        int borrowItemId = Integer.parseInt(borrowItemIdStr);

        try {

            // kiểm tra đã extend chưa
            if (dao.hasExtendRequest(borrowItemId)) {
                response.sendRedirect(request.getContextPath() + "/reader/borrowed");
                return;
            }

            dao.createExtendRequest(borrowItemId, requestedDate);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/reader/borrowed");
    }
}
