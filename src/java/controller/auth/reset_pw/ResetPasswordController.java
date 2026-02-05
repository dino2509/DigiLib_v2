
import dal.EmployeeDBContext;
import dal.ReaderDBContext;
import dal.ReaderDBContext.ResetInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import util.PasswordUtil;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");
        ReaderDBContext rdb = new ReaderDBContext();

        if (!rdb.isValidToken(token)) {
            req.setAttribute("error", "Link không hợp lệ hoặc đã hết hạn");
            req.getRequestDispatcher("view/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("token", token);
        req.getRequestDispatcher("view/auth/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");
        String password = req.getParameter("password");
        EmployeeDBContext edb = new EmployeeDBContext();
        ReaderDBContext rdb = new ReaderDBContext();
        ResetInfo info = rdb.getResetInfo(token);

        if (info == null) {
            req.setAttribute("error", "Token không hợp lệ");
            req.getRequestDispatcher("view/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        String hash = PasswordUtil.hash(password);

        if (info.getUserType().equals("READER")) {
            
        }
        rdb.updateReaderPassword(info.getUserId(), hash);
        edb.updateEmployeePassword(info.getUserId(), hash);
        rdb.markTokenUsed(token);

        req.setAttribute("msg", "Đổi mật khẩu thành công");
        req.getRequestDispatcher("view/auth/login.jsp").forward(req, resp);
    }

}
