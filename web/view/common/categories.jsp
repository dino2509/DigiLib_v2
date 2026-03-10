<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Categories - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <h4 class="mb-3">🏷️ Thể loại</h4>

    <c:choose>
        <c:when test="${empty categories}">
            <div class="alert alert-light border">Chưa có thể loại.</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="c" items="${categories}">
                    <div class="col-md-4 mb-3">
                        <div class="card shadow-sm h-100">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-1">${c.category_name}</h5>
                                    <span class="badge bg-warning text-dark">${c.bookCount} sách</span>
                                </div>
                                <p class="text-muted mb-0">${c.description}</p>
                            </div>
                            <div class="card-footer bg-white">
                                <a class="btn btn-sm btn-warning"
                                   href="${pageContext.request.contextPath}/books?categoryId=${c.category_id}">
                                    Xem sách
                                </a>
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
