<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Digital Library - Trang chủ</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f5f5f5;
        }

        header {
            background-color: #2c3e50;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
        }

        .banner {
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: white;
            padding: 60px 30px;
            text-align: center;
        }

        .search-box {
            margin-top: 20px;
        }

        .search-box input {
            width: 300px;
            padding: 10px;
            border-radius: 5px;
            border: none;
        }

        .search-box button {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            background-color: #2c3e50;
            color: white;
            cursor: pointer;
        }

        .container {
            padding: 30px;
        }

        .book-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .book-card {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }

        .book-card img {
            width: 120px;
            height: 170px;
            object-fit: cover;
            margin-bottom: 10px;
        }

        .book-card h3 {
            font-size: 16px;
            margin: 5px 0;
        }

        .book-card p {
            font-size: 14px;
            color: #666;
        }

        .book-card a {
            display: inline-block;
            margin-top: 10px;
            text-decoration: none;
            color: white;
            background-color: #3498db;
            padding: 8px 12px;
            border-radius: 5px;
        }

        footer {
            background-color: #2c3e50;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 30px;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<header>
    <h2>📚 Digital Library</h2>
    <nav>
        <a href="home">Trang chủ</a>
        <a href="books">Sách</a>
        <a href="my-borrow">Sách đã mượn</a>
        <a href="profile">Tài khoản</a>
        <a href="logout">Đăng xuất</a>
    </nav>
</header>

<!-- BANNER -->
<section class="banner">
    <h1>Chào mừng đến với Thư viện số</h1>
    <p>Đọc sách online – Mượn sách – Mua sách dễ dàng</p>

    <form class="search-box" action="search" method="get">
        <input type="text" name="keyword" placeholder="Tìm kiếm sách, tác giả...">
        <button type="submit">🔍 Tìm kiếm</button>
    </form>
</section>

<!-- BOOK LIST -->
<div class="container">
    <h2>Sách mới nhất</h2>

    <div class="book-list">
        <c:forEach items="${books}" var="b">
            <div class="book-card">
                <img src="${b.coverImage}" alt="${b.title}">
                <h3>${b.title}</h3>
                <p>${b.author}</p>
                <p>
                    <c:if test="${b.price == 0}">
                        Miễn phí
                    </c:if>
                    <c:if test="${b.price > 0}">
                        ${b.price} VND
                    </c:if>
                </p>
                <a href="book-detail?id=${b.bookId}">Xem chi tiết</a>
            </div>
        </c:forEach>
    </div>
</div>

<!-- FOOTER -->
<footer>
    <p>© 2026 Digital Library | Powered by JSP & Servlet</p>
</footer>

</body>
</html>
