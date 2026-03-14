package controller.admin.bookcopy;

import dal.BookCopyDBContext;
import dal.BookDBContext;
import model.Book;
import model.BookCopy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;

@WebServlet(name = "BookCopyCreateController", urlPatterns = {"/admin/bookcopies/add"})
public class CreateController extends HttpServlet {

    private BookCopyDBContext bookCopyDB = new BookCopyDBContext();
    private BookDBContext bookDB = new BookDBContext();

    // =========================
    // SHOW CREATE FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Book> books = bookDB.list();

        request.setAttribute("books", books);
        request.setAttribute("pageTitle", "Add Book Copy");
        request.setAttribute("activeMenu", "bookcopy");
        request.setAttribute("contentPage", "../../view/admin/bookcopies/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }

    // =========================
    // HANDLE CREATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int bookId = Integer.parseInt(request.getParameter("book_id"));

        int quantity = Integer.parseInt(request.getParameter("quantity"));

        String prefix = request.getParameter("prefix");

        String status = request.getParameter("status");

        if (status == null || status.isEmpty()) {
            status = "AVAILABLE";
        }

        if (prefix == null || prefix.isEmpty()) {
            prefix = "CP";
        }

        for (int i = 0; i < quantity; i++) {

            int nextNumber = bookCopyDB.getNextCopyNumber(bookId);

            String copyCode = prefix + String.format("%03d", nextNumber);

            BookCopy copy = new BookCopy();

            copy.setBookId(bookId);
            copy.setCopyCode(copyCode);
            copy.setStatus(status);
            copy.setCreatedAt(new Timestamp(System.currentTimeMillis()).toLocalDateTime());

            bookCopyDB.insert(copy);
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookcopies/list");
    }
}
