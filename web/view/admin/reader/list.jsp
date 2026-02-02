<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reader Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Danh sách Reader</h2>
        <a href="${pageContext.request.contextPath}/admin/readers?action=add"
           class="btn btn-success">
            + Thêm Reader
        </a>
    </div>

    <table class="table table-bordered table-hover align-middle">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Họ tên</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Role</th>
                <th>Created At</th>
                <th width="160">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${readers}" var="r">
                <tr>
                    <td>${r.readerId}</td>
                    <td>${r.fullName}</td>
                    <td>${r.email}</td>
                    <td>${r.phone}</td>

                    <td>
                        <span class="badge 
                            ${r.status == 'active' ? 'bg-success' : 'bg-secondary'}">
                            ${r.status}
                        </span>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${r.roleId == 1}">
                                <span class="badge bg-danger">Admin</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary">Reader</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>${r.createdAt}</td>

                    <td>
                        <a class="btn btn-sm btn-warning"
                           href="${pageContext.request.contextPath}/admin/readers?action=edit&id=${r.readerId}">
                            Edit
                        </a>

                        <a class="btn btn-sm btn-danger"
                           onclick="return confirm('Bạn có chắc muốn xóa reader này?')"
                           href="${pageContext.request.contextPath}/admin/readers?action=delete&id=${r.readerId}">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty readers}">
                <tr>
                    <td colspan="8" class="text-center text-muted">
                        Không có Reader nào
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

</body>
</html>
