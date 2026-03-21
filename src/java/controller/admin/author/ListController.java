package controller.admin.author;

import dal.AuthorDBContext;
import model.Author;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/authors/list")
public class ListController extends HttpServlet {

    private AuthorDBContext adb = new AuthorDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }

        int page = 1;
        int pageSize = 8;

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
        }

        int total = adb.count(search);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        ArrayList<Author> authors = adb.search(search, page, pageSize);

        request.setAttribute("authors", authors);
        request.setAttribute("search", search);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("pageTitle", "Author Management");
        request.setAttribute("activeMenu", "author");
        request.setAttribute("contentPage", "../../view/admin/authors/list.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
    }
}
