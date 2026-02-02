<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đổi mật khẩu</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #ff7a18, #ffb347);
                margin: 0;
                padding: 0;
            }

            .container {
                width: 420px;
                margin: 90px auto;
                background: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.25);
            }

            h2 {
                text-align: center;
                color: #ff7a18;
                margin-bottom: 25px;
            }

            label {
                font-weight: bold;
                color: #ff7a18;
                margin-top: 12px;
                display: block;
            }

            input[type="password"] {
                width: 100%;
                padding: 11px;
                margin-top: 6px;
                border: 1px solid #ffd2b3;
                border-radius: 6px;
                outline: none;
            }

            input[type="password"]:focus {
                border-color: #ff7a18;
                box-shadow: 0 0 5px rgba(255,122,24,0.5);
            }

            button {
                width: 100%;
                margin-top: 25px;
                padding: 13px;
                background: linear-gradient(to right, #ff7a18, #ff9f43);
                color: white;
                font-size: 16px;
                font-weight: bold;
                border: none;
                border-radius: 25px;
                cursor: pointer;
                transition: 0.3s;
            }

            button:hover {
                background: linear-gradient(to right, #e96b12, #ff7a18);
                transform: translateY(-1px);
            }

            .error {
                background: #ffe5e5;
                color: #c0392b;
                border-left: 4px solid #e74c3c;
                padding: 10px;
                margin-top: 18px;
                border-radius: 6px;
            }

            .success {
                background: #eaffea;
                color: #2e7d32;
                border-left: 4px solid #4caf50;
                padding: 10px;
                margin-top: 18px;
                border-radius: 6px;
            }

            .back {
                text-align: center;
                margin-top: 18px;
            }

            .back a {
                color: #ff7a18;
                font-weight: bold;
                text-decoration: none;
            }

            .back a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>🔐 Đổi mật khẩu</h2>

            <form action="${pageContext.request.contextPath}/change-password" method="post">

                <label>Mật khẩu hiện tại</label>
                <input type="password" name="currentPassword" required>

                <label>Mật khẩu mới</label>
                <input type="password" name="newPassword" required>

                <label>Xác nhận mật khẩu mới</label>
                <input type="password" name="confirmPassword" required>

                <button type="submit">Cập nhật mật khẩu</button>
            </form>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success">${success}</div>
            </c:if>

            <div class="back">
<<<<<<< HEAD
                <a href="${pageContext.request.contextPath}/reader/home">← Quay lại trang chủ</a>
            </div>
=======
                <a href="#" onclick="window.history.back(); return false;">
                    ← Quay lại trang trước
                </a>
            </div>

>>>>>>> master
        </div>

    </body>
</html>
