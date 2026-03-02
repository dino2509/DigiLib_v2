<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Librarian - Borrowed Books</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <h3>📚 Quản lý sách đã cho mượn</h3>

    <c:if test="${param.returned eq '1'}">
        <div class="alert alert-success">Đã xác nhận trả sách (đã cập nhật Borrow_Item / BookCopy).</div>
    </c:if>
    <c:if test="${param.returnError eq '1'}">
        <div class="alert alert-danger">Không thể xác nhận trả sách (có thể sách đã trả hoặc DB chưa cập nhật bảng Return_Request).</div>
    </c:if>

    <div class="mb-3">
        <a class="btn btn-sm ${filter=='borrowing'?'btn-danger':'btn-outline-danger'}"
           href="?filter=borrowing">Đang mượn</a>
        <a class="btn btn-sm ${filter=='overdue'?'btn-danger':'btn-outline-danger'}"
           href="?filter=overdue">Quá hạn</a>
        <a class="btn btn-sm ${filter=='returned'?'btn-danger':'btn-outline-danger'}"
           href="?filter=returned">Đã trả</a>
    </div>

    <table class="table table-bordered align-middle">
        <thead>
            <tr>
                <th>Sách</th>
                <th>Reader</th>
                <th>Copy</th>
                <th>Ngày mượn</th>
                <th>Hạn trả</th>
                <th>Trạng thái</th>
                <th style="width: 160px;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${items}" var="it">
                <tr>
                    <td>${it.book.title}</td>
                    <td>${it.readerName}</td>
                    <td>${it.copyCode}</td>
                    <td><fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <span class="badge bg-${it.status=='OVERDUE'?'danger':
                                              it.status=='RETURNED'?'success':'warning'}">
                            ${it.status}
                        </span>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${it.status=='RETURNED'}">
                                <button class="btn btn-sm btn-outline-secondary" disabled>Đã trả</button>
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="${pageContext.request.contextPath}/librarian/borrowed-books" class="m-0">
                                    <input type="hidden" name="action" value="return"/>
                                    <input type="hidden" name="filter" value="${filter}"/>
                                    <input type="hidden" name="borrowItemId" value="${it.borrowItemId}"/>
                                    <button class="btn btn-sm btn-danger" type="submit">Trả sách</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>