package controller.reader;

import dal.FavoriteDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.FavoriteItem;
import model.Reader;

@WebServlet(urlPatterns = "/reader/favorites")
public class FavoritesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");

        FavoriteDBContext favDAO = new FavoriteDBContext();
        ArrayList<FavoriteItem> favorites = favDAO.listFavoritesByReader(reader.getReaderId());

        req.setAttribute("favorites", favorites);
        req.getRequestDispatcher("/view/reader/favorites.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null
                || !(session.getAttribute("user") instanceof Reader)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("user");

        String action = req.getParameter("action");
        int bookId = parseIntOrDefault(req.getParameter("bookId"), -1);

        FavoriteDBContext favDAO = new FavoriteDBContext();

        if (bookId > 0) {
            if ("add".equalsIgnoreCase(action)) {
                favDAO.addFavorite(reader.getReaderId(), bookId);
            } else if ("remove".equalsIgnoreCase(action)) {
                favDAO.removeFavorite(reader.getReaderId(), bookId);
            }
        }

        // redirect back
        String back = req.getHeader("Referer");
        if (back != null && !back.trim().isEmpty()) {
            resp.sendRedirect(back);
        } else {
            resp.sendRedirect(req.getContextPath() + "/reader/favorites");
        }
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            if (s == null || s.trim().isEmpty()) return def;
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
