/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package controller.guest;

import dal.BookDBContext;
import dal.AuthorDBContext;
import dal.CategoryDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Book;
import model.Author;
import model.Category;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(urlPatterns = "/home/search")
public class SearchController extends HttpServlet {

    private BookDBContext bookDB = new BookDBContext();
   

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LẤY THAM SỐ SEARCH =====
        String keyword = request.getParameter("keyword");
       
//        String keyResult = "";
        
       
        String keyResult = keyword.trim().replaceAll("\\s+", " ").toLowerCase();
        
       
//        String[] keywords = normalized.split(" ");

        
//        StringBuilder sb = new StringBuilder();
//        for (String key : keywords) {
//            sb.append(key).append(" ");
//        }

//        keyResult = sb.toString().trim();
       
        

        // ===== SEARCH BOOK =====
        ArrayList<Book> books = bookDB.searchByKeyword(
                keyResult
                );

        // ===== LOAD DATA CHO FILTER =====
        
        // ===== SET ATTRIBUTE =====
        request.setAttribute("books", books);
    

        request.setAttribute("keyword", keyword);
     

        // ===== FORWARD =====
        

        request.getRequestDispatcher("../view/guest/home.jsp")
                .forward(request, response);

    }
}

