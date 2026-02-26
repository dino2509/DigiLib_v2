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
        .nowrap { white-space: nowrap; }
    </style>
</head>

<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">

    <!-- Welcome -->
    <div class="p-3 rounded-3 bg-warning bg-opacity-25 border">
        👋 Xin chào, <strong>${sessionScope.user.fullName}</strong>!
        <span class="muted">Chúc bạn đọc sách vui vẻ.</span>
    </div>

    <!-- Stats -->
    <div class="row g-3 mt-1">

        <div class="col-md-3">
            <div class="card stat-card shadow-sm h-100">
                <div class="card-body">
                    <div class="muted">Sách đang mượn</div>
                    <div class="fs-3 fw-bold">${borrowedCount}</div>
                    <a class="small" href="${pageContext.request.contextPath}/reader/borrowed?filter=borrowing">Xem danh sách</a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stat-card shadow-sm h-100">
                <div class="card-body">
                    <div class="muted">Sách quá hạn</div>
                    <div class="fs-3 fw-bold ${overdueCount > 0 ? 'text-danger' : ''}">${overdueCount}</div>
                    <a class="small" href="${pageContext.request.contextPath}/reader/borrowed?filter=overdue">Xem sách quá hạn</a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stat-card shadow-sm h-100">
                <div class="card-body">
                    <div class="muted">Sắp đến hạn (3 ngày)</div>
                    <div class="fs-3 fw-bold">${dueSoonCount}</div>
                    <a class="small" href="${pageContext.request.contextPath}/reader/borrowed?filter=borrowing">Kiểm tra hạn trả</a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card stat-card shadow-sm h-100">
                <div class="card-body">
                    <div class="muted">Tổng số sách đã đọc</div>
                    <div class="fs-3 fw-bold">${totalRead}</div>
                    <a class="small" href="${pageContext.request.contextPath}/reader/borrowed?filter=all">Xem lịch sử mượn</a>
                    <div class="small muted mt-1">Tổng lượt mượn: ${totalBorrowedItems}</div>
                </div>
            </div>
        </div>

        <div class="col-12">
            <div class="card stat-card shadow-sm">
                <div class="card-body d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <div>
                        <div class="muted">Yêu cầu mượn (đang chờ)</div>
                        <div class="fs-4 fw-bold mb-0">${pendingRequestedCount}</div>
                        <div class="small muted">Tổng đã gửi (theo items): ${totalRequestedCount}</div>
                    </div>
                    <a class="btn btn-sm btn-outline-secondary" href="#borrow-requests">Xem lịch sử yêu cầu</a>
                </div>
            </div>
        </div>

    </div>

    <!-- Borrow request history -->
    <div class="mt-4" id="borrow-requests">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
            <h4 class="mb-0">📩 Lịch sử yêu cầu mượn đã gửi</h4>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/reader/borrowed?filter=all">Mở lịch sử mượn</a>
        </div>

        <c:choose>
            <c:when test="${empty recentRequests}">
                <div class="alert alert-light border mt-3">Bạn chưa gửi yêu cầu mượn nào.</div>
            </c:when>
            <c:otherwise>
                <div class="accordion mt-3" id="accRequests">
                    <c:forEach items="${recentRequests}" var="r" varStatus="st">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="h${st.index}">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#c${st.index}">
                                    <span class="me-2 nowrap">#${r.requestId}</span>
                                    <span class="me-2">•</span>
                                    <span class="me-2 nowrap"><fmt:formatDate value="${r.requestedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    <span class="me-2">•</span>
                                    <c:choose>
                                        <c:when test="${r.status eq 'PENDING'}"><span class="badge bg-warning text-dark">PENDING</span></c:when>
                                        <c:when test="${r.status eq 'APPROVED'}"><span class="badge bg-success">APPROVED</span></c:when>
                                        <c:when test="${r.status eq 'REJECTED'}"><span class="badge bg-danger">REJECTED</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${r.status}</span></c:otherwise>
                                    </c:choose>
                                </button>
                            </h2>
                            <div id="c${st.index}" class="accordion-collapse collapse" data-bs-parent="#accRequests">
                                <div class="accordion-body">
                                    <c:if test="${not empty r.note}">
                                        <div class="mb-2"><span class="fw-semibold">Ghi chú:</span> ${r.note}</div>
                                    </c:if>
                                    <c:if test="${not empty r.decisionNote}">
                                        <div class="mb-2"><span class="fw-semibold">Phản hồi:</span> ${r.decisionNote}</div>
                                    </c:if>

                                    <div class="fw-semibold mb-2">Danh sách sách:</div>
                                    <ul class="mb-0">
                                        <c:forEach items="${r.items}" var="it">
                                            <li>
                                                <a href="${pageContext.request.contextPath}/books/detail?id=${it.bookId}">${it.bookTitle}</a>
                                                <span class="muted">(x${it.quantity})</span>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Continue Reading -->
    <div class="mt-4">
        <h4 class="mb-3">📖 Đọc tiếp</h4>

        <c:choose>
            <c:when test="${empty continueReading}">
                <div class="alert alert-light border">Chưa có dữ liệu đọc tiếp.</div>
            </c:when>
            <c:otherwise>
                <div class="list-group">
                    <c:forEach items="${continueReading}" var="h">
                        <a class="list-group-item list-group-item-action d-flex align-items-center gap-3"
                           href="${pageContext.request.contextPath}/books/detail?id=${h.book.bookId}">
                            <img class="mini-cover"
                                 src="${pageContext.request.contextPath}/img/book/${empty h.book.coverUrl ? 'no-cover.png' : h.book.coverUrl}"
                                 alt="${h.book.title}">
                            <div class="flex-grow-1">
                                <div class="fw-semibold">${h.book.title}</div>
                                <div class="small muted">
                                    Lần đọc gần nhất: <fmt:formatDate value="${h.lastReadAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    <c:if test="${h.lastReadPosition != null && h.book.totalPages > 0}">
                                        • Trang: ${h.lastReadPosition}/${h.book.totalPages}
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

    <!-- Reading History -->
    <div class="mt-4">
        <h4 class="mb-3">🕘 Lịch sử đọc gần đây</h4>
        <c:choose>
            <c:when test="${empty readingHistory}">
                <div class="alert alert-light border">Chưa có lịch sử đọc.</div>
            </c:when>
            <c:otherwise>
                <div class="list-group">
                    <c:forEach items="${readingHistory}" var="h">
                        <a class="list-group-item list-group-item-action d-flex align-items-center gap-3"
                           href="${pageContext.request.contextPath}/books/detail?id=${h.book.bookId}">
                            <img class="mini-cover"
                                 src="${pageContext.request.contextPath}/img/book/${empty h.book.coverUrl ? 'no-cover.png' : h.book.coverUrl}"
                                 alt="${h.book.title}">
                            <div class="flex-grow-1">
                                <div class="fw-semibold">${h.book.title}</div>
                                <div class="small muted">
                                    Lần đọc gần nhất: <fmt:formatDate value="${h.lastReadAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    <c:if test="${h.lastReadPosition != null && h.book.totalPages > 0}">
                                        • Trang: ${h.lastReadPosition}/${h.book.totalPages}
                                    </c:if>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Recommended -->
    <div class="mt-4">
        <h4 class="mb-3">✨ Gợi ý cho bạn</h4>

        <div class="row g-3">
            <c:forEach items="${recommended}" var="b">
                <div class="col-md-3">
                    <div class="card shadow-sm h-100">
                        <img class="card-img-top book-cover"
                             src="${pageContext.request.contextPath}/img/book/${empty b.coverUrl ? 'no-cover.png' : b.coverUrl}"
                             alt="${b.title}">
                        <div class="card-body">
                            <div class="fw-semibold">${b.title}</div>
                            <div class="small muted">${b.category != null ? b.category.category_name : ''}</div>
                            <a class="btn btn-sm btn-warning mt-2"
                               href="${pageContext.request.contextPath}/books/detail?id=${b.bookId}">
                                Xem chi tiết
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

</div>

</body>
</html>