<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Librarian - Reservation Queue</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <h3 class="mb-0">⏳ Quản lý đặt trước (Reservation Queue)</h3>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">← Dashboard</a>
    </div>

    <div class="row g-3 mt-2">
        <div class="col-lg-5">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title mb-2">Các cuốn đang có hàng đợi</h5>
                    <c:choose>
                        <c:when test="${empty queueBooks}">
                            <div class="alert alert-light border mb-0">Không có hàng đợi đặt trước nào.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group">
                                <c:forEach items="${queueBooks}" var="b">
                                    <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${b.bookId == selectedBookId ? 'active' : ''}"
                                       href="${pageContext.request.contextPath}/librarian/reservations?bookId=${b.bookId}">
                                        <span>${b.bookTitle}</span>
                                        <span class="badge bg-${b.bookId == selectedBookId ? 'light text-dark' : 'danger'} rounded-pill">${b.waitingCount}</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="small text-muted mt-2">
                        Khi có bản sao AVAILABLE (do trả sách hoặc thêm copy), hệ thống sẽ tự động chuyển người đầu hàng đợi thành Borrow Request (PENDING).
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title mb-2">Chi tiết hàng đợi</h5>

                    <c:choose>
                        <c:when test="${selectedBookId == null || selectedBookId <= 0}">
                            <div class="alert alert-light border mb-0">Chọn 1 cuốn sách bên trái để xem hàng đợi.</div>
                        </c:when>
                        <c:when test="${empty queue}">
                            <div class="alert alert-light border mb-0">Không có người nào đang WAITING cho cuốn này.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 80px;">Vị trí</th>
                                            <th>Reader</th>
                                            <th>Thời gian đặt</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${queue}" var="r" varStatus="st">
                                            <tr>
                                                <td><span class="badge bg-warning text-dark">#${st.index + 1}</span></td>
                                                <td>${r.readerName} (ID: ${r.readerId})</td>
                                                <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>