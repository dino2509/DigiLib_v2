package controller.admin.bookcopy;

import dal.BookCopyDBContext;
import dal.BookDBContext;
import model.Book;
import model.BookCopy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

        // Load danh sách Book để chọn
        ArrayList<Book> books = bookDB.list();
        request.setAttribute("books", books);
        request.setAttribute("pageTitle", "Add Book Copy");
        request.setAttribute("activeMenu", "bookcopy");
        request.setAttribute("contentPage", "../../view/admin/bookcopies/add.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/bookcopies/add.jsp")
//                .forward(request, response);
    }

    // =========================
    // HANDLE CREATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        BookCopy copy = new BookCopy();

        copy.setBookId(Integer.parseInt(request.getParameter("book_id")));
        copy.setCopyCode(request.getParameter("copy_code"));

        String status = request.getParameter("status");
        copy.setStatus((status == null || status.isEmpty()) ? "AVAILABLE" : status);

        copy.setCreatedAt(new Timestamp(System.currentTimeMillis()).toLocalDateTime());

        bookCopyDB.insert(copy);

        response.sendRedirect(request.getContextPath() + "/admin/bookcopies/list");
    }
}
