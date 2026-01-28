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
        String keyword = request.getParameter("keyword");
        String searchType = request.getParameter("searchType"); // Lấy loại tìm kiếm
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Gọi hàm tìm kiếm mới với 2 tham số
            list = db.searchBorrows(keyword.trim(), searchType);
        } else {
            list = db.getActiveBorrows();
        }
        
        request.setAttribute("borrowList", list);
        request.setAttribute("currentKeyword", keyword);
        request.setAttribute("currentType", searchType);
        
        // Chuyển sang file JSP danh sách
        request.getRequestDispatcher("/view/librarian/borrow-list.jsp").forward(request, response);
    }

}
