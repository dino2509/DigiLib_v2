<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Books - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <style>
        .book-cover { height: 220px; object-fit: cover; }
    </style>
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">📚 Danh sách sách</h4>
        <div class="text-muted small">Tổng: ${total}</div>
    </div>

    <!-- Filter -->
    <form class="row g-2 mb-3" action="${pageContext.request.contextPath}/reader/books" method="get">
        <div class="col-md-5">
            <input class="form-control" name="q" value="${q}" placeholder="Tìm theo tên sách...">
        </div>

        <div class="col-md-4">
            <select class="form-select" name="categoryId">
                <option value="">-- Thể loại --</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.category_id}" ${c.category_id == categoryId ? 'selected' : ''}>
                        ${c.category_name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3 d-grid">
            <button class="btn btn-warning">Lọc / Tìm</button>
        </div>
    </form>

    <!-- Books -->
    <c:choose>
        <c:when test="${empty books}">
            <div class="alert alert-light border">Không có sách phù hợp.</div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="book" items="${books}">
                    <div class="col-md-3 mb-4">
                        <div class="card h-100 shadow-sm">
                            <img class="card-img-top book-cover"
                                 src="${empty book.coverUrl ? 'https://via.placeholder.com/300x400?text=No+Cover' : book.coverUrl}"
                                 alt="${book.title}">
                            <div class="card-body">
                                <h6 class="card-title">${book.title}</h6>
                                <div class="small text-muted">
                                    <c:if test="${book.category != null}">• ${book.category.category_name}</c:if>
                                    <c:if test="${book.author != null}">• ${book.author.author_name}</c:if>
                                </div>
                            </div>
                            <div class="card-footer text-center bg-white">
                                <a class="btn btn-sm btn-warning"
                                   href="${pageContext.request.contextPath}/reader/books/detail?id=${book.bookId}">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav>
                    <ul class="pagination justify-content-center">
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == page ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/reader/books?q=${q}&categoryId=${categoryId}&page=${p}">
                                    ${p}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </nav>
            </c:if>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
