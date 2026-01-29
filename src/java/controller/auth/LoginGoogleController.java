package controller.auth;

import dal.ReaderAccountDBContext;
import dal.ReaderDBContext;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Reader;
import model.ReaderAccount;

import org.json.JSONObject;

@WebServlet("/login-google")
public class LoginGoogleController extends HttpServlet {

    private static final String CLIENT_ID = "687015797507-toh2purq11gr7040ftn84s54b0taed3b.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI
            = "http://localhost:9999/SWP_Project/login-google";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect("login");
            return;
        }

        // 1. Đổi code -> access token
        String accessToken = getAccessToken(code);

        // 2. Lấy thông tin user Google
        JSONObject userInfo = getUserInfo(accessToken);

        String email = userInfo.getString("email");
        String fullName = userInfo.getString("name");
        String googleId = userInfo.getString("id");
        String avatar = userInfo.optString("picture");

        ReaderDBContext readerDB = new ReaderDBContext();
        ReaderAccountDBContext accountDB = new ReaderAccountDBContext();

        // 3. Check account google tồn tại chưa
        Reader reader = accountDB.getReaderByGoogleId(googleId);

        if (reader == null) {
            // 4. Nếu chưa có -> tạo Reader mới
            reader = new Reader();
            reader.setEmail(email);
            reader.setFullName(fullName);
            reader.setAvatar(avatar);
            reader.setRoleId(4); // USER
            reader.setStatus("ACTIVE");

            int readerId = readerDB.insertId(reader);

            // 5. Tạo Reader_Account
            
            
            accountDB.insertGoogle(readerId, "google", googleId);
            reader.setReaderId(readerId);
        }

        // 6. Login thành công
        HttpSession session = request.getSession();
        session.setAttribute("user", reader);

        response.sendRedirect(request.getContextPath()+"/reader/home");
    }

    // ================== GOOGLE API ==================
    private String getAccessToken(String code) throws IOException {
        URL url = new URL("https://oauth2.googleapis.com/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        String params
                = "client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&code=" + code
                + "&grant_type=authorization_code"
                + "&redirect_uri=" + REDIRECT_URI;

        OutputStream os = conn.getOutputStream();
        os.write(params.getBytes());
        os.flush();

        BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );
        StringBuilder json = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            json.append(line);
        }

        JSONObject obj = new JSONObject(json.toString());
        return obj.getString("access_token");
    }

    private JSONObject getUserInfo(String accessToken) throws IOException {
        URL url = new URL(
                "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken
        );
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );
        StringBuilder json = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            json.append(line);
        }

        return new JSONObject(json.toString());
    }
}
