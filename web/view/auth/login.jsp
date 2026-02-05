<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Login | Digital Library</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #fff7ed, #ffedd5);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ===== CARD ===== */
        .login-card {
            width: 420px;
            background: #fff;
            padding: 38px 36px;
            border-radius: 22px;
            border: 1px solid #fed7aa;
            box-shadow: 0 25px 60px rgba(0,0,0,0.12);
            text-align: center;
        }

        h1 {
            margin: 0;
            font-size: 26px;
            font-weight: 800;
            color: #c2410c;
        }

        .subtitle {
            margin-top: 6px;
            margin-bottom: 28px;
            font-size: 14px;
            color: #6b7280;
        }

        /* ===== FORM ===== */
        .form-group {
            text-align: left;
            margin-bottom: 16px;
        }

        label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            display: block;
            margin-bottom: 6px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            height: 48px;
            padding: 0 16px;
            border-radius: 14px;
            border: 1px solid #e5e7eb;
            background: #eff6ff; /* xanh nhạt */
            font-size: 14px;
        }

        input:focus {
            outline: none;
            border-color: #f97316;
            box-shadow: 0 0 0 2px rgba(249,115,22,0.18);
            background: #fff;
        }

        /* ===== LOGIN BUTTON ===== */
        .btn-login {
            width: 100%;
            height: 48px;
            margin-top: 18px;
            border: none;
            border-radius: 999px;
            background: linear-gradient(135deg, #fb923c, #ea580c);
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 25px rgba(234,88,12,0.45);
        }

        /* ===== DIVIDER ===== */
        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 26px 0 20px;
            font-size: 13px;
            color: #9ca3af;
        }

        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background: #fed7aa;
        }

        /* ===== GOOGLE ===== */
        .google-btn {
            width: 100%;
            height: 46px;
            border-radius: 999px;
            border: 1px solid #e5e7eb;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .google-btn img {
            width: 18px;
        }

        .google-btn:hover {
            background: #f9fafb;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
        }

        /* ===== ERROR ===== */
        .error {
            margin-top: 14px;
            color: #dc2626;
            font-size: 13px;
            font-weight: 600;
        }

        /* ===== LINKS ===== */
        .links {
            margin-top: 20px;
            font-size: 13px;
        }

        .links a {
            color: #f97316;
            font-weight: 600;
            text-decoration: none;
            margin: 0 6px;
        }

        .links a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="login-card">
    <h1>Digital Library</h1>
    <div class="subtitle">Đăng nhập để tiếp tục</div>

    <!-- LOGIN FORM -->
    <form action="login" method="post">
        <input type="hidden" name="type" value="local"/>

        <div class="form-group">
            <label>Email</label>
            <input type="text" name="email" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <button type="submit" class="btn-login">
            🔐 Login
        </button>
    </form>

    <div class="divider">hoặc</div>

    <!-- GOOGLE LOGIN -->
    <a class="google-btn"
       href="https://accounts.google.com/o/oauth2/v2/auth?client_id=687015797507-toh2purq11gr7040ftn84s54b0taed3b.apps.googleusercontent.com&redirect_uri=http://localhost:9999/SWP_Project/login-google&response_type=code&scope=openid%20email%20profile">
        <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg">
        Login with Google
    </a>

    <!-- ERROR -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error"><%= error %></div>
    <%
        }
    %>

    <!-- LINKS -->
    <div class="links">
        <a href="forgot-password">Forgot password?</a> |
        <a href="register">Create account</a>
    </div>
</div>

</body>
</html>
