package listener;

import dal.BookDBContext;
import dal.CategoryDBContext;
import dal.AuthorDBContext;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.ArrayList;
import model.Book;
import model.Category;
import model.Author;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        System.out.println("🚀 Application is starting...");

        ServletContext context = sce.getServletContext();

        BookDBContext bookDB = new BookDBContext();
        CategoryDBContext categoryDB = new CategoryDBContext();
        AuthorDBContext authorDB = new AuthorDBContext();

        // Load dữ liệu từ DB
        ArrayList<Book> books = bookDB.listAll();
        ArrayList<Category> categories = categoryDB.list();
        ArrayList<Author> authors = authorDB.list();

        // Lưu vào Application Scope
        context.setAttribute("app_books", books);
        context.setAttribute("app_categories", categories);
        context.setAttribute("app_authors", authors);

        System.out.println("✅ Data loaded successfully at startup!");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("🛑 Application stopped.");
    }
}
