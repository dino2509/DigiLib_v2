<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt trước sách - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">

    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <h4 class="mb-0">⏳ Danh sách đặt trước của bạn</h4>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/reader/home">← Về trang Reader</a>
    </div>

    <c:if test="${param.cancelled eq '1'}">
        <div class="alert alert-success mt-3">Đã huỷ đặt trước.</div>
    </c:if>
    <c:if test="${param.cancelled eq '0'}">
        <div class="alert alert-danger mt-3">Không thể huỷ (có thể đơn đã được xử lý hoặc không còn WAITING).</div>
    </c:if>

    <c:choose>
        <c:when test="${empty reservations}">
            <div class="alert alert-light border mt-3">Bạn chưa có đơn đặt trước nào.</div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive mt-3">
                <table class="table table-bordered align-middle">
                    <thead>
                        <tr>
                            <th>Sách</th>
                            <th>Thời gian đặt</th>
                            <th>Vị trí trong hàng đợi</th>
                            <th style="width: 180px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${reservations}" var="r">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/books/detail?id=${r.bookId}">
                                        ${r.bookTitle}
                                    </a>
                                </td>
                                <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>
                                    <span class="badge bg-warning text-dark">#${r.position}</span>
                                </td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/reader/reservations" class="m-0">
                                        <input type="hidden" name="action" value="cancel"/>
                                        <input type="hidden" name="reservationId" value="${r.reservationId}"/>
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Huỷ đặt trước</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="alert alert-info mt-2">
                Khi thư viện có thêm bản sao AVAILABLE, hệ thống sẽ tự động chuyển người đứng đầu hàng đợi thành một <strong>Borrow Request (PENDING)</strong>.
                Bạn có thể theo dõi lịch sử yêu cầu mượn tại <a href="${pageContext.request.contextPath}/reader/home#borrow-requests">Reader Home</a>.
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>