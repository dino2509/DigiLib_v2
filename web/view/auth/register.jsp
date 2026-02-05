<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Register | Digital Library</title>

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
            .register-card {
                width: 440px;
                background: #ffffff;
                padding: 38px 36px;
                border-radius: 22px;
                border: 1px solid #fed7aa;
                box-shadow: 0 25px 60px rgba(0,0,0,0.12);
            }

            h1 {
                margin: 0;
                font-size: 26px;
                font-weight: 800;
                color: #c2410c;
                text-align: center;
            }

            .subtitle {
                margin-top: 6px;
                margin-bottom: 28px;
                font-size: 14px;
                color: #6b7280;
                text-align: center;
            }

            /* ===== FORM ===== */
            .form-group {
                margin-bottom: 14px;
            }

            label {
                font-size: 13px;
                font-weight: 600;
                color: #374151;
                display: block;
                margin-bottom: 6px;
            }

            input {
                width: 100%;
                height: 48px;
                padding: 0 16px;
                border-radius: 14px;
                border: 1px solid #e5e7eb;
                background: #eff6ff;
                font-size: 14px;
            }

            input:focus {
                outline: none;
                border-color: #f97316;
                box-shadow: 0 0 0 2px rgba(249,115,22,0.18);
                background: #fff;
            }

            /* ===== BUTTON ===== */
            .btn-register {
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
                transition: all 0.2s ease;
            }

            .btn-register:hover {
                transform: translateY(-1px);
                box-shadow: 0 10px 25px rgba(234,88,12,0.45);
            }

            /* ===== ERROR ===== */
            .error {
                margin-top: 14px;
                color: #dc2626;
                font-size: 13px;
                font-weight: 600;
                text-align: center;
            }

            /* ===== FOOTER ===== */
            .login-link {
                margin-top: 22px;
                text-align: center;
                font-size: 13px;
            }

            .login-link a {
                color: #f97316;
                font-weight: 600;
                text-decoration: none;
            }

            .login-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>

        <div class="register-card">
            <h1>Digital Library</h1>
            <div class="subtitle">Tạo tài khoản mới</div>

            <form action="register" method="post">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text"
                           name="fullName"
                           value="${param.fullName}"
                           required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email"
                           name="email"
                           value="${param.email}"
                           required>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password"
                           name="password"
                           required>
                </div>

                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password"
                           name="confirm"
                           required>
                </div>

                <div class="form-group">
                    <label>Phone</label>
                    <input type="text"
                           name="phone"
                           value="${param.phone}"
                           required>
                </div>

                <button type="submit" class="btn-register">
                    Create Account
                </button>
            </form>

            <!-- ERROR MESSAGE -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="error"><%= error %></div>
            <%
                }
            %>

            <div class="login-link">
                Already have an account?
                <a href="login">Login here</a>
            </div>
        </div>

    </body>
</html>
