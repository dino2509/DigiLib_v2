package controller.admin.bookcopy;

import dal.BookCopyDBContext;
import model.BookCopy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "BookCopyListController", urlPatterns = {"/admin/bookcopies/list"})
public class ListController extends HttpServlet {

    private BookCopyDBContext bookCopyDB = new BookCopyDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookIdRaw = request.getParameter("book_id");
        String status = request.getParameter("status");
        String pageRaw = request.getParameter("page");

        Integer bookId = null;

        if (bookIdRaw != null && !bookIdRaw.isEmpty()) {
            try {
                bookId = Integer.parseInt(bookIdRaw);
            } catch (NumberFormatException e) {
                bookId = null;
            }
        }

        // Pagination
        int page = 1;
        int pageSize = 10;

        if (pageRaw != null) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (page < 1) {
            page = 1;
        }

        // Count total records
        int totalRecords = bookCopyDB.count(bookId, status);

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        if (totalPages == 0) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        // Get paging data
        ArrayList<BookCopy> bookCopies =
                bookCopyDB.listPaging(bookId, status, page, pageSize);

        // Send data to JSP
        request.setAttribute("bookCopies", bookCopies);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        request.setAttribute("bookId", bookIdRaw);
        request.setAttribute("status", status);

        request.setAttribute("pageTitle", "Book Copy Management");
        request.setAttribute("activeMenu", "bookcopy");
        request.setAttribute("contentPage", "../../view/admin/bookcopies/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}