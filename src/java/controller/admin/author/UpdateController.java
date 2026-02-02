package controller.admin.author;

import dal.AuthorDBContext;
import model.Author;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "UpdateAuthorController", urlPatterns = {"/admin/authors/edit"})
public class UpdateController extends HttpServlet {

    private AuthorDBContext authorDB = new AuthorDBContext();

    // Hiển thị form edit
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int authorId = Integer.parseInt(request.getParameter("id"));
        Author author = authorDB.get(authorId);

        request.setAttribute("author", author);
        request.setAttribute("pageTitle", "Update Author");
        request.setAttribute("activeMenu", "author");
        request.setAttribute("contentPage", "../../view/admin/authors/edit.jsp");
        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/authors/edit.jsp")
//                .forward(request, response);
    }

    // Xử lý update
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Author author = new Author();

        author.setAuthor_id(
                Integer.parseInt(request.getParameter("author_id"))
        );
        author.setAuthor_name(request.getParameter("author_name"));
        author.setBio(request.getParameter("bio"));

        authorDB.update(author);

        response.sendRedirect(request.getContextPath() + "/admin/authors");
    }
}
