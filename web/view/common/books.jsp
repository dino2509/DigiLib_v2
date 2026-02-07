<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Books - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
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

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">📚 Danh sách sách</h4>
        <div class="text-muted small">Tổng: ${total}</div>
    </div>

    <form class="row g-2 mb-3" action="${pageContext.request.contextPath}/books" method="get">
        <div class="col-md-5">
            <input class="form-control" name="q" value="${q}" placeholder="Tìm theo tên sách...">
        </div>

        <div class="col-md-4">
            <select class="form-select" name="categoryId">
                <option value="">-- Thể loại --</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.category_id}" ${c.category_id == categoryId ? 'selected' : ''}>
                        ${c.category_name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3 d-grid">
            <button class="btn btn-warning">Lọc / Tìm</button>
        </div>
    </form>

    <c:choose>
        <c:when test="${empty books}">
            <div class="alert alert-light border">Không có sách phù hợp.</div>
        </c:when>
        <c:otherwise>
            <div class="book-list">
                <c:forEach var="b" items="${books}">
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

                        <a href="books/detail?id=${b.bookId}">Xem chi tiết</a>
                    </div>
                
                </c:forEach>
            </div>

            <c:if test="${totalPages > 1}">
                <nav>
                    <ul class="pagination justify-content-center">
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == page ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/books?q=${q}&categoryId=${categoryId}&page=${p}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </nav>
            </c:if>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
