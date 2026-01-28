package controller.reader;

import dal.BookDBContext;
import dal.BookmarkDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Book;
import model.Reader;

@WebServlet("/reader/favorites")
public class ReaderFavoritesController extends HttpServlet {

    private final BookmarkDBContext bookmarkDB = new BookmarkDBContext();
    private final BookDBContext bookDB = new BookDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object sessionUser = (session == null) ? null : session.getAttribute("user");
        if (!(sessionUser instanceof Reader)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) sessionUser;

        ArrayList<Integer> bookIds = bookmarkDB.listBookIdsByReader(reader.getReaderId());
        ArrayList<Book> books = bookDB.getByIds(new ArrayList<>(bookIds));

        request.setAttribute("books", books);
        request.setAttribute("count", books.size());
        request.getRequestDispatcher("/view/reader/favorites.jsp").forward(request, response);
    }
}
