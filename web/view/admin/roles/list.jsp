<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .page-wrap {
        max-width: 900px;
        margin: 0 auto;
        background: #ffffff;
        padding: 30px 32px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 18px 40px rgba(0,0,0,0.08);
    }

    /* ===== HEADER ===== */
    .page-header {
        display: flex;
        justify-content: space-between; /* ĐẨY NÚT SANG PHẢI */
        align-items: center;
        margin-bottom: 22px;
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

    /* ===== BUTTON ===== */
    .btn-add {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        padding: 10px 26px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
        white-space: nowrap;
    }

    .btn-add:hover {
        box-shadow: 0 8px 20px rgba(234,88,12,0.45);
        transform: translateY(-1px);
        color: #fff;
    }

    /* ===== TABLE ===== */
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

    .badge-role {
        padding: 6px 16px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        background: #f97316;
        display: inline-block;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .desc {
        color: #4b5563;
        font-style: italic;
    }

    .empty-row {
        text-align: center;
        padding: 32px;
        color: #6b7280;
        font-style: italic;
    }
</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="page-header">
        <h2>🔐 Role Management</h2>

        <a href="${pageContext.request.contextPath}/admin/employees?action=add"
           class="btn-add">
            ⬆ Promote Reader
        </a>
    </div>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th width="80">ID</th>
                <th width="220">Role Name</th>
                <th>Description</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${roles}" var="r">
                <tr>
                    <td>${r.roleId}</td>

                    <td>
                        <span class="badge-role">
                            ${r.roleName}
                        </span>
                    </td>

                    <td class="desc">
                        <c:choose>
                            <c:when test="${not empty r.description}">
                                ${r.description}
                            </c:when>
                            <c:otherwise>
                                No description
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty roles}">
                <tr>
                    <td colspan="3" class="empty-row">
                        No roles found.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

</div>
