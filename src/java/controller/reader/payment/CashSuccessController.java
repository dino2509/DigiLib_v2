package controller.reader.payment;

import dao.OrderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Reader;

@WebServlet("/reader/payment/cash-success")
public class CashSuccessController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("user");

        // 🔒 chưa login
        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdRaw = request.getParameter("orderId");

        if (orderIdRaw == null) {
            response.sendRedirect(request.getContextPath() + "/reader/cart");
            return;
        }

        int orderId;

        try {
            orderId = Integer.parseInt(orderIdRaw);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/reader/cart");
            return;
        }

        OrderDBContext dao = new OrderDBContext();

        // 🔒 check order có thuộc user không (QUAN TRỌNG)
        boolean isOwner = dao.isOrderBelongToReader(orderId, reader.getReaderId());

        if (!isOwner) {
            response.sendRedirect(request.getContextPath() + "/reader/home");
            return;
        }

        // set data
        request.setAttribute("orderId", orderId);

        request.setAttribute("contentPage", "/view/reader/payment/cash-success.jsp");
        request.getRequestDispatcher("/include/reader/layout.jsp")
                .forward(request, response);
    }
}
