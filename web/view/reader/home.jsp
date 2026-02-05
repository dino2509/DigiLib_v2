<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Reader Home - DigiLib</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <style>
        .book-cover { height: 220px; object-fit: cover; }
        .mini-cover { width: 64px; height: 84px; object-fit: cover; border-radius: 6px; }
        .stat-card { border-left: 6px solid #ff7a18; }
        .muted { color: #6c757d; }
    </style>
</head>

<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container mt-4">

    <!-- Welcome -->
    <div class="p-3 rounded-3 bg-warning bg-opacity-25 border">
        👋 Xin chào, <strong>${sessionScope.user.fullName}</strong>!
        <span class="muted">Chúc bạn đọc sách vui vẻ.</span>
    </div>

    <!-- Stats -->
    <div class="row g-3 mt-1">
        <div class="col-md-4">
            <div class="card stat-card shadow-sm">
                <div class="card-body">
                    <div class="muted">Sách đang mượn</div>
                    <div class="fs-3 fw-bold">${borrowedCount}</div>
                    <a class="small" href="${pageContext.request.contextPath}/reader/borrowed">Xem danh sách</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card shadow-sm">
                <div class="card-body">
                    <div class="muted">Sắp đến hạn (3 ngày)</div>
                    <div class="fs-3 fw-bold">${dueSoonCount}</div>
                    <a class="small" href="${pageContext.request.contextPath}/reader/borrowed">Kiểm tra hạn trả</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card shadow-sm">
                <div class="card-body">
                    <div class="muted">Tổng sách đã đọc</div>
                    <div class="fs-3 fw-bold">${totalRead}</div>
                    <span class="small muted">theo Reading_History</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Continue Reading -->
    <div class="mt-4">
        <h4 class="mb-3">📖 Đọc tiếp</h4>

        <c:choose>
            <c:when test="${empty continueReading}">
                <div class="alert alert-light border">
                    Chưa có lịch sử đọc. Hãy mở một cuốn sách để bắt đầu.
                </div>
            </c:when>
            <c:otherwise>
                <div class="list-group shadow-sm">
                    <c:forEach var="h" items="${continueReading}">
                        <a class="list-group-item list-group-item-action d-flex align-items-center gap-3"
                           href="${pageContext.request.contextPath}/reader/books/detail?id=${h.book.bookId}">
                            <img class="mini-cover"
                                 src="${empty h.book.coverUrl ? 'https://via.placeholder.com/64x84?text=No+Cover' : h.book.coverUrl}"
                                 alt="${h.book.title}">
                            <div class="flex-grow-1">
                                <div class="fw-semibold">${h.book.title}</div>
                                <div class="small muted">
                                    Vị trí đọc: <c:out value="${h.lastReadPosition}"/> /
                                    <c:out value="${h.book.totalPages}"/> trang
                                    <c:if test="${not empty h.lastReadAt}">
                                        • Lần cuối: <fmt:formatDate value="${h.lastReadAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:if>
                                </div>
                            </div>
                            <span class="badge bg-warning text-dark">Continue</span>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Recommended -->
    <div class="mt-4">
        <div class="d-flex justify-content-between align-items-center">
            <h4 class="mb-3">✨ Gợi ý cho bạn</h4>
            <a href="${pageContext.request.contextPath}/reader/books" class="small">Xem tất cả</a>
        </div>

        <div class="row">
            <c:forEach var="book" items="${recommended}">
                <div class="col-md-3 mb-4">
                    <div class="card h-100 shadow-sm">

                        <img class="card-img-top book-cover"
                             src="${empty book.coverUrl ? 'https://via.placeholder.com/300x400?text=No+Cover' : book.coverUrl}"
                             alt="${book.title}">

                        <div class="card-body">
                            <h6 class="card-title">${book.title}</h6>

                            <p class="text-muted mb-0">
                                <c:choose>
                                    <c:when test="${book.price == null || book.price == 0}">
                                        Miễn phí
                                    </c:when>
                                    <c:otherwise>
                                        ${book.price} ${book.currency}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="card-footer text-center bg-white">
                            <a href="${pageContext.request.contextPath}/reader/books/detail?id=${book.bookId}"
                               class="btn btn-sm btn-warning">
                                Xem chi tiết
                            </a>
                        </div>

                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
