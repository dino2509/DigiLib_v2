/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.librarian;

/**
 *
 * @author TuanBro
 */

import dal.BorrowDBContext;
import model.BorrowedBookDTO;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BorrowListServlet", urlPatterns = {"/librarian/borrows"})
public class BorrowListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        BorrowDBContext db = new BorrowDBContext();
        
        // Lấy danh sách đầy đủ
        ArrayList<BorrowedBookDTO> list = db.getActiveBorrows();
        
        request.setAttribute("borrowList", list);
        
        // Chuyển sang file JSP danh sách
        request.getRequestDispatcher("/view/librarian/borrow-list.jsp").forward(request, response);
    }
}