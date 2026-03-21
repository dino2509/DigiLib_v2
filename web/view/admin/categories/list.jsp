<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .page-wrap {
        max-width: 1200px;
        margin: 0 auto;
        background: #ffffff;
        padding: 28px 30px;
        border-radius: 18px;
        border: 1px solid #f3f4f6;
        box-shadow: 0 16px 40px rgba(0,0,0,0.06);
    }

    /* HEADER */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .page-header h2 {
        margin: 0;
        font-size: 24px;
        font-weight: 700;
        color: #ea580c;
    }

    .btn-add {
        background: linear-gradient(135deg, #f97316, #ea580c);
        color: #fff;
        padding: 10px 20px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
    }

    .btn-add:hover {
        box-shadow: 0 6px 18px rgba(249,115,22,0.4);
    }

    /* SEARCH */
    .search-box {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
    }

    .search-box input {
        flex: 1;
        padding: 10px 14px;
        border-radius: 999px;
        border: 1px solid #e5e7eb;
        outline: none;
    }

    .search-box button {
        padding: 10px 18px;
        border: none;
        border-radius: 999px;
        background: #f97316;
        color: white;
        font-weight: 600;
        cursor: pointer;
    }

    /* TABLE */
    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: #fff7ed;
    }

    thead th {
        padding: 14px;
        text-align: left;
        font-size: 13px;
        color: #9a3412;
    }

    tbody td {
        padding: 14px;
        border-bottom: 1px solid #f3f4f6;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    /* BADGE ID */
    .badge-id {
        background: #fff7ed;
        padding: 4px 10px;
        border-radius: 999px;
        font-weight: 600;
        color: #c2410c;
        font-size: 12px;
    }

    /* DESCRIPTION */
    .desc {
        color: #4b5563;
        font-size: 13px;
    }

    .desc-empty {
        color: #9ca3af;
        font-style: italic;
    }

    /* ACTION */
    .action-btn {
        padding: 6px 12px;
        border-radius: 999px;
        font-size: 12px;
        text-decoration: none;
        color: white;
        font-weight: 600;
        margin-right: 5px;
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

    /* EMPTY */
    .empty-row {
        text-align: center;
        padding: 40px;
        color: #6b7280;
    }

    /* PAGINATION */
    .pagination {
        margin-top: 20px;
        text-align: center;
    }

    .pagination a {
        display: inline-block;
        margin: 0 4px;
        padding: 8px 14px;
        border-radius: 999px;
        text-decoration: none;
        font-weight: 600;
        background: #f3f4f6;
        color: #374151;
    }

    .pagination a.active {
        background: #f97316;
        color: white;
    }
</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="page-header">
        <h2>🗂 Category Management</h2>

        <a href="${pageContext.request.contextPath}/admin/categories?action=add"
           class="btn-add">
            + Add Category
        </a>
    </div>

    <!-- SEARCH -->
    <form method="get" class="search-box">
        <input type="text" name="search" value="${search}"
               placeholder="Search category...">

        <button type="submit">Search</button>
    </form>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th width="90">ID</th>
                <th width="220">Category</th>
                <th>Description</th>
                <th width="180">Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${categories}" var="c">
                <tr>
                    <td>
                        <span class="badge-id">#${c.category_id}</span>
                    </td>

                    <td>
                        <strong>${c.category_name}</strong>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${not empty c.description}">
                                <div class="desc">${c.description}</div>
                            </c:when>
                            <c:otherwise>
                                <span class="desc-empty">No description</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <a class="action-btn btn-edit"
                           href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${c.category_id}">
                            Edit
                        </a>

                        <a class="action-btn btn-delete"
                           href="${pageContext.request.contextPath}/admin/categories?action=delete&id=${c.category_id}"
                           onclick="return confirm('Delete this category?')">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty categories}">
                <tr>
                    <td colspan="4" class="empty-row">
                        📭 No categories found <br>
                        <small>Try search or add new category</small>
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <!-- PAGINATION -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="?page=${i}&search=${search}"
                   class="${i == page ? 'active' : ''}">
                    ${i}
                </a>
            </c:forEach>
        </div>
    </c:if>

</div>