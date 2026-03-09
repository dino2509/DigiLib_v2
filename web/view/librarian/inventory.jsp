<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Librarian - Inventory</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div>
            <h3 class="mb-0">📦 Inventory</h3>
            <div class="text-muted">Hiển thị các đầu sách và tổng số copy trong hệ thống.</div>
        </div>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">← Dashboard</a>
    </div>

    <form class="row g-2 mt-3" method="get" action="${pageContext.request.contextPath}/librarian/inventory">
        <div class="col-md-6">
            <input class="form-control" name="q" value="${q}" placeholder="Tìm theo title hoặc book_id"/>
        </div>
        <div class="col-auto">
            <button class="btn btn-primary" type="submit">Tìm</button>
        </div>
        <div class="col-auto">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/inventory">Reset</a>
        </div>
        <div class="col-12 text-muted small">Tổng: <b>${total}</b> đầu sách</div>
    </form>

    <div class="table-responsive mt-3">
        <table class="table table-striped align-middle">
            <thead>
                <tr>
                    <th style="width: 90px;">Book ID</th>
                    <th>Title</th>
                    <th style="width: 140px;" class="text-end">Total copies</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${rows}">
                    <tr>
                        <td>${r.bookId}</td>
                        <td>${r.title}</td>
                        <td class="text-end">${r.totalCopies}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty rows}">
                    <tr>
                        <td colspan="3" class="text-center text-muted">Không có dữ liệu.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <nav aria-label="Inventory pagination">
            <ul class="pagination">
                <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/librarian/inventory?q=${q}&page=${page-1}">Prev</a>
                </li>

                <c:forEach var="p" begin="1" end="${totalPages}">
                    <li class="page-item ${p == page ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/librarian/inventory?q=${q}&page=${p}">${p}</a>
                    </li>
                </c:forEach>

                <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/librarian/inventory?q=${q}&page=${page+1}">Next</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

</body>
</html>