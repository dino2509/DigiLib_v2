/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.librarian.borrow;

import dal.BorrowRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Employee;

@WebServlet("/librarian/process-borrow-request")
public class ProcessBorrowRequestController extends HttpServlet {

    BorrowRequestDBContext brDB = new BorrowRequestDBContext();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String action = request.getParameter("action");

        Employee emp = (Employee) request.getSession().getAttribute("employee");

        if (action.equals("approve")) {
            brDB.approveRequest(requestId, emp.getEmployeeId());
        }

        if (action.equals("reject")) {
            String note = request.getParameter("note");
            brDB.rejectRequest(requestId, emp.getEmployeeId(), note);
        }

        response.sendRedirect("borrow-requests");
    }
}
