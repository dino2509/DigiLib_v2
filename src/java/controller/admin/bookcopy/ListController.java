package controller.admin.bookcopy;

import dal.BookCopyDBContext;
import model.BookCopy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "BookCopyListController", urlPatterns = {"/admin/bookcopies/list"})
public class ListController extends HttpServlet {

    private BookCopyDBContext bookCopyDB = new BookCopyDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Optional filter theo book_id
        String bookIdRaw = request.getParameter("book_id");
        ArrayList<BookCopy> bookCopies;

        if (bookIdRaw != null && !bookIdRaw.isEmpty()) {
            int bookId = Integer.parseInt(bookIdRaw);
            bookCopies = bookCopyDB.listByBookId(bookId); // nếu chưa có, mình ghi bên dưới
            request.setAttribute("bookId", bookId);
        } else {
            bookCopies = bookCopyDB.list();
        }

        request.setAttribute("bookCopies", bookCopies);
        request.setAttribute("pageTitle", "Book Copy Management");
        request.setAttribute("activeMenu", "bookcopy");
        request.setAttribute("contentPage", "../../view/admin/bookcopies/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/bookcopies/list.jsp")
//                .forward(request, response);
    }
}
