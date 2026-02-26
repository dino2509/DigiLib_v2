<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lịch sử mượn sách - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .mini-cover { width: 56px; height: 72px; object-fit: cover; border-radius: 6px; }
        .muted { color: #6c757d; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<jsp:useBean id="now" class="java.util.Date" />

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <h4 class="mb-0">📚 Lịch sử mượn sách</h4>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/reader/home">← Về trang Reader</a>
    </div>

    <!-- Filters -->
    <ul class="nav nav-pills mt-3">
        <li class="nav-item">
            <a class="nav-link ${filter eq 'all' ? 'active' : ''}" href="${pageContext.request.contextPath}/reader/borrowed?filter=all">Tất cả</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${filter eq 'returned' ? 'active' : ''}" href="${pageContext.request.contextPath}/reader/borrowed?filter=returned">Đã trả</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${filter eq 'borrowing' ? 'active' : ''}" href="${pageContext.request.contextPath}/reader/borrowed?filter=borrowing">Đang mượn</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${filter eq 'overdue' ? 'active' : ''}" href="${pageContext.request.contextPath}/reader/borrowed?filter=overdue">Quá hạn</a>
        </li>
    </ul>

    <c:choose>
        <c:when test="${empty borrowedItems}">
            <div class="alert alert-light border mt-3">Không có dữ liệu phù hợp bộ lọc hiện tại.</div>
        </c:when>
        <c:otherwise>
            <div class="list-group shadow-sm mt-3">
                <c:forEach var="it" items="${borrowedItems}">
                    <c:set var="isOverdue" value="${it.returnedAt == null and it.dueDate != null and it.dueDate.time < now.time}" />

                    <div class="list-group-item d-flex align-items-center gap-3">
                        <img class="mini-cover"
                             src="${pageContext.request.contextPath}/img/book/${empty it.book.coverUrl ? 'no-cover.png' : it.book.coverUrl}"
                             alt="${it.book.title}">

                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                                <div class="fw-semibold">${it.book.title}</div>

                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${it.returnedAt != null}">
                                            <span class="badge bg-success">Đã trả</span>
                                        </c:when>
                                        <c:when test="${isOverdue}">
                                            <span class="badge bg-danger">Quá hạn</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark">Đang mượn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="small muted">
                                Copy: ${it.copyCode} • Borrow ID: ${it.borrowId}
                            </div>

                            <div class="small">
                                Mượn: <fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy"/>
                                • Hạn trả: <fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/>
                                <c:if test="${it.returnedAt != null}">
                                    • Đã trả: <fmt:formatDate value="${it.returnedAt}" pattern="dd/MM/yyyy"/>
                                </c:if>
                                <c:if test="${isOverdue}">
                                    <span class="text-danger fw-semibold"> • Vui lòng trả sách sớm!</span>
                                </c:if>
                            </div>
                        </div>

                        <a class="btn btn-sm btn-warning"
                           href="${pageContext.request.contextPath}/books/detail?id=${it.book.bookId}">
                            Chi tiết
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>