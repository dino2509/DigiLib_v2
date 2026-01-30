package controller.admin;

import dal.AuthorDBContext;
import model.Author;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "AuthorManagementController", urlPatterns = {"/admin/authors"})
public class AuthorManagementController extends HttpServlet {

    private AuthorDBContext authorDB = new AuthorDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listAuthors(request, response);
        } else {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/admin/authors/add")
                           .forward(request, response);
                    break;

                case "edit":
                    showEditForm(request, response);
                    break;

                case "delete":
                    deleteAuthor(request, response);
                    break;

                default:
                    listAuthors(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            insertAuthor(request, response);
        } else if ("edit".equals(action)) {
            updateAuthor(request, response);
        } else {
            response.sendRedirect("authors");
        }
    }

    // =========================
    // LIST
    // =========================
    private void listAuthors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Author> authors = authorDB.list();
        request.setAttribute("authors", authors);
        request.getRequestDispatcher("/admin/authors/list")
               .forward(request, response);
    }

    // =========================
    // SHOW EDIT FORM
    // =========================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int authorId = Integer.parseInt(request.getParameter("id"));
        Author author = authorDB.get(authorId);

        request.setAttribute("author", author);
        request.getRequestDispatcher("/admin/authors/edit")
               .forward(request, response);
    }

    // =========================
    // INSERT
    // =========================
    private void insertAuthor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Author author = extractAuthorFromRequest(request);
        authorDB.insert(author);

        response.sendRedirect("authors");
    }

    // =========================
    // UPDATE
    // =========================
    private void updateAuthor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Author author = extractAuthorFromRequest(request);
        author.setAuthor_id(Integer.parseInt(request.getParameter("author_id")));

        authorDB.update(author);
        response.sendRedirect("authors");
    }

    // =========================
    // DELETE
    // =========================
    private void deleteAuthor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int authorId = Integer.parseInt(request.getParameter("id"));
        Author author = authorDB.get(authorId);

        authorDB.delete(author);
        response.sendRedirect("authors");
    }

    // =========================
    // MAP REQUEST → AUTHOR
    // =========================
    private Author extractAuthorFromRequest(HttpServletRequest request) {

        Author a = new Author();
        a.setAuthor_name(request.getParameter("author_name"));
        a.setBio(request.getParameter("bio"));

        return a;
    }
}
