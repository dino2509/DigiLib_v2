<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>DigiLib | Borrowed</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
</head>
<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container py-4">

    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-3">
        <div>
            <h3 class="mb-1">📖 Sách đang mượn</h3>
            <div class="text-muted small">Lấy từ Borrow, Borrow_Item, BookCopy.</div>
        </div>
        <div class="text-muted small">Tổng: <strong>${count}</strong></div>
    </div>

    <c:choose>
        <c:when test="${empty items}">
            <div class="empty-state">Bạn chưa mượn sách nào.</div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                    <tr>
                        <th>Sách</th>
                        <th class="d-none d-md-table-cell">Bản sao</th>
                        <th>Hạn trả</th>
                        <th>Trạng thái</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="it" items="${items}">
                        <tr>
                            <td>
                                <div class="d-flex gap-3 align-items-center">
                                    <div class="book-cover book-cover-sm">
                                        <c:choose>
                                            <c:when test="${not empty it.book.coverUrl}">
                                                <div class="cover-placeholder cover-placeholder-sm">${it.book.title}</div>
                                                <img class="book-cover-img" src="${pageContext.request.contextPath}${it.book.coverUrl}" alt="${it.book.title}" onerror="this.style.display='none'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="cover-placeholder cover-placeholder-sm">${it.book.title}</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <div class="fw-semibold line-clamp-2">${it.book.title}</div>
                                        <div class="text-muted small">${it.book.author}</div>
                                    </div>
                                </div>
                            </td>
                            <td class="d-none d-md-table-cell"><span class="text-muted">${it.copyCode}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty it.dueDate}">
                                        ${it.dueDate}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${it.status == 'overdue'}">
                                        <span class="badge text-bg-danger">Quá hạn</span>
                                    </c:when>
                                    <c:when test="${it.returnedAt != null}">
                                        <span class="badge text-bg-secondary">Đã trả</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge text-bg-success">Đang mượn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <a class="btn btn-sm btn-outline-orange" href="${pageContext.request.contextPath}/reader/books/${it.book.id}">Chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
