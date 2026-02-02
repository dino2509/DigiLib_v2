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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthorDBContext adb = new AuthorDBContext();
        ArrayList<Author> authors = adb.list();

        request.setAttribute("authors", authors);
        request.getRequestDispatcher("../../view/admin/authors/list.jsp")
               .forward(request, response);
        
        ////
    }
}
