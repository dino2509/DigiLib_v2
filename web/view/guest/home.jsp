<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Digital Library - Trang chủ</title>

        <style>
            :root {
                --primary: #ff7a18;
                --primary-dark: #e8650f;
                --bg: #fdf2e9;
                --text: #333;
            }

            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: "Segoe UI", Arial, sans-serif;
                background-color: var(--bg);
                color: var(--text);
            }

            /* ===== HEADER ===== */
            header {
                background: var(--primary);
                color: white;
                padding: 14px 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            header h2 {
                margin: 0;
                font-size: 22px;
            }

            nav {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            nav a {
                color: white;
                text-decoration: none;
                font-weight: 500;
            }

            nav a:hover {
                text-decoration: underline;
            }

            /* ===== SEARCH ===== */
            .search-box {
                display: flex;
                gap: 6px;
            }

            .search-box input {
                padding: 6px 10px;
                border-radius: 6px;
                border: none;
                outline: none;
            }

            .search-box button {
                background: white;
                color: var(--primary);
                border: none;
                padding: 6px 12px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
            }

            .search-box button:hover {
                background: #ffe4d1;
            }

            /* ===== BANNER ===== */
            .banner {
                background: linear-gradient(to right, var(--primary), #ff9f43);
                color: white;
                padding: 80px 20px;
                text-align: center;
            }

            .banner h1 {
                font-size: 36px;
                margin-bottom: 10px;
            }

            .banner p {
                font-size: 18px;
                opacity: 0.95;
            }

            /* ===== CONTAINER ===== */
            .container {
                padding: 50px 60px;
            }

            .container h2 {
                color: var(--primary-dark);
                margin-bottom: 30px;
                text-align: center;
                font-size: 28px;
            }

            /* ===== BOOK LIST ===== */
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
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .book-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 12px 25px rgba(0,0,0,0.12);
            }

            .book-card img {
                width: 130px;
                height: 180px;
                object-fit: cover;
                margin: 0 auto 12px;
                border-radius: 6px;
            }

            .book-card h3 {
                font-size: 16px;
                min-height: 44px;
                margin: 8px 0;
            }

            .book-card p {
                font-weight: 600;
                margin: 6px 0 14px;
                color: #555;
            }

            .book-card a {
                margin-top: auto;
                background: var(--primary);
                color: white;
                padding: 9px 14px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 500;
            }

            .book-card a:hover {
                background: var(--primary-dark);
            }

            /* ===== FOOTER ===== */
            footer {
                background: var(--primary);
                color: white;
                text-align: center;
                padding: 16px;
                margin-top: 60px;
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 768px) {
                header {
                    flex-direction: column;
                    gap: 10px;
                }

                .container {
                    padding: 30px 20px;
                }

                .banner h1 {
                    font-size: 28px;
                }
            }
        </style>
    </head>

    <body>

        <header>
            <h2>📚 Digital Library</h2>

            <nav>
                <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/books">Sách</a>
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register">Đăng ký</a>

                <form class="search-box"
                      action="${pageContext.request.contextPath}/home/search"
                      method="get">
                    <input type="text" name="keyword"
                           placeholder="Tìm sách..."
                           value="${param.keyword}">
                    <button type="submit">🔍</button>
                </form>
            </nav>
        </header>

        <section class="banner">
            <h1>Thư viện số dành cho mọi người</h1>
            <p>Khám phá • Đọc online • Mượn sách dễ dàng</p>
        </section>

        <div class="container">
            <h2>Sách nổi bật</h2>

            <div class="book-list">
                <c:forEach items="${books}" var="b">
                    <div class="book-card">
                        <img class="card-img-top book-cover"
                             src="${pageContext.request.contextPath}/img/book/${empty b.coverUrl 
                                    ? 'no-cover.png' 
                                    : b.coverUrl}"
                             alt="${b.title}">
                        <h3>${b.title}</h3>

                        <p>
                            <c:choose>
                                <c:when test="${b.price == null || b.price == 0}">
                                    Miễn phí
                                </c:when>
                                <c:otherwise>
                                    ${b.price} VND
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <a href="book-detail?id=${b.bookId}">Xem chi tiết</a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <footer>
            <p>© 2026 Digital Library | JSP & Servlet</p>
        </footer>

    </body>
</html>
