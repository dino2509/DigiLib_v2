package controller.reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

import model.Book;
import model.ReadingProgress;
import model.User;

@WebServlet("/reader/home")
public class ReaderHomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== Mock user (sau này lấy từ session) =====
        User user = new User();
        user.setFullName("VuDino");
        request.setAttribute("user", user);

        // ===== Mock summary =====
        request.setAttribute("borrowedCount", 3);
        request.setAttribute("dueSoonCount", 1);
        request.setAttribute("readTotal", 12);

        // ===== Continue Reading =====
        List<ReadingProgress> continueReading = new ArrayList<>();

        continueReading.add(new ReadingProgress(
                new Book(1, "Clean Code", "Robert C. Martin", "clean_code.jpg", 4.5),
                65
        ));

        continueReading.add(new ReadingProgress(
                new Book(2, "Design Patterns", "GoF", "design_patterns.jpg", 4.7),
                30
        ));

        request.setAttribute("continueReading", continueReading);

        // ===== Recommended Books =====
        List<Book> recommended = List.of(
                new Book(3, "Refactoring", "Martin Fowler", "refactoring.jpg", 4.6),
                new Book(4, "Effective Java", "Joshua Bloch", "effective_java.jpg", 4.8),
                new Book(5, "Spring in Action", "Craig Walls", "spring.jpg", 4.4),
                new Book(6, "Java Concurrency", "Brian Goetz", "concurrency.jpg", 4.5)
        );

        request.setAttribute("recommendedBooks", recommended);

        request.getRequestDispatcher("/view/reader/home.jsp").forward(request, response);
    }
}
