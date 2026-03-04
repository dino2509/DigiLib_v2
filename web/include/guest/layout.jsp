<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${pageTitle != null ? pageTitle : "Digital Library"}</title>

        <style>
            :root {
                --primary: #ff7a00;
                --primary-dark: #e56700;
                --light-orange: #fff4ec;
                --dark: #1e293b;
                --gray: #f8fafc;
                --text: #334155;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', sans-serif;
                background: var(--gray);
                color: var(--text);
            }

            /* ===== HEADER ===== */
            .header {
                background: white;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                padding: 16px 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .logo {
                font-size: 22px;
                font-weight: 800;
                color: var(--primary);
            }

            .nav-links {
                display: flex;
                align-items: center;
                gap: 30px;
            }

            .nav-links a {
                text-decoration: none;
                color: var(--dark);
                font-weight: 500;
                transition: 0.3s;
            }

            .nav-links a:hover {
                color: var(--primary);
            }

            /* ===== AUTH BUTTONS ===== */
            .auth-buttons a {
                text-decoration: none;
                padding: 8px 16px;
                border-radius: 6px;
                font-weight: 500;
                transition: 0.3s;
                margin-left: 10px;
            }

            .btn-login {
                border: 1px solid var(--primary);
                color: var(--primary);
            }

            .btn-login:hover {
                background: var(--primary);
                color: white;
            }

            .btn-register {
                background: var(--primary);
                color: white;
            }

            .btn-register:hover {
                background: var(--primary-dark);
            }

            /* ===== MAIN CONTENT ===== */
            .container {
                max-width: 1200px;
                margin: 40px auto;
                padding: 0 20px;
            }

            /* ===== FOOTER ===== */
            .footer {
                background: var(--primary);
                color: white;
                text-align: center;
                padding: 20px;
                margin-top: 60px;
                font-size: 14px;
            }

            .footer span {
                font-weight: bold;
            }

            @media (max-width: 992px) {
                .header {
                    flex-direction: column;
                    gap: 15px;
                }

                .nav-links {
                    flex-wrap: wrap;
                    justify-content: center;
                }
            }
            /* ===== BANNER ===== */
            .banner {
                background: linear-gradient(to right, var(--primary), #ff9f43);
                color: white;
                padding: 80px 20px;
                text-align: center;
                border-radius: 12px;
                margin-bottom: 40px;
            }

            .banner h1 {
                font-size: 36px;
                margin-bottom: 10px;
            }

            /* ===== BOOK LIST ===== */
            .section-title {
                color: var(--primary-dark);
                margin-bottom: 30px;
                text-align: center;
                font-size: 28px;
            }

            .book-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 30px;
            }

            .book-card {
                background: white;
                border-radius: 12px;
                padding: 16px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.08);
                display: flex;
                flex-direction: column;
                text-align: center;
                transition: 0.2s ease;
            }

            .book-card:hover {
                transform: translateY(-6px);
            }

            .book-cover {
                width: 130px;
                height: 180px;
                object-fit: cover;
                margin: 0 auto 12px;
                border-radius: 6px;
            }

            .btn-detail {
                margin-top: auto;
                background: var(--primary);
                color: white;
                padding: 9px 14px;
                border-radius: 8px;
                text-decoration: none;
            }
            /* ===== HOME SEARCH ===== */
            .home-search {
                display: flex;
                justify-content: center;
                margin: 40px 0;
            }

            .home-search form {
                display: flex;
                width: 100%;
                max-width: 500px;
            }

            .home-search input {
                flex: 1;
                padding: 12px 16px;
                border-radius: 8px 0 0 8px;
                border: 1px solid #ddd;
                outline: none;
                font-size: 14px;
            }

            .home-search input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 2px rgba(255,122,24,0.15);
            }

            .home-search button {
                background: var(--primary);
                color: white;
                border: none;
                padding: 0 20px;
                border-radius: 0 8px 8px 0;
                cursor: pointer;
                font-weight: 600;
                transition: 0.2s;
            }

            .home-search button:hover {
                background: var(--primary-dark);
            }

            .logo a{
                font-size:22px;
                font-weight:600;
                text-decoration:none;
                color:#f97316;
                display:flex;
                align-items:center;
                gap:6px;
            }

            .logo a:hover{
                color:#ea580c;
            }
        </style>
    </head>

    <body>

        <!-- ===== HEADER ===== -->
        <div class="header">

            <!-- Logo -->

            <div class="logo">
                <a href="${pageContext.request.contextPath}/home">
                    📚 Digital Library
                </a>
            </div>

            <!-- Navigation -->
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/books">Sách</a>
                <a href="${pageContext.request.contextPath}/advanced-search">Tìm kiếm nâng cao</a>
                <a href="${pageContext.request.contextPath}/categories">Thể loại</a>
                <a href="${pageContext.request.contextPath}/about">Giới thiệu</a>
            </div>

            <!-- Auth Buttons -->
            <div class="auth-buttons">
                <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
            </div>

        </div>

        <!-- ===== PAGE CONTENT ===== -->
        <div class="container">
            <jsp:include page="${contentPage}" />
        </div>

        <!-- ===== FOOTER ===== -->
        <div class="footer">
            © 2026 <span>Digital Library</span>. All rights reserved.
        </div>

    </body>
</html>