<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .page-wrap {
        max-width: 1300px;
        margin: 0 auto;
        background: #ffffff;
        padding: 32px 34px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 20px 44px rgba(0,0,0,0.08);
    }

    /* HEADER */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 26px;
    }

    .page-header h2 {
        margin: 0;
        font-size: 24px;
        font-weight: 700;
        color: #c2410c; /* cam trầm */
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* ADD BUTTON */
    .btn-add {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        padding: 10px 26px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
    }

    .btn-add:hover {
        transform: translateY(-1px);
        box-shadow: 0 10px 24px rgba(234,88,12,0.45);
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
        padding: 14px 16px;
        border-bottom: 2px solid #fed7aa;
        text-align: left;
    }

    tbody td {
        padding: 14px 16px;
        border-bottom: 1px solid #f3f4f6;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    /* STATUS BADGE */
    .badge-status {
        padding: 6px 16px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        display: inline-block;
        text-transform: capitalize;
    }

    .ACTIVE {
        background: #22c55e; /* xanh dịu */
    }

    .INACTIVE {
        background: #9ca3af;
    }

    /* ROLE BADGE */
    .badge-role {
        padding: 6px 16px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        display: inline-block;
    }

    .ROLE_ADMIN {
        background: #ef4444; /* đỏ dịu hơn */
    }

    .ROLE_READER {
        background: #f97316; /* cam */
    }

    /* ACTION */
    .action-btn {
        padding: 6px 16px;
        font-size: 13px;
        border-radius: 999px;
        text-decoration: none;
        color: #fff;
        font-weight: 600;
        margin-right: 6px;
        transition: all 0.15s ease;
    }

    .btn-edit {
        background: #f59e0b;
    }

    .btn-delete {
        background: #ef4444;
    }

    .btn-edit:hover {
        background: #d97706;
        transform: translateY(-1px);
    }

    .btn-delete:hover {
        background: #dc2626;
        transform: translateY(-1px);
    }

    /* EMPTY */
    .empty-row {
        text-align: center;
        padding: 34px;
        color: #6b7280;
        font-style: italic;
    }

</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="page-header">
        <h2>👤 Reader Management</h2>

        <a href="${pageContext.request.contextPath}/admin/readers?action=add"
           class="btn-add">
            + Add Reader
        </a>
    </div>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th width="70">ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th width="140">Phone</th>
                <th width="120">Status</th>
                <th width="120">Role</th>
                <th width="160">Created At</th>
                <th width="200">Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${readers}" var="r">
                <tr>
                    <td>${r.readerId}</td>
                    <td><strong>${r.fullName}</strong></td>
                    <td>${r.email}</td>
                    <td>${r.phone}</td>

                    <td>
                        <span class="badge-status ${r.status == 'active' ? 'ACTIVE' : 'INACTIVE'}">
                            ${r.status}
                        </span>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${r.roleId == 1}">
                                <span class="badge-role ROLE_ADMIN">Admin</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-role ROLE_READER">Reader</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>${r.createdAt}</td>

                    <td>
                        <a class="action-btn btn-edit"
                           href="${pageContext.request.contextPath}/admin/readers?action=edit&id=${r.readerId}">
                            Edit
                        </a>

                        <a class="action-btn btn-delete"
                           href="${pageContext.request.contextPath}/admin/readers?action=delete&id=${r.readerId}"
                           onclick="return confirm('Bạn có chắc muốn xóa reader này?')">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty readers}">
                <tr>
                    <td colspan="8" class="empty-row">
                        Không có Reader nào
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>
