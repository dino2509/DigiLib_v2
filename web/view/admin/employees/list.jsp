<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .page-wrap{
        max-width:1300px;
        margin:auto;
        background:#fff;
        padding:28px;
        border-radius:18px;
        box-shadow:0 15px 40px rgba(0,0,0,0.06);
    }

    .header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:22px;
    }

    .title{
        font-size:24px;
        font-weight:700;
        color:#ea580c;
    }

    .right-box{
        display:flex;
        gap:10px;
        align-items:center;
    }

    .search-bar{
        display:flex;
        gap:8px;
    }

    .search-bar input{
        height:42px;
        width:260px;
        padding:0 14px;
        border-radius:999px;
        border:1px solid #ddd;
    }

    .search-bar button{
        background:#ea580c;
        color:#fff;
        border:none;
        padding:0 18px;
        border-radius:999px;
        font-weight:600;
    }

    .btn-add{
        background:linear-gradient(135deg,#fb923c,#ea580c);
        color:#fff;
        padding:10px 18px;
        border-radius:999px;
        text-decoration:none;
        font-weight:600;
    }

    table{
        width:100%;
        border-collapse:collapse;
    }

    thead{
        background:#fff7ed;
    }

    th,td{
        padding:14px;
        text-align:left;
    }

    tbody tr:hover{
        background:#fff7ed;
    }

    .avatar{
        width:36px;
        height:36px;
        border-radius:50%;
        object-fit:cover;
        border:2px solid #fed7aa;
    }

    .status{
        padding:5px 12px;
        border-radius:999px;
        color:#fff;
        font-size:12px;
        font-weight:600;
    }

    .ACTIVE{
        background:#22c55e;
    }
    .INACTIVE{
        background:#9ca3af;
    }

    .role{
        background:#f97316;
        color:#fff;
        padding:5px 12px;
        border-radius:999px;
        font-size:12px;
    }

    .action a{
        margin-right:6px;
        padding:6px 12px;
        border-radius:999px;
        color:#fff;
        text-decoration:none;
        font-size:13px;
    }

    .edit{
        background:#f59e0b;
    }
    .delete{
        background:#ef4444;
    }

    .pagination{
        margin-top:20px;
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .pagination a{
        padding:6px 12px;
        border-radius:999px;
        background:#f3f4f6;
        text-decoration:none;
        color:#333;
    }

    .pagination a.active{
        background:#ea580c;
        color:#fff;
    }

    .disabled{
        pointer-events:none;
        opacity:0.4;
    }

    .empty{
        text-align:center;
        padding:30px;
        color:#888;
    }
</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="header">
        <div class="title">👨‍💼 Employee Management</div>

        <div class="right-box">

            <!-- SEARCH -->
            <form method="get" class="search-bar">
                <input type="text"
                       name="keyword"
                       placeholder="Search name or email..."
                       value="${keyword}">
                <button>Search</button>
            </form>

            <a href="${pageContext.request.contextPath}/admin/employees?action=add"
               class="btn-add">
                + Add Employee
            </a>
        </div>
    </div>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Employee</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Role</th>
                <th>Created</th>
                <th>Actions</th>
            </tr>
        </thead>

        <tbody>

            <c:forEach items="${employees}" var="e" varStatus="st">
                <tr>

                    <!-- INDEX -->
                    <td>${(pageIndex-1)*10 + st.index + 1}</td>

                    <!-- NAME -->
                    <td style="display:flex;align-items:center;gap:10px;">
                        <img class="avatar"
                             src="${empty e.avatar ? pageContext.request.contextPath.concat('/img/default.png') 
                                    : pageContext.request.contextPath.concat('/img/avatar/').concat(e.avatar)}">

                        <strong>${e.fullName}</strong>
                    </td>

                    <td>${e.email}</td>
                    <td>${empty e.phone ? '-' : e.phone}</td>

                    <!-- STATUS -->
                    <td>
                        <span class="status ${e.status == 'Active' ? 'ACTIVE' : 'INACTIVE'}">
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

                    <!-- DATE (FIX LocalDateTime) -->
                    <td>${e.createdAt}</td>

                    <!-- ACTION -->
                    <td class="action">
                        <a class="edit"
                           href="${pageContext.request.contextPath}/admin/employees?action=edit&id=${e.employeeId}">
                            Edit
                        </a>

                        <a class="delete"
                           href="${pageContext.request.contextPath}/admin/employees?action=delete&id=${e.employeeId}"
                           onclick="return confirm('Delete this employee?')">
                            Delete
                        </a>
                    </td>

                </tr>
            </c:forEach>

            <c:if test="${empty employees}">
                <tr>
                    <td colspan="8" class="empty">No employees found</td>
                </tr>
            </c:if>

        </tbody>
    </table>

    <!-- PAGINATION -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">

            <!-- PREV -->
            <a href="?page=${pageIndex-1}&keyword=${keyword}"
               class="${pageIndex == 1 ? 'disabled' : ''}">
                ←
            </a>

            <!-- PAGE -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a class="${i == pageIndex ? 'active' : ''}"
                   href="?page=${i}&keyword=${keyword}">
                    ${i}
                </a>
            </c:forEach>

            <!-- NEXT -->
            <a href="?page=${pageIndex+1}&keyword=${keyword}"
               class="${pageIndex == totalPages ? 'disabled' : ''}">
                →
            </a>

        </div>
    </c:if>

</div>