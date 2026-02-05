<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Book Detail - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <style>
        .cover { width: 100%; max-width: 360px; height: 480px; object-fit: cover; border-radius: 12px; }
        .muted { color: #6c757d; }
    </style>
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container mt-4">
    <a class="small" href="${pageContext.request.contextPath}/reader/books">← Quay lại danh sách</a>

    <div class="row mt-3">
        <div class="col-md-4">
            <img class="cover shadow-sm"
                 src="${empty book.coverUrl ? 'https://via.placeholder.com/360x480?text=No+Cover' : book.coverUrl}"
                 alt="${book.title}">
        </div>

        <div class="col-md-8">
            <h2 class="mb-1">${book.title}</h2>

            <div class="muted mb-3">
                <c:if test="${book.author != null}">Tác giả: <strong>${book.author.author_name}</strong> • </c:if>
                <c:if test="${book.category != null}">Thể loại: <strong>${book.category.category_name}</strong></c:if>
            </div>

            <div class="mb-2">
                <c:choose>
                    <c:when test="${book.price == null || book.price == 0}">
                        <span class="badge bg-success">Miễn phí</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-warning text-dark">${book.price} ${book.currency}</span>
                    </c:otherwise>
                </c:choose>
                <span class="badge bg-secondary">${book.status}</span>
            </div>

            <c:if test="${not empty book.summary}">
                <h5 class="mt-4">Tóm tắt</h5>
                <p>${book.summary}</p>
            </c:if>

            <c:if test="${not empty book.description}">
                <h5 class="mt-4">Mô tả</h5>
                <p>${book.description}</p>
            </c:if>

            <div class="mt-4 d-flex gap-2 flex-wrap">
                <form method="post" action="${pageContext.request.contextPath}/reader/favorites">
                    <input type="hidden" name="bookId" value="${book.bookId}">
                    <c:choose>
                        <c:when test="${isFavorite}">
                            <input type="hidden" name="action" value="remove">
                            <button class="btn btn-outline-danger">❤️ Bỏ yêu thích</button>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="add">
                            <button class="btn btn-danger">❤️ Thêm yêu thích</button>
                        </c:otherwise>
                    </c:choose>
                </form>

                <a class="btn btn-warning" href="${pageContext.request.contextPath}/reader/borrowed">
                    Xem sách đang mượn
                </a>
            </div>

            <div class="small muted mt-3">
                ID: ${book.bookId} • Total pages: ${book.totalPages} • Preview pages: ${book.previewPages}
            </div>
        </div>
    </div>
</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
