<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>DigiLib | Books</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container py-4">

    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-3">
        <div>
            <h3 class="mb-1">📚 Danh sách sách</h3>
            <div class="text-muted small">Tìm kiếm theo tên, tác giả hoặc thể loại.</div>
        </div>
        <div class="text-muted small">Tổng: <strong>${total}</strong></div>
    </div>

    <form class="row g-2 align-items-end mb-4" method="get" action="${pageContext.request.contextPath}/reader/books">
        <div class="col-12 col-md-6">
            <label class="form-label small text-muted">Từ khóa</label>
            <input type="text" name="q" class="form-control" placeholder="VD: Harry Potter, Clean Code..." value="${q}">
        </div>
        <div class="col-12 col-md-4">
            <label class="form-label small text-muted">Thể loại</label>
            <select class="form-select" name="categoryId">
                <option value="">Tất cả</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.id}" <c:if test="${categoryId != null && categoryId == c.id}">selected</c:if>>
                        ${c.name} (${c.bookCount})
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-12 col-md-2 d-grid">
            <button class="btn btn-orange" type="submit">Tìm</button>
        </div>
    </form>

    <c:choose>
        <c:when test="${empty books}">
            <div class="empty-state">Không có sách phù hợp. Hãy thử đổi từ khóa hoặc thể loại.</div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach var="b" items="${books}">
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card book-card h-100">
                            <div class="book-cover">
                                <c:choose>
                                    <c:when test="${not empty b.coverUrl}">
                                        <div class="cover-placeholder">${b.title}</div>
                                        <img class="book-cover-img" src="${pageContext.request.contextPath}${b.coverUrl}" alt="${b.title}" onerror="this.style.display='none'">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="cover-placeholder">${b.title}</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <div class="fw-semibold mb-1 line-clamp-2">${b.title}</div>
                                <div class="text-muted small mb-1">${b.author}</div>
                                <div class="text-muted small mb-2">${b.categoryName}</div>
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="small">⭐ <strong>${b.rating}</strong>
                                        <c:if test="${not empty b.reviewCount}">
                                            <span class="text-muted">(${b.reviewCount})</span>
                                        </c:if>
                                    </div>
                                    <a class="btn btn-sm btn-outline-orange" href="${pageContext.request.contextPath}/reader/books/${b.id}">Xem</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${totalPages > 1}">
                <nav class="mt-4" aria-label="Pagination">
                    <ul class="pagination justify-content-center">
                        <c:set var="prev" value="${page - 1}" />
                        <li class="page-item <c:if test='${page <= 1}'>disabled</c:if>">
                            <a class="page-link" href="${pageContext.request.contextPath}/reader/books?q=${q}&categoryId=${categoryId}&page=${prev}">Trước</a>
                        </li>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item <c:if test='${i == page}'>active</c:if>">
                                <a class="page-link" href="${pageContext.request.contextPath}/reader/books?q=${q}&categoryId=${categoryId}&page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:set var="next" value="${page + 1}" />
                        <li class="page-item <c:if test='${page >= totalPages}'>disabled</c:if>">
                            <a class="page-link" href="${pageContext.request.contextPath}/reader/books?q=${q}&categoryId=${categoryId}&page=${next}">Sau</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
