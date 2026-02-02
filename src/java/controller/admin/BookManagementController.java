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
import model.Author;
import model.Category;
import model.Employee;

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

        if ("edit".equals(action)) {
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

        // ===== BASIC INFO =====
        book.setTitle(request.getParameter("title"));
        book.setSummary(request.getParameter("summary"));
        book.setDescription(request.getParameter("description"));
        book.setCoverUrl(request.getParameter("cover_url"));
        book.setContentPath(request.getParameter("content_path"));

        // ===== PRICE =====
        String price = request.getParameter("price");
        if (price != null && !price.isEmpty()) {
            book.setPrice(new BigDecimal(price));
        }

        book.setCurrency(request.getParameter("currency"));

        // ===== PAGES =====
        String totalPages = request.getParameter("total_pages");
        if (totalPages != null && !totalPages.isEmpty()) {
            book.setTotalPages(Integer.parseInt(totalPages));
        }

        String previewPages = request.getParameter("preview_pages");
        if (previewPages != null && !previewPages.isEmpty()) {
            book.setPreviewPages(Integer.parseInt(previewPages));
        }

        // ===== STATUS =====
        book.setStatus(request.getParameter("status"));

        // ===== AUTHOR (OBJECT) =====
        String authorIdRaw = request.getParameter("author_id");
        if (authorIdRaw != null && !authorIdRaw.isEmpty()) {
            Author a = new Author();
            a.setAuthor_id(Integer.parseInt(authorIdRaw));
            book.setAuthor(a);
        }

        // ===== CATEGORY (OBJECT) =====
        String categoryIdRaw = request.getParameter("category_id");
        if (categoryIdRaw != null && !categoryIdRaw.isEmpty()) {
            Category c = new Category();
            c.setCategory_id(Integer.parseInt(categoryIdRaw));
            book.setCategory(c);
        }

        // ===== CREATED BY (FROM SESSION – CHUẨN NGHIỆP VỤ) =====
        Employee emp = (Employee) request.getSession().getAttribute("employee");
        if (emp != null) {
            book.setCreate_by(emp);
        }

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
