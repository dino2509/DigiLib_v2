<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="u" value="${not empty sessionScope.user ? sessionScope.user : user}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>DigiLib | Reader Home</title>

    <!-- Custom Reader Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container py-4">

    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-4">
        <div>
            <h2 class="mb-1">Xin chào, <span class="text-orange">${u.fullName}</span> 👋</h2>
            <div class="text-muted">Chọn sách để đọc tiếp, khám phá sách mới hoặc quản lý mượn trả.</div>
        </div>
        <div class="d-flex gap-2 flex-wrap">
            <a class="btn btn-orange" href="${pageContext.request.contextPath}/reader/books">📚 Duyệt sách</a>
            <a class="btn btn-outline-orange" href="${pageContext.request.contextPath}/reader/borrowed">📖 Đang mượn</a>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-12 col-md-4">
            <div class="card stat-card h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted small">Đang mượn</div>
                            <div class="stat-number">${borrowedCount}</div>
                        </div>
                        <div class="stat-icon">📘</div>
                    </div>
                    <div class="mt-2">
                        <a class="link-orange" href="${pageContext.request.contextPath}/reader/borrowed">Xem danh sách</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-4">
            <div class="card stat-card h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted small">Sắp hết hạn (3 ngày)</div>
                            <div class="stat-number">${dueSoonCount}</div>
                        </div>
                        <div class="stat-icon">⏰</div>
                    </div>
                    <div class="mt-2 text-muted small">Hãy kiểm tra hạn trả để tránh trễ hạn.</div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-4">
            <div class="card stat-card h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted small">Đã đọc</div>
                            <div class="stat-number">${readTotal}</div>
                        </div>
                        <div class="stat-icon">📚</div>
                    </div>
                    <div class="mt-2">
                        <a class="link-orange" href="${pageContext.request.contextPath}/reader/books">Tìm sách mới</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="d-flex align-items-center justify-content-between mb-2">
        <h4 class="section-title">📖 Đọc tiếp</h4>
        <a class="link-orange" href="${pageContext.request.contextPath}/reader/books">Xem tất cả</a>
    </div>

    <c:choose>
        <c:when test="${empty continueReading}">
            <div class="empty-state">Bạn chưa có lịch sử đọc. Hãy bắt đầu với một cuốn sách bất kỳ.</div>
        </c:when>
        <c:otherwise>
            <div class="row g-3 mb-4">
                <c:forEach var="rp" items="${continueReading}">
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card book-card h-100">
                            <div class="book-cover">
                                <c:choose>
                                    <c:when test="${not empty rp.book.coverUrl}">
                                        <div class="cover-placeholder">${rp.book.title}</div>
                                        <img class="book-cover-img"
                                             src="${pageContext.request.contextPath}${rp.book.coverUrl}"
                                             alt="${rp.book.title}"
                                             onerror="this.style.display='none'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="cover-placeholder">${rp.book.title}</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <div class="fw-semibold mb-1 line-clamp-2">${rp.book.title}</div>
                                <div class="text-muted small mb-2">${rp.book.author}</div>
                                <div class="progress" style="height:8px;">
                                    <div class="progress-bar bg-orange" role="progressbar" style="width:${rp.progress}%"></div>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mt-2">
                                    <div class="small text-muted">${rp.progress}%</div>
                                    <a class="btn btn-sm btn-orange"
                                       href="${pageContext.request.contextPath}/reader/books/${rp.book.id}">
                                        Tiếp tục
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="d-flex align-items-center justify-content-between mb-2">
        <h4 class="section-title">✨ Gợi ý cho bạn</h4>
        <a class="link-orange" href="${pageContext.request.contextPath}/reader/books">Duyệt sách</a>
    </div>

    <div class="row g-3">
        <c:forEach var="b" items="${recommendedBooks}">
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card book-card h-100">
                    <div class="book-cover">
                        <c:choose>
                            <c:when test="${not empty b.coverUrl}">
                                <div class="cover-placeholder">${b.title}</div>
                                <img class="book-cover-img"
                                     src="${pageContext.request.contextPath}${b.coverUrl}"
                                     alt="${b.title}"
                                     onerror="this.style.display='none'">
                            </c:when>
                            <c:otherwise>
                                <div class="cover-placeholder">${b.title}</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body">
                        <div class="fw-semibold mb-1 line-clamp-2">${b.title}</div>
                        <div class="text-muted small mb-2">${b.author}</div>
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="small">⭐ <strong>${b.rating}</strong>
                                <c:if test="${not empty b.reviewCount}">
                                    <span class="text-muted">(${b.reviewCount})</span>
                                </c:if>
                            </div>
                            <a class="btn btn-sm btn-outline-orange"
                               href="${pageContext.request.contextPath}/reader/books/${b.id}">
                                Xem
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="mt-5">
        <h4 class="section-title">Đi nhanh</h4>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-orange" href="${pageContext.request.contextPath}/reader/books">📚 Books</a>
            <a class="btn btn-outline-orange" href="${pageContext.request.contextPath}/reader/categories">🗂 Categories</a>
            <a class="btn btn-outline-orange" href="${pageContext.request.contextPath}/reader/favorites">❤️ Favorites</a>
            <a class="btn btn-outline-orange" href="${pageContext.request.contextPath}/reader/borrowed">📖 Borrowed</a>
        </div>
    </div>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
