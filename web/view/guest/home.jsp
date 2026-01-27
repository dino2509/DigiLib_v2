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

        header {
            background-color: #ff7a18;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: 500;
        }

        .banner {
            background: linear-gradient(to right, #ff7a18, #ff9f43);
            color: white;
            padding: 70px 30px;
            text-align: center;
        }

        .container {
            padding: 40px 60px;
        }

        .container h2 {
            color: #e65c00;
        }

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
        }

        .book-card img {
            width: 120px;
            height: 170px;
            object-fit: cover;
            margin-bottom: 10px;
        }

        .book-card a {
            display: inline-block;
            margin-top: 10px;
            background: #ff7a18;
            color: white;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
        }

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

<section class="banner">
    <h1>Thư viện số dành cho mọi người</h1>
    <p>Khám phá – Đọc online – Mượn sách dễ dàng</p>
</section>

<div class="container">
    <h2>Sách nổi bật</h2>

    <!-- DEBUG (xóa khi xong) -->
    <p style="color:red">DEBUG books size: ${books.size()}</p>

    <div class="book-list">
        <c:forEach items="${books}" var="b">
            <div class="book-card">
                <img src="${pageContext.request.contextPath}/${b.coverUrl}" alt="${b.title}">
                <h3>${b.title}</h3>

                <p>
                    <c:if test="${b.price == null || b.price == 0}">
                        Miễn phí
                    </c:if>
                    <c:if test="${b.price != null && b.price > 0}">
                        ${b.price} VND
                    </c:if>
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
