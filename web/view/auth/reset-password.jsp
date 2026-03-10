<%@page contentType="text/html" pageEncoding="UTF-8"%>

<form action="reset-password" method="post" class="reset-form">

    <input type="hidden" name="token" value="${token}">

    <h2>🔐 Đặt lại mật khẩu</h2>
    <p class="desc">
        Vui lòng nhập mật khẩu mới cho tài khoản của bạn
    </p>

    <div class="form-group">
        <input type="password"
               name="password"
               required
               placeholder="🔑 Mật khẩu mới">
    </div>

    <button type="submit" class="btn-submit">
        Đổi mật khẩu
    </button>

    <c:if test="${not empty error}">
        <p class="msg error">${error}</p>
    </c:if>

    <c:if test="${not empty msg}">
        <p class="msg success">${msg}</p>
    </c:if>

    <div class="back-link">
        <a href="login">⬅ Quay lại đăng nhập</a>
    </div>
</form>

<style>
    .reset-form {
        max-width: 420px;
        margin: 80px auto;
        background: #fff;
        padding: 32px 30px;
        border-radius: 16px;
        border: 1px solid #fed7aa;
        box-shadow: 0 18px 40px rgba(0,0,0,0.08);
        text-align: center;
        font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }

    .reset-form h2 {
        margin-bottom: 8px;
        color: #c2410c;
        font-weight: 700;
    }

    .reset-form .desc {
        font-size: 14px;
        color: #6b7280;
        margin-bottom: 24px;
    }

    .form-group input {
        width: 100%;
        height: 44px;
        padding: 0 14px;
        border-radius: 10px;
        border: 1px solid #e5e7eb;
        font-size: 14px;
    }

    .form-group input:focus {
        outline: none;
        border-color: #f97316;
        box-shadow: 0 0 0 2px rgba(249,115,22,0.15);
    }

    .btn-submit {
        width: 100%;
        margin-top: 16px;
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        border: none;
        border-radius: 999px;
        padding: 10px 0;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .btn-submit:hover {
        transform: translateY(-1px);
        box-shadow: 0 8px 20px rgba(234,88,12,0.45);
    }

    .msg {
        margin-top: 14px;
        font-size: 13px;
        font-weight: 600;
    }

    .msg.error {
        color: #dc2626;
    }

    .msg.success {
        color: #16a34a;
    }

    .back-link {
        margin-top: 18px;
    }

    .back-link a {
        font-size: 13px;
        color: #f97316;
        text-decoration: none;
        font-weight: 600;
    }

    .back-link a:hover {
        text-decoration: underline;
    }

</style>
