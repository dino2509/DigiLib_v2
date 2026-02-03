package controller.admin.author;

import dal.AuthorDBContext;
import model.Author;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CreateAuthorController", urlPatterns = {"/admin/authors/add"})
public class CreateController extends HttpServlet {

    private AuthorDBContext authorDB = new AuthorDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hiển thị form add
        request.setAttribute("pageTitle", "Add Author");
        request.setAttribute("activeMenu", "author");
        request.setAttribute("contentPage", "../../view/admin/authors/add.jsp");
        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/authors/add.jsp")
//                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Author author = new Author();

        author.setAuthor_name(request.getParameter("author_name"));
        author.setBio(request.getParameter("bio"));

        authorDB.insert(author);

        // quay về list
        response.sendRedirect(request.getContextPath() + "/admin/authors");
    }
}
