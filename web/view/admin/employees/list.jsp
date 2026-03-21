<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .page-wrap {
        max-width: 1300px;
        margin: 0 auto;
        background: #ffffff;
        padding: 30px 32px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 18px 40px rgba(0,0,0,0.08);
    }

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }

    .page-header h2 {
        margin: 0;
        font-size: 24px;
        font-weight: 700;
        color: #c2410c;
        display: flex;
        align-items: center;
        gap: 10px;
    }

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

    /* BADGE */
    .badge-status {
        padding: 6px 16px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        display: inline-block;
        text-transform: capitalize;
    }

    .ACTIVE { background: #22c55e; }
    .INACTIVE { background: #9ca3af; }

    .badge-role {
        padding: 6px 16px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        display: inline-block;
        background: #f97316;
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
        <h2>🧑‍💼 Employee Management</h2>

        <a href="${pageContext.request.contextPath}/admin/employees?action=add"
           class="btn-add">
            + Add Employee
        </a>
    </div>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th width="70">#</th>
                <th>Full Name</th>
                <th>Email</th>
                <th width="120">Status</th>
                <th width="180">Role</th>
                <th width="160">Created At</th>
                <th width="200">Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${employees}" var="e" varStatus="st">
                <tr>
                    <td>${st.count}</td>
                    <td><strong>${e.fullName}</strong></td>
                    <td>${e.email}</td>

                    <td>
                        <span class="badge-status ${e.status == 'active' ? 'ACTIVE' : 'INACTIVE'}">
                            ${e.status}
                        </span>
                    </td>

                    <td>
                        <c:forEach items="${roles}" var="r">
                            <c:if test="${r.roleId == e.roleId}">
                                <span class="badge-role">${r.roleName}</span>
                            </c:if>
                        </c:forEach>
                    </td>

                    <td>${e.createdAt}</td>

                    <td>
                        <a class="action-btn btn-edit"
                           href="${pageContext.request.contextPath}/admin/employees?action=edit&id=${e.employeeId}">
                            Edit
                        </a>

                        <a class="action-btn btn-delete"
                           href="${pageContext.request.contextPath}/admin/employees?action=delete&id=${e.employeeId}"
                           onclick="return confirm('Are you sure?');">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty employees}">
                <tr>
                    <td colspan="7" class="empty-row">
                        No employees found.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>
