package controller.admin.book;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;

import java.io.IOException;

@WebServlet(name = "DetailBookController", urlPatterns = {"/admin/books/detail"})
public class DetailBookController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/books");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/books");
            return;
        }

        Book book = bookDB.get(bookId);

        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/view/error/404.jsp");
            return;
        }

        request.setAttribute("book", book);
        request.setAttribute("pageTitle", "Detail Book");
        request.setAttribute("activeMenu", "book");
        request.setAttribute("contentPage", "../../view/admin/books/detail.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);

//        request.getRequestDispatcher("/view/admin/books/detail.jsp")
//                .forward(request, response);
    }
}
