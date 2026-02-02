/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin.reader;

import dal.ReaderDBContext;
import model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ReaderUpdateController", urlPatterns = {"/admin/readers/edit"})
public class UpdateController extends HttpServlet {

    private ReaderDBContext readerDB = new ReaderDBContext();

    // =========================
    // SHOW EDIT FORM
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int readerId = Integer.parseInt(request.getParameter("id"));
        Reader reader = readerDB.get(readerId);

        request.setAttribute("reader", reader);
        request.setAttribute("pageTitle", "Update Reader");
        request.setAttribute("activeMenu", "reader");
        request.setAttribute("contentPage", "../../view/admin/readers/edit.jsp");
        request.getRequestDispatcher("/include/admin/layout.jsp")
                .forward(request, response);
//        request.getRequestDispatcher("../../view/admin/reader/edit.jsp")
//               .forward(request, response);
    }

    // =========================
    // UPDATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Reader reader = new Reader();
        reader.setReaderId(Integer.parseInt(request.getParameter("reader_id")));
        reader.setFullName(request.getParameter("full_name"));
        reader.setEmail(request.getParameter("email"));
        reader.setPhone(request.getParameter("phone"));
        reader.setAvatar(request.getParameter("avatar"));
        reader.setStatus(request.getParameter("status"));
        reader.setRoleId(parseInt(request.getParameter("role_id")));

        readerDB.update(reader);

        response.sendRedirect(request.getContextPath() + "/admin/readers");
    }

    private Integer parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
