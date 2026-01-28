<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>DigiLib | Categories</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container py-4">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-3">
        <div>
            <h3 class="mb-1">🗂 Thể loại</h3>
            <div class="text-muted small">Chọn thể loại để lọc sách nhanh.</div>
        </div>
        <a class="btn btn-outline-orange" href="${pageContext.request.contextPath}/reader/books">📚 Xem tất cả sách</a>
    </div>

    <c:choose>
        <c:when test="${empty categories}">
            <div class="empty-state">Chưa có thể loại trong hệ thống.</div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach var="c" items="${categories}">
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-start justify-content-between">
                                    <div>
                                        <h5 class="mb-1">${c.name}</h5>
                                        <div class="text-muted small">${c.bookCount} sách</div>
                                    </div>
                                    <div class="badge text-bg-orange">🗂</div>
                                </div>
                                <c:if test="${not empty c.description}">
                                    <div class="mt-2 text-muted small line-clamp-3">${c.description}</div>
                                </c:if>
                                <div class="mt-3">
                                    <a class="btn btn-sm btn-orange" href="${pageContext.request.contextPath}/reader/books?categoryId=${c.id}">Xem sách</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
