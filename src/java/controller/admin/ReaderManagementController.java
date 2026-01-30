/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

import dal.ReaderDBContext;
import model.Reader;

import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "ReaderManagementController", urlPatterns = {"/admin/readers"})
public class ReaderManagementController extends HttpServlet {

    private ReaderDBContext readerDB = new ReaderDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listReaders(request, response);
        } else {
            switch (action) {
                case "add":
                    request.getRequestDispatcher("/admin/readers/add")
                           .forward(request, response);
                    break;

                case "edit":
                    showEditForm(request, response);
                    break;

                case "delete":
                    deleteReader(request, response);
                    break;

                default:
                    listReaders(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            insertReader(request, response);
        } else if ("edit".equals(action)) {
            updateReader(request, response);
        } else {
            response.sendRedirect("readers");
        }
    }

    // =========================
    // LIST
    // =========================
    private void listReaders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Reader> readers = readerDB.list();
        request.setAttribute("readers", readers);
        request.getRequestDispatcher("/admin/readers/list")
               .forward(request, response);
    }

    // =========================
    // SHOW EDIT FORM
    // =========================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int readerId = Integer.parseInt(request.getParameter("id"));
        Reader reader = readerDB.get(readerId);

        request.setAttribute("reader", reader);
        request.getRequestDispatcher("/admin/readers/edit")
               .forward(request, response);
    }

    // =========================
    // INSERT
    // =========================
    private void insertReader(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Reader reader = extractReaderFromRequest(request);
        reader.setCreatedAt(new Timestamp(System.currentTimeMillis()).toLocalDateTime());

        readerDB.insert(reader);
        response.sendRedirect("readers");
    }

    // =========================
    // UPDATE
    // =========================
    private void updateReader(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Reader reader = extractReaderFromRequest(request);
        reader.setReaderId(Integer.parseInt(request.getParameter("reader_id")));

        readerDB.update(reader);
        response.sendRedirect("readers");
    }

    // =========================
    // DELETE
    // =========================
    private void deleteReader(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int readerId = Integer.parseInt(request.getParameter("id"));
        Reader r = readerDB.get(readerId);

        readerDB.delete(r);
        response.sendRedirect("readers");
    }

    // =========================
    // MAP REQUEST → READER
    // =========================
    private Reader extractReaderFromRequest(HttpServletRequest request) {

        Reader r = new Reader();

        r.setFullName(request.getParameter("full_name"));
        r.setEmail(request.getParameter("email"));
        r.setPhone(request.getParameter("phone"));
        r.setAvatar(request.getParameter("avatar"));
        r.setStatus(request.getParameter("status"));
        r.setRoleId(parseInt(request.getParameter("role_id")));

        return r;
    }

    private Integer parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
