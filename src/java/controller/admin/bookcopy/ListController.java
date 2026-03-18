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
        String copyCode = request.getParameter("copy_code");
        String bookTitle = request.getParameter("book_title");
        String pageRaw = request.getParameter("page");

        Integer bookId = null;

        try {
            if (bookIdRaw != null && !bookIdRaw.isEmpty()) {
                bookId = Integer.parseInt(bookIdRaw);
            }
        } catch (Exception ignored) {
        }

        // Pagination
        int page = 1;
        int pageSize = 10;

        try {
            if (pageRaw != null) {
                page = Integer.parseInt(pageRaw);
            }
        } catch (Exception ignored) {
        }

        if (page < 1) {
            page = 1;
        }

        // Count
        int totalRecords = bookCopyDB.count(bookId, status, copyCode, bookTitle);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        // Data
        ArrayList<BookCopy> bookCopies
                = bookCopyDB.listPaging(bookId, status, copyCode, bookTitle, page, pageSize);

        // Set attribute
        request.setAttribute("bookCopies", bookCopies);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        request.setAttribute("bookId", bookIdRaw);
        request.setAttribute("status", status);
        request.setAttribute("copyCode", copyCode);
        request.setAttribute("bookTitle", bookTitle);

        request.setAttribute("pageTitle", "Book Copy Management");
        request.setAttribute("activeMenu", "bookcopy");
        request.setAttribute("contentPage", "../../view/admin/bookcopies/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}
