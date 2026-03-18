package controller.librarian.fine;

import dal.FineDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Fine;

import java.io.IOException;
import java.util.List;

@WebServlet("/librarian/fines")
public class FinesController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        FineDBContext fineDAO = new FineDBContext();

        // FILTER PARAMS
        String readerIdRaw = request.getParameter("readerId");
        String status = request.getParameter("status");
        String typeIdRaw = request.getParameter("typeId");
        String pageRaw = request.getParameter("page");

        Integer readerId = null;
        Integer typeId = null;
        int page = 1;

        try {
            if (readerIdRaw != null && !readerIdRaw.isEmpty()) {
                readerId = Integer.parseInt(readerIdRaw);
            }
            if (typeIdRaw != null && !typeIdRaw.isEmpty()) {
                typeId = Integer.parseInt(typeIdRaw);
            }
            if (pageRaw != null) {
                page = Integer.parseInt(pageRaw);
            }
        } catch (Exception e) {
            page = 1;
        }

        int offset = (page - 1) * PAGE_SIZE;

        // DATA
        List<Fine> fines = fineDAO.getFinesPaging(
                readerId, status, typeId, offset, PAGE_SIZE
        );

        int total = fineDAO.countFines(readerId, status, typeId);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        // SET ATTRIBUTES
        request.setAttribute("fines", fines);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        // giữ filter
        request.setAttribute("readerId", readerIdRaw);
        request.setAttribute("status", status);
        request.setAttribute("typeId", typeIdRaw);

        // page content
        request.setAttribute("contentPage", "/view/librarian/fine/fines.jsp");

// active menu (QUAN TRỌNG)
        request.setAttribute("activeMenu", "fines");

// forward về layout
        request.getRequestDispatcher("/include/librarian/layout.jsp")
                .forward(request, response);
    }
}
