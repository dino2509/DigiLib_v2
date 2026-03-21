package controller.admin.reader;

import dal.ReaderDBContext;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/readers/list")
public class ListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ReaderDBContext readerDB = new ReaderDBContext();

        // ===== SEARCH =====
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        // ===== PAGINATION =====
        int page = 1;
        int pageSize = 8;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }

        int total = readerDB.count(keyword);
        int totalPage = (int) Math.ceil((double) total / pageSize);

        int offset = (page - 1) * pageSize;

        ArrayList<Reader> readers = readerDB.search(keyword, offset, pageSize);

        // ===== SET ATTRIBUTE =====
        request.setAttribute("readers", readers);
        request.setAttribute("keyword", keyword);
        request.setAttribute("page", page);
        request.setAttribute("totalPage", totalPage);

        request.setAttribute("pageTitle", "Reader Management");
        request.setAttribute("activeMenu", "reader");
        request.setAttribute("contentPage", "../../view/admin/readers/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}
