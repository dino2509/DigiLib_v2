<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>DigiLib | Reader Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container">

    <!-- 1. Welcome / Summary -->
    <section class="welcome">
        <h2>Xin chào, ${user.fullName}</h2>

        <div class="stats">
            <div class="stat">📘 Đang mượn: <strong>${borrowedCount}</strong></div>
            <div class="stat">⏰ Sắp hết hạn: <strong>${dueSoonCount}</strong></div>
            <div class="stat">📚 Đã đọc: <strong>${readTotal}</strong></div>
        </div>
    </section>

    <!-- 2. Continue Reading -->
    <section>
        <h3>📖 Continue Reading</h3>

        <div class="book-row">
            <c:forEach var="rp" items="${continueReading}">
                <div class="book-card">
                    <img src="/images/books/${rp.book.cover}" alt="">
                    <h4>${rp.book.title}</h4>
                    <p>${rp.book.author}</p>
                    <div class="progress">
                        <div style="width:${rp.progress}%"></div>
                    </div>
                    <a class="btn" href="/reader/books/${rp.book.id}">Continue</a>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- 3. Recommended -->
    <section>
        <h3>✨ Recommended for You</h3>

        <div class="book-grid">
            <c:forEach var="b" items="${recommendedBooks}">
                <div class="book-card">
                    <img src="/images/books/${b.cover}" alt="">
                    <h4>${b.title}</h4>
                    <p>⭐ ${b.rating}</p>
                    <a href="/reader/books/${b.id}">View</a>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- 4. Quick Navigation -->
    <section class="quick-nav">
        <a href="/reader/books">📚 Browse Books</a>
        <a href="/reader/categories">🗂 Categories</a>
        <a href="/reader/favorites">❤️ Favorites</a>
        <a href="/reader/borrowed">📖 Borrowed</a>
    </section>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
