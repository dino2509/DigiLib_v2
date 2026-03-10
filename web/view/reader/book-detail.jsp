<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>DigiLib | Book Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container py-4">

    <a class="link-orange" href="${pageContext.request.contextPath}/reader/books">← Quay lại danh sách</a>

    <div class="row g-4 mt-2">
        <div class="col-12 col-md-4">
            <div class="card">
                <div class="book-cover book-cover-lg">
                    <c:choose>
                        <c:when test="${not empty book.coverUrl}">
                            <div class="cover-placeholder cover-placeholder-lg">${book.title}</div>
                            <img class="book-cover-img" src="${pageContext.request.contextPath}${book.coverUrl}" alt="${book.title}" onerror="this.style.display='none'">
                        </c:when>
                        <c:otherwise>
                            <div class="cover-placeholder cover-placeholder-lg">${book.title}</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-8">
            <h2 class="mb-1">${book.title}</h2>
            <div class="text-muted mb-2">
                <span class="me-3">✍️ ${book.author}</span>
                <c:if test="${not empty book.categoryName}">
                    <span>🗂 ${book.categoryName}</span>
                </c:if>
            </div>

            <div class="d-flex flex-wrap gap-3 align-items-center mb-3">
                <div>⭐ <strong>${book.rating}</strong>
                    <c:if test="${not empty book.reviewCount}">
                        <span class="text-muted">(${book.reviewCount} đánh giá)</span>
                    </c:if>
                </div>
                <c:if test="${not empty book.totalPages}">
                    <div class="text-muted">📄 ${book.totalPages} trang</div>
                </c:if>
                <c:if test="${not empty book.price}">
                    <div class="text-muted">💳 ${book.price} ${book.currency}</div>
                </c:if>
            </div>

            <c:if test="${not empty book.summary}">
                <div class="mb-3">
                    <h5 class="section-title">Tóm tắt</h5>
                    <div class="text-muted">${book.summary}</div>
                </div>
            </c:if>

            <c:if test="${not empty book.description}">
                <div class="mb-4">
                    <h5 class="section-title">Mô tả</h5>
                    <div class="text-muted" style="white-space:pre-line;">${book.description}</div>
                </div>
            </c:if>

            <div class="d-flex flex-wrap gap-2">
                <a class="btn btn-orange" href="#" onclick="return false;">📖 Đọc (coming soon)</a>
                <a class="btn btn-outline-orange" href="#" onclick="return false;">❤️ Yêu thích (coming soon)</a>
                <a class="btn btn-outline-orange" href="#" onclick="return false;">📦 Mượn (coming soon)</a>
            </div>
        </div>
    </div>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
