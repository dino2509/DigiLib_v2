package controller.guest;

import dal.BookDBContext;
import model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDBContext bookDB = new BookDBContext();

        // lấy keyword tìm kiếm
        String keyword = request.getParameter("keyword");

        ArrayList<Book> books;

        // ===== SEARCH =====
//        if (keyword != null && !keyword.trim().isEmpty()) {
//
//            books = bookDB.searchByTitle(keyword);
//
//            request.setAttribute("searchKeyword", keyword);
//
//        } // ===== HOME =====
//        else {

            books = bookDB.listAll();

            // chỉ hiển thị 8 sách đầu
            if (books.size() > 8) {
                books = new ArrayList<>(books.subList(0, 8));
            }
//
//        }

        // gửi dữ liệu sang JSP
        request.setAttribute("books", books);

        request.setAttribute("pageTitle", "Trang chủ");
        request.setAttribute("contentPage", "/view/guest/home.jsp");

        request.getRequestDispatcher("/include/guest/layout.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }
}
