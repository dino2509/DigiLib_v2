package controller.librarian.request;

import dal.BorrowRequestDBContext;
import dal.BookDBContext;
import dal.ReaderDBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import model.Reader;
import model.Book;

@WebServlet("/librarian/request/add")
public class AddRequestController extends HttpServlet {

    private ReaderDBContext readerDAO = new ReaderDBContext();
    private BookDBContext bookDAO = new BookDBContext();
    private BorrowRequestDBContext requestDAO = new BorrowRequestDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // load data for form
        List<Reader> readerList = readerDAO.getAllReaders();
        List<Book> bookList = bookDAO.getAllBooks();

        request.setAttribute("readerList", readerList);
        request.setAttribute("bookList", bookList);
        request.setAttribute("pageTitle", "Add Request");
        request.setAttribute("contentPage", "/view/librarian/borrow/add.jsp");
        request.setAttribute("activeMenu", "request-add");
        request.getRequestDispatcher("/include/librarian/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ===== GET DATA =====
            int readerId = Integer.parseInt(request.getParameter("readerId"));
            String note = request.getParameter("note");

            String[] bookIds = request.getParameterValues("bookId");
            String[] quantities = request.getParameterValues("quantity");

            // ===== VALIDATION =====
            if (bookIds == null || quantities == null || bookIds.length == 0) {
                request.getSession().setAttribute("error", "Please select at least one book!");
                response.sendRedirect(request.getContextPath() + "/librarian/request/add");
                return;
            }

            if (bookIds.length != quantities.length) {
                throw new RuntimeException("Invalid book data");
            }

            // ===== CREATE REQUEST =====
            int requestId = requestDAO.createBorrowRequests(readerId, note);

            // ===== INSERT ITEMS =====
            for (int i = 0; i < bookIds.length; i++) {

                int bookId = Integer.parseInt(bookIds[i]);
                int quantity = Integer.parseInt(quantities[i]);

                if (quantity <= 0) {
                    continue;
                }

                requestDAO.addRequestItem(requestId, bookId, quantity);
            }

            // ===== SUCCESS =====
            request.getSession().setAttribute("success", "Borrow request created successfully!");

            response.sendRedirect(request.getContextPath() + "/librarian/requests");

        } catch (Exception e) {

            e.printStackTrace();

            request.getSession().setAttribute("error", "Error creating request!");
            response.sendRedirect(request.getContextPath() + "/librarian/requests");
        }
    }
}
