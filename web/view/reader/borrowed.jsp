<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Borrowed Books - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .mini-cover { width: 56px; height: 72px; object-fit: cover; border-radius: 6px; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <h4 class="mb-3">📌 Sách đang mượn</h4>

    <c:choose>
        <c:when test="${empty borrowedItems}">
            <div class="alert alert-light border">Bạn hiện không mượn cuốn nào.</div>
        </c:when>
        <c:otherwise>
            <div class="list-group shadow-sm">
                <c:forEach var="it" items="${borrowedItems}">
                    <div class="list-group-item d-flex align-items-center gap-3">
                        <img class="mini-cover"
                             src="${empty it.book.coverUrl ? 'https://via.placeholder.com/56x72?text=No+Cover' : it.book.coverUrl}"
                             alt="${it.book.title}">

                        <div class="flex-grow-1">
                            <div class="fw-semibold">${it.book.title}</div>
                            <div class="small text-muted">
                                Copy: ${it.copyCode} • Borrow ID: ${it.borrowId}
                            </div>
                            <div class="small">
                                Mượn: <fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy"/>
                                • Hạn trả: <fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/>
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
