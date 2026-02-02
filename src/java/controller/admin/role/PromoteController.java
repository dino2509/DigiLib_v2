/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller.admin.role;

import dal.EmployeeDBContext;
import dal.ReaderDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Reader;


@WebServlet("/admin/roles/promote")
public class PromoteController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int readerId = Integer.parseInt(request.getParameter("readerId"));

        ReaderDBContext rdb = new ReaderDBContext();
        EmployeeDBContext edb = new EmployeeDBContext();

        Reader r = rdb.get(readerId);

        if (r != null) {
            // tránh tạo trùng employee
            if (!edb.existsByEmail(r.getEmail())) {
                edb.insertFromReader(r, 2); // 2 = LIBRARIAN
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/readers");
    }
}

