<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>/* ===== BOOK DETAIL ===== */
    .book-detail {
        margin-top: 40px;
    }

    .detail-wrapper {
        display: flex;
        gap: 40px;
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.08);
    }

    .detail-cover img {
        width: 250px;
        border-radius: 10px;
    }

    .detail-info h1 {
        margin-bottom: 15px;
        color: var(--primary-dark);
    }

    .author, .category {
        margin-bottom: 8px;
    }

    .price {
        font-size: 20px;
        font-weight: 700;
        margin: 15px 0;
    }

    .free {
        color: green;
    }

    .summary {
        margin-top: 20px;
    }

    .summary h3 {
        margin-bottom: 10px;
    }

    .actions {
        margin-top: 25px;
        display: flex;
        gap: 15px;
    }

    .btn-primary {
        background: var(--primary);
        color: white;
        padding: 10px 18px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
    }

    .btn-primary:hover {
        background: var(--primary-dark);
    }

    .btn-outline {
        border: 2px solid var(--primary);
        color: var(--primary);
        padding: 8px 16px;
        border-radius: 8px;
        text-decoration: none;
    }

    .btn-outline:hover {
        background: var(--primary);
        color: white;
    }

    .description {
        margin-top: 40px;
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.05);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .detail-wrapper {
            flex-direction: column;
            align-items: center;
        }

        .detail-cover img {
            width: 200px;
        }
    }</style>
<div class="book-detail">

    <div class="detail-wrapper">

        <!-- COVER -->
        <div class="detail-cover">
            <img src="${pageContext.request.contextPath}/img/book/${empty book.coverUrl ? 'no-cover.png' : book.coverUrl}"
                 alt="${book.title}">
        </div>

        <!-- INFO -->
        <div class="detail-info">

            <h1>${book.title}</h1>

            <p class="author">
                Tác giả: <strong>${book.author.author_name}</strong>
            </p>

            <p class="category">
                Thể loại: <strong>${book.category.category_name}</strong>
            </p>

            <p class="price">
                <c:choose>
                    <c:when test="${book.price == null || book.price == 0}">
                        <span class="free">Miễn phí</span>
                    </c:when>
                    <c:otherwise>
                        ${book.price} ${book.currency}
                    </c:otherwise>
                </c:choose>
            </p>

            <div class="summary">
                <h3>Tóm tắt</h3>
                <p>${book.summary}</p>
            </div>

            <div class="actions">
                <c:choose>
                    <c:when test="${book.price == null || book.price == 0}">
                        <a href="${pageContext.request.contextPath}/read?id=${book.bookId}" class="btn-primary">
                            📖 Đọc ngay
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="btn-primary">
                            💳 Mua ngay
                        </a>
                        <a href="${pageContext.request.contextPath}/preview?id=${book.bookId}" class="btn-outline">
                            👁 Đọc thử
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </div>

    <!-- DESCRIPTION -->
    <div class="description">
        <h3>Mô tả chi tiết</h3>
        <p>${book.description}</p>
    </div>

</div>