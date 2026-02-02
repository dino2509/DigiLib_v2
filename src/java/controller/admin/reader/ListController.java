package controller.admin.reader;

import dal.ReaderDBContext;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/readers/list")
public class ListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ReaderDBContext readerDB = new ReaderDBContext();
        ArrayList<Reader> readers = readerDB.list();

        request.setAttribute("readers", readers);
        request.getRequestDispatcher("../../view/admin/reader/list.jsp").forward(request, response);
    }
}
