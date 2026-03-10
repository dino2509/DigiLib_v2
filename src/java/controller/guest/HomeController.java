package controller.guest;

import dal.BookDBContext;
import model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") instanceof model.Reader) {
            response.sendRedirect(request.getContextPath() + "/reader/home");
            return;
        }

        // 1. Gọi DBContext
        BookDBContext bookDB = new BookDBContext();

        // 2. Lấy danh sách sách (KHÔNG filter status để tránh lỗi)
        ArrayList<Book> books = bookDB.listAll();

        // 3. Gửi dữ liệu sang JSP
        request.setAttribute("books", books);

        // 4. Forward sang trang home.jsp (guest)
        request.getRequestDispatcher("/view/guest/home.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
