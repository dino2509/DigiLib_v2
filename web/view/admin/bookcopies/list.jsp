<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .page-wrap {
        max-width: 1200px;
        margin: 0 auto;
        background: #ffffff;
        padding: 28px 30px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 16px 36px rgba(0,0,0,0.08);
    }

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
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .btn-add {
        background: linear-gradient(135deg, #f97316, #ea580c);
        color: #fff;
        padding: 10px 22px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
    }

    .btn-add:hover {
        box-shadow: 0 6px 18px rgba(249,115,22,0.45);
        color: #fff;
    }

    /* FILTER */
    .filter-bar {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 20px;
    }

    .filter-bar input {
        width: 120px;
        padding: 6px 10px;
        border-radius: 8px;
        border: 1px solid #ddd;
        font-size: 14px;
    }

    .filter-bar button,
    .filter-bar a {
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 14px;
        text-decoration: none;
        border: none;
        cursor: pointer;
    }

    .btn-filter {
        background: #f97316;
        color: #fff;
    }

    .btn-clear {
        background: #e5e7eb;
        color: #374151;
    }

    /* TABLE */
    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        font-size: 14px;
    }

    thead th {
        background: #fff7ed;
        color: #9a3412;
        font-weight: 700;
        padding: 14px 12px;
        border-bottom: 2px solid #fed7aa;
        text-align: center;
    }

    tbody td {
        padding: 14px 12px;
        border-bottom: 1px solid #f1f1f1;
        text-align: center;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    /* STATUS */
    .badge-status {
        padding: 5px 14px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        display: inline-block;
    }

    .AVAILABLE {
        background: #16a34a;
    }
    .BORROWED {
        background: #f59e0b;
    }
    .LOST {
        background: #dc2626;
    }
    .DAMAGED {
        background: #92400e;
    }
    .INACTIVE {
        background: #9ca3af;
    }

    /* ACTION */
    .action-btn {
        padding: 6px 12px;
        font-size: 13px;
        border-radius: 999px;
        text-decoration: none;
        color: #fff;
        font-weight: 600;
        margin: 0 3px;
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

    .text-muted {
        color: #6b7280;
        font-style: italic;
    }

    .empty-row {
        padding: 30px;
        text-align: center;
        color: #6b7280;
        font-style: italic;
    }
</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="page-header">
        <h2>📚 Book Copy Management</h2>

        <a href="${pageContext.request.contextPath}/admin/bookcopies?action=add"
           class="btn-add">
            + Add Book Copy
        </a>
    </div>

    <!-- FILTER -->
    <form method="get"
          action="${pageContext.request.contextPath}/admin/bookcopies/list"
          class="filter-bar">

        <span>Book ID:</span>
        <input type="number" name="book_id" value="${bookId}"/>

        <button type="submit" class="btn-filter">Filter</button>
        <a href="${pageContext.request.contextPath}/admin/bookcopies/list"
           class="btn-clear">Clear</a>
    </form>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Book ID</th>
                <th>Copy Code</th>
                <th>Status</th>
                <th>Created At</th>
                <th width="200">Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${bookCopies}" var="c">
                <tr>
                    <td>${c.copyId}</td>
                    <td>${c.bookId}</td>
                    <td><strong>${c.copyCode}</strong></td>

                    <td>
                        <span class="badge-status ${c.status}">
                            ${c.status}
                        </span>
                    </td>

                    <td>${c.createdAt}</td>

                    <td>
                        <a class="action-btn btn-edit"
                           href="${pageContext.request.contextPath}/admin/bookcopies?action=edit&id=${c.copyId}">
                            ✏ Edit
                        </a>

                        <c:if test="${c.status ne 'BORROWED'}">
                            <a class="action-btn btn-delete"
                               href="${pageContext.request.contextPath}/admin/bookcopies?action=delete&id=${c.copyId}"
                               onclick="return confirm('Deactivate this book copy?');">
                                ❌ Deactivate
                            </a>
                        </c:if>

                        <c:if test="${c.status eq 'BORROWED'}">
                            <span class="text-muted">(Borrowed)</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty bookCopies}">
                <tr>
                    <td colspan="6" class="empty-row">
                        No book copies found.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>
