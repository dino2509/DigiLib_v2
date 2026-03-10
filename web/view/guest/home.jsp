<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Digital Library - Trang chủ</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                background-color: #fdf2e9;
            }

            /* ===== HEADER ===== */
            header {
                background-color: #ff7a18;
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            header h2 {
                margin: 0;
            }

            header a {
                color: white;
                text-decoration: none;
                margin-left: 20px;
                font-weight: 500;
            }

            header a:hover {
                text-decoration: underline;
            }

            /* ===== BANNER ===== */
            .banner {
                background: linear-gradient(to right, #ff7a18, #ff9f43);
                color: white;
                padding: 70px 30px;
                text-align: center;
            }

            .banner h1 {
                margin-bottom: 10px;
            }

            /* ===== CONTAINER ===== */
            .container {
                padding: 40px 60px;
            }

            .container h2 {
                color: #e65c00;
                margin-bottom: 20px;
            }

            /* ===== BOOK LIST ===== */
            .book-list {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 25px;
            }

            .book-card {
                background: white;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                text-align: center;

                display: flex;
                flex-direction: column;
                height: 100%;
                transition: transform 0.2s ease;
            }

            .book-card:hover {
                transform: translateY(-5px);
            }

            .book-card img {
                width: 120px;
                height: 170px;
                object-fit: cover;
                margin: 0 auto 10px;
                border-radius: 4px;
            }

            .book-card h3 {
                font-size: 16px;
                min-height: 44px; /* giữ card cao đều */
                margin: 10px 0;
            }

            .book-card p {
                margin: 5px 0 15px;
                font-weight: bold;
                color: #444;
            }

            .book-card a {
                margin-top: auto; /* ĐẨY NÚT XUỐNG ĐÁY */
                background: #ff7a18;
                color: white;
                padding: 8px 14px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
            }

            .book-card a:hover {
                background: #e8650f;
            }

            /* ===== FOOTER ===== */
            footer {
                background-color: #ff7a18;
                color: white;
                text-align: center;
                padding: 15px;
                margin-top: 40px;
            }
        </style>
    </head>

    <body>


        <header>
            <h2>📚 Digital Library</h2>
            <nav>
                <a href="home">Trang chủ</a>
                <a href="books">Danh sách sách</a>
                <a href="login">Đăng nhập</a>
                <a href="register">Đăng ký</a>
            </nav>
        </header>
        <form action="${pageContext.request.contextPath}/home/search" method="get">
            <input type="text" name="keyword" value="${param.keyword}" />
                    


            <button type="submit">
                Search
            </button>
        </form>


        <section class="banner">
            <h1>Thư viện số dành cho mọi người</h1>
            <p>Khám phá – Đọc online – Mượn sách dễ dàng</p>
        </section>

        <div class="container">
            <h2>Sách nổi bật</h2>

            <div class="book-list">
                <c:forEach items="${books}" var="b">
                    <div class="book-card">
                        <img src="${pageContext.request.contextPath}/${empty b.coverUrl 
                                    ? 'assets/images/no-cover.png' 
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
