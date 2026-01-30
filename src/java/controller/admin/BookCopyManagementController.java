package controller.admin;

import dal.BookCopyDBContext;
import model.BookCopy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;

@WebServlet(name = "BookCopyManagementController", urlPatterns = {"/admin/bookcopies"})
public class BookCopyManagementController extends HttpServlet {

    private BookCopyDBContext bookCopyDB = new BookCopyDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listBookCopies(request, response);
        } else {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/admin/bookcopies/add")
                            .forward(request, response);
                    break;

                case "edit":
                    showEditForm(request, response);
                    break;

                case "delete":
                    // ❌ Không delete vật lý – chuyển sang INACTIVE
                    softDelete(request, response);
                    break;

                default:
                    listBookCopies(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            insertBookCopy(request, response);
        } else if ("edit".equals(action)) {
            updateBookCopy(request, response);
        } else {
            response.sendRedirect("bookcopies");
        }
    }

    // =========================
    // LIST
    // =========================
    private void listBookCopies(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<BookCopy> copies = bookCopyDB.list();
        request.setAttribute("bookCopies", copies);
        request.getRequestDispatcher("/admin/bookcopies/list")
                .forward(request, response);
    }

    // =========================
    // SHOW EDIT FORM
    // =========================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int copyId = Integer.parseInt(request.getParameter("id"));
        BookCopy copy = bookCopyDB.get(copyId);

        request.setAttribute("bookCopy", copy);
        request.getRequestDispatcher("/admin/bookcopies/edit")
                .forward(request, response);
    }

    // =========================
    // INSERT
    // =========================
    private void insertBookCopy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        BookCopy copy = extractBookCopyFromRequest(request);
        copy.setCreatedAt(new Timestamp(System.currentTimeMillis()).toLocalDateTime());

        // Mặc định khi thêm mới
        if (copy.getStatus() == null || copy.getStatus().isEmpty()) {
            copy.setStatus("AVAILABLE");
        }

        bookCopyDB.insert(copy);
        response.sendRedirect("bookcopies");
    }

    // =========================
    // UPDATE
    // =========================
    private void updateBookCopy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        BookCopy copy = extractBookCopyFromRequest(request);
        copy.setCopyId(Integer.parseInt(request.getParameter("copy_id")));

        bookCopyDB.update(copy);
        response.sendRedirect("bookcopies");
    }

    // =========================
    // SOFT DELETE (INACTIVE)
    // =========================
    private void softDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int copyId = Integer.parseInt(request.getParameter("id"));
        BookCopy copy = bookCopyDB.get(copyId);

        if (copy != null) {
            copy.setStatus("INACTIVE");
            bookCopyDB.update(copy);
        }
        response.sendRedirect("bookcopies");
    }

    // =========================
    // MAP REQUEST → BOOKCOPY
    // =========================
    private BookCopy extractBookCopyFromRequest(HttpServletRequest request) {

        BookCopy bc = new BookCopy();

        bc.setBookId(Integer.parseInt(request.getParameter("book_id")));
        bc.setCopyCode(request.getParameter("copy_code"));
        bc.setStatus(request.getParameter("status"));

        return bc;
    }
}
