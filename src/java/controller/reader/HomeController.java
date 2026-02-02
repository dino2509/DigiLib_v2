package controller.reader;


import dal.BookDBContext;
import model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = "/reader/home")
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ===== 1. CHECK LOGIN =====
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // ===== 2. LOAD BOOK LIST =====
        BookDBContext bookDAO = new BookDBContext();

        // lấy sách mới / nổi bật (tùy bạn implement)
        List<Book> bookList = bookDAO.list();
        // hoặc: bookDAO.getAllBooks();

        // ===== 3. SET ATTRIBUTE =====
        req.setAttribute("bookList", bookList);

        // ===== 4. FORWARD JSP =====
        req.getRequestDispatcher("/view/reader/home.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
