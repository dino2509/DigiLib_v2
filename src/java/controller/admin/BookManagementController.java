/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller.admin;


import dal.BookDBContext;
import model.Book;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;


@WebServlet(name = "BookManagementController", urlPatterns = {"/admin/books"})
public class BookManagementController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            // Mặc định: danh sách sách
            listBooks(request, response);
        } else {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/admin/books/add")
                           .forward(request, response);
                    break;

                case "edit":
                    showEditForm(request, response);
                    break;

                case "delete":
                    deleteBook(request, response);
                    break;

                default:
                    listBooks(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            insertBook(request, response);
        } else if ("edit".equals(action)) {
            updateBook(request, response);
        } else {
            response.sendRedirect("books");
        }
    }

    // =========================
    // LIST
    // =========================
    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Book> books = bookDB.listAll();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/admin/books/list")
               .forward(request, response);
    }

    // =========================
    // SHOW EDIT FORM
    // =========================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDB.get(bookId);

        request.setAttribute("book", book);
        request.getRequestDispatcher("/admin/books/edit")
               .forward(request, response);
    }

    // =========================
    // INSERT
    // =========================
    private void insertBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Book book = extractBookFromRequest(request);
        book.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        bookDB.insert(book);
        response.sendRedirect("books");
    }

    // =========================
    // UPDATE
    // =========================
    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Book book = extractBookFromRequest(request);
        book.setBookId(Integer.parseInt(request.getParameter("book_id")));
        book.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

        bookDB.update(book);
        response.sendRedirect("books");
    }

    // =========================
    // DELETE
    // =========================
    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int bookId = Integer.parseInt(request.getParameter("id"));
        Book b = bookDB.get(bookId);
        
        bookDB.delete(b);
        response.sendRedirect("books");
    }

    // =========================
    // MAP REQUEST → BOOK
    // =========================
    private Book extractBookFromRequest(HttpServletRequest request) {

        Book book = new Book();

        book.setTitle(request.getParameter("title"));
        book.setSummary(request.getParameter("summary"));
        book.setDescription(request.getParameter("description"));
        book.setCoverUrl(request.getParameter("cover_url"));
        book.setContentPath(request.getParameter("content_path"));

        String price = request.getParameter("price");
        if (price != null && !price.isEmpty()) {
            book.setPrice(new BigDecimal(price));
        }

        book.setCurrency(request.getParameter("currency"));

        book.setTotalPages(parseInt(request.getParameter("total_pages")));
        book.setPreviewPages(parseInt(request.getParameter("preview_pages")));

        book.setStatus(request.getParameter("status"));
        book.setAuthorId(parseInt(request.getParameter("author_id")));
        book.setCategoryId(parseInt(request.getParameter("category_id")));
        book.setCreatedByEmployeeId(parseInt(request.getParameter("employee_id")));

        return book;
    }

    private Integer parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
