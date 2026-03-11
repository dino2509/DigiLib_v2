/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.book;

import dal.BookCopyDBContext;
import dal.BookDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Book;

@WebServlet("/book-detail")
public class BookDetailController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
    private BookCopyDBContext copyDB = new BookCopyDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Book book = bookDB.get(id);
        int copiesAvailable = copyDB.getAvailableCopies(id);
        request.setAttribute("copiesAvailable", copiesAvailable);
        request.setAttribute("book", book);
        request.setAttribute("pageTitle", book.getTitle());
        request.setAttribute("contentPage", "/view/book/book-detail.jsp");

        request.getRequestDispatcher("/include/guest/layout.jsp")
                .forward(request, response);
    }
}
