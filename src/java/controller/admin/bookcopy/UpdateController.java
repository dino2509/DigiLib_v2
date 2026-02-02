package controller.admin.bookcopy;

import dal.BookCopyDBContext;
import model.BookCopy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "BookCopyUpdateController", urlPatterns = {"/admin/bookcopies/edit"})
public class UpdateController extends HttpServlet {

    private BookCopyDBContext bookCopyDB = new BookCopyDBContext();

    // =========================
    // SHOW UPDATE FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int copyId = Integer.parseInt(request.getParameter("id"));
        BookCopy copy = bookCopyDB.get(copyId);

        request.setAttribute("bookCopy", copy);
         request.setAttribute("pageTitle", "Update Book Copy");
        request.setAttribute("activeMenu", "bookcopy");
        request.setAttribute("contentPage", "../../view/admin/bookcopies/edit.jsp");

        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/bookcopies/edit.jsp")
//                .forward(request, response);
    }

    // =========================
    // HANDLE UPDATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int copyId = Integer.parseInt(request.getParameter("copy_id"));

        BookCopy copy = bookCopyDB.get(copyId);
        if (copy == null) {
            response.sendRedirect(request.getContextPath() + "/admin/bookcopies/list");
            return;
        }

        // ✔ Chỉ update 2 field cho phép
        copy.setCopyCode(request.getParameter("copy_code"));
        copy.setStatus(request.getParameter("status"));

        bookCopyDB.update(copy);

        response.sendRedirect(request.getContextPath() + "/admin/bookcopies/list");
    }
}
