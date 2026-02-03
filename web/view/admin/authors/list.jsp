<%@ page contentType="text/html;charset=UTF-8" %>
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
        margin-bottom: 22px;
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
        text-align: left;
    }

    tbody td {
        padding: 14px 12px;
        border-bottom: 1px solid #f1f1f1;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    .bio {
        color: #4b5563;
        font-size: 13px;
        line-height: 1.4;
    }

    .bio-empty {
        font-style: italic;
        color: #9ca3af;
    }

    /* ACTION */
    .action-btn {
        padding: 6px 14px;
        font-size: 13px;
        border-radius: 999px;
        text-decoration: none;
        color: #fff;
        font-weight: 600;
        margin-right: 6px;
    }

    .btn-edit {
        background: #f59e0b;
    }

    .btn-delete {
        background: #dc2626;
    }

    .btn-edit:hover {
        background: #d97706;
        color: #fff;
    }

    .btn-delete:hover {
        background: #b91c1c;
        color: #fff;
    }

    .empty-row {
        text-align: center;
        padding: 30px;
        color: #6b7280;
        font-style: italic;
    }
</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="page-header">
        <h2>✍️ Author Management</h2>

        <a href="${pageContext.request.contextPath}/admin/authors?action=add"
           class="btn-add">
            + Add New Author
        </a>
    </div>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th width="80">ID</th>
                <th width="220">Author Name</th>
                <th>Bio</th>
                <th width="180">Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${authors}" var="a">
                <tr>
                    <td>${a.author_id}</td>
                    <td><strong>${a.author_name}</strong></td>

                    <td>
                        <c:choose>
                            <c:when test="${not empty a.bio}">
                                <div class="bio">${a.bio}</div>
                            </c:when>
                            <c:otherwise>
                                <span class="bio-empty">No bio</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <a class="action-btn btn-edit"
                           href="${pageContext.request.contextPath}/admin/authors?action=edit&id=${a.author_id}">
                            Edit
                        </a>

                        <a class="action-btn btn-delete"
                           href="${pageContext.request.contextPath}/admin/authors?action=delete&id=${a.author_id}"
                           onclick="return confirm('Are you sure you want to delete this author?')">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty authors}">
                <tr>
                    <td colspan="4" class="empty-row">
                        No authors found.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>
