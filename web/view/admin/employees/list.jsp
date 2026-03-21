<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .page-wrap {
        max-width: 1400px;
        margin: 0 auto;
        background: #fff;
        padding: 28px 32px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 20px 50px rgba(0,0,0,0.08);
    }

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 12px;
    }

    .page-header h2 {
        font-size: 24px;
        font-weight: 700;
        color: #c2410c;
    }

    /* SEARCH */
    .search-bar {
        display: flex;
        gap: 8px;
    }

    .search-bar input {
        height: 42px;
        padding: 0 14px;
        border-radius: 999px;
        border: 1px solid #fed7aa;
        width: 260px;
    }

    .search-bar button {
        background: linear-gradient(135deg,#fb923c,#ea580c);
        color: white;
        border: none;
        padding: 0 18px;
        border-radius: 999px;
        font-weight: 600;
    }

    .btn-add {
        background: linear-gradient(135deg,#fb923c,#ea580c);
        color: #fff;
        padding: 10px 22px;
        border-radius: 999px;
        text-decoration: none;
        font-weight: 600;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }

    thead {
        background: #fff7ed;
    }

    th, td {
        padding: 14px;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    /* AVATAR */
    .avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #fed7aa;
    }

    .badge {
        padding: 5px 14px;
        border-radius: 999px;
        font-size: 12px;
        color: #fff;
    }

    .ACTIVE {
        background: #22c55e;
    }
    .INACTIVE {
        background: #9ca3af;
    }

    .role {
        background: #f97316;
        color: white;
        padding: 5px 12px;
        border-radius: 999px;
        font-size: 12px;
    }

    .btn-action {
        padding: 6px 14px;
        border-radius: 999px;
        color: white;
        text-decoration: none;
        font-size: 13px;
        margin-right: 4px;
    }

    .btn-edit {
        background: #f59e0b;
    }
    .btn-delete {
        background: #ef4444;
    }

    /* PAGINATION */
    .pagination {
        text-align: center;
        margin-top: 20px;
    }

    .pagination a {
        margin: 0 4px;
        padding: 6px 12px;
        border-radius: 999px;
        background: #f3f4f6;
        text-decoration: none;
    }

    .pagination a.active {
        background: #ea580c;
        color: white;
    }
</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="page-header">

        <h2>🧑‍💼 Employee Management</h2>

        <div style="display:flex; gap:10px; align-items:center;">

            <!-- SEARCH -->
            <form method="get" class="search-bar">
                <input type="text" name="keyword"
                       placeholder="Search name / email..."
                       value="${keyword}">
                <button>Search</button>
            </form>

            <a href="${pageContext.request.contextPath}/admin/employees?action=add"
               class="btn-add">
                + Add
            </a>

        </div>
    </div>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th>#</th>
                <!--<th>Avatar</th>-->
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Role</th>
                <th>Created</th>
                <th>Action</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${employees}" var="e" varStatus="st">

                <tr>
                    <td>${st.count} - #${e.employeeId}</td>

                    <!-- AVATAR -->
<!--                    <td>
                        <img class="avatar"
                             src="${pageContext.request.contextPath}/img/avatar/${e.avatar != null ? e.avatar : 'default.png'}">
                    </td>-->

                    <td><strong>${e.fullName}</strong></td>

                    <td>${e.email}</td>

                    <td>${e.phone}</td>

                    <td>
                        <span class="badge ${e.status == 'Active' ? 'ACTIVE' : 'INACTIVE'}">
                            ${e.status}
                        </span>
                    </td>

                    <!-- ROLE -->
                    <td>
                        <c:forEach items="${roles}" var="r">
                            <c:if test="${r.roleId == e.roleId}">
                                <span class="role">${r.roleName}</span>
                            </c:if>
                        </c:forEach>
                    </td>

                    <!-- DATE -->
                    <td>
                        ${e.createdAt}
                        
                    </td>

                    <!-- ACTION -->
                    <td>
                        <a class="btn-action btn-edit"
                           href="${pageContext.request.contextPath}/admin/employees?action=edit&id=${e.employeeId}">
                            Edit
                        </a>

                        <a class="btn-action btn-delete"
                           href="${pageContext.request.contextPath}/admin/employees?action=delete&id=${e.employeeId}"
                           onclick="return confirm('Delete this employee?')">
                            Delete
                        </a>
                    </td>

                </tr>

            </c:forEach>

            <c:if test="${empty employees}">
                <tr>
                    <td colspan="9" style="text-align:center;padding:30px;">
                        No employees found
                    </td>
                </tr>
            </c:if>

        </tbody>
    </table>

    <!-- PAGINATION -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a class="${i == pageIndex ? 'active' : ''}"
                   href="?page=${i}&keyword=${keyword}">
                    ${i}
                </a>
            </c:forEach>
        </div>
    </c:if>

</div>