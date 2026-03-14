package controller.reader.ebook;

import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Book;
@WebServlet(urlPatterns = "/reader/ebooks")
public class EbooksController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 8;

        String pageParam = request.getParameter("page");

        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        BookDBContext ebookDB = new BookDBContext();

        List<Book> ebooks = ebookDB.getFreeEbooks(page, pageSize);

        int total = ebookDB.countFreeEbooks();

        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("ebooks", ebooks);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "Free Ebooks");
        request.setAttribute("activeMenu", "ebooks");
        request.setAttribute("contentPage", "/view/reader/ebook/ebooks.jsp");

        request.getRequestDispatcher("/include/reader/layout.jsp").forward(request, response);
    }
}