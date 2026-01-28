/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.librarian;

import dal.BorrowDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "LibrarianDashboardServlet", urlPatterns = {"/librarian/dashboard"})
public class LibrarianDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        BorrowDBContext db = new BorrowDBContext();
        
        // Chỉ lấy số lượng để hiện lên Dashboard cho nhẹ
        int totalActive = db.countActiveBorrows();
        
        request.setAttribute("totalActive", totalActive);
        
        // Chuyển sang file JSP dashboard
        request.getRequestDispatcher("/view/librarian/dashboard.jsp").forward(request, response);
    }
}