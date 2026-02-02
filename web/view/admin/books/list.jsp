<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .page-container {
        background: #ffffff;
        padding: 24px;
        border-radius: 16px;
        border: 1px solid #fed7aa;
    }

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .page-header h2 {
        color: #c2410c;
        font-weight: bold;
        margin: 0;
    }

    .btn-orange {
        background: #f97316;
        color: #fff;
        border-radius: 8px;
        padding: 8px 16px;
        text-decoration: none;
        font-size: 14px;
    }

    .btn-orange:hover {
        background: #ea580c;
        color: #fff;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 12px;
        overflow: hidden;
    }

    thead {
        background: #f97316;
        color: #fff;
    }

    th, td {
        padding: 12px 10px;
        font-size: 14px;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    .status {
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
        color: #fff;
        display: inline-block;
    }

    .ACTIVE {
        background: #16a34a;
    }

    .INACTIVE {
        background: #9ca3af;
    }

    .btn-action {
        padding: 6px 10px;
        border-radius: 6px;
        font-size: 13px;
        text-decoration: none;
        color: #fff;
    }

    .btn-edit {
        background: #f59e0b;
    }

    .btn-delete {
        background: #dc2626;
    }

    .btn-edit:hover {
        background: #d97706;
    }

    .btn-delete:hover {
        background: #b91c1c;
    }
</style>

<div class="page-container">

    <!-- HEADER -->
    <div class="page-header">
        <h2>📚 Book Management</h2>

        <a href="${pageContext.request.contextPath}/admin/books?action=add"
           class="btn-orange">
            + Add New Book
        </a>
    </div>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Price</th>
                <th>Category</th>
                <th>Author</th>
                <th>Status</th>
                <th>Created At</th>
                <th width="130">Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach var="b" items="${books}">
                <tr>
                    <td>${b.bookId}</td>
                    <td>${b.title}</td>

                    <td>
                        <c:if test="${b.price != null}">
                            ${b.price} ${b.currency}
                        </c:if>
                    </td>

                    <td>${b.category.category_name}</td>
                    <td>${b.author.author_name}</td>

                    <td>
                        <span class="status ${b.status}">
                            ${b.status}
                        </span>
                    </td>

                    <td>${b.createdAt}</td>

                    <td>
                        <a class="btn-action btn-edit"
                           href="${pageContext.request.contextPath}/admin/books?action=edit&id=${b.bookId}">
                            Edit
                        </a>

                        <a class="btn-action btn-delete"
                           href="${pageContext.request.contextPath}/admin/books?action=delete&id=${b.bookId}"
                           onclick="return confirm('Bạn có chắc muốn xóa sách này?');">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty books}">
                <tr>
                    <td colspan="8" style="text-align:center; padding:20px;">
                        Không có sách nào
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>
