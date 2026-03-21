<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .page-wrap {
        max-width: 1200px;
        margin: auto;
        background: #fff;
        padding: 28px;
        border-radius: 18px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }

    /* HEADER */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .page-header h2 {
        color: #ea580c;
        font-weight: 700;
    }

    .btn-add {
        background: linear-gradient(135deg,#f97316,#ea580c);
        color: #fff;
        padding: 10px 18px;
        border-radius: 999px;
        text-decoration: none;
        font-weight: 600;
    }

    /* SEARCH */
    .search-box {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
    }

    .search-box input {
        flex: 1;
        padding: 10px;
        border-radius: 999px;
        border: 1px solid #ddd;
    }

    .search-box button {
        padding: 10px 16px;
        border-radius: 999px;
        border: none;
        background: #f97316;
        color: white;
        font-weight: 600;
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
        padding: 12px;
        color: #9a3412;
        font-size: 13px;
    }

    tbody td {
        padding: 14px;
        border-bottom: 1px solid #eee;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    /* BADGE */
    .badge {
        background: #fff7ed;
        padding: 4px 10px;
        border-radius: 999px;
        color: #c2410c;
        font-weight: 600;
        font-size: 12px;
    }

    /* BIO */
    .bio {
        color: #4b5563;
        font-size: 13px;
    }

    .bio-empty {
        color: #9ca3af;
        font-style: italic;
    }

    /* ACTION */
    .action-btn {
        padding: 6px 12px;
        border-radius: 999px;
        color: #fff;
        font-size: 12px;
        text-decoration: none;
        font-weight: 600;
    }

    .btn-edit {
        background: #f59e0b;
    }
    .btn-delete {
        background: #dc2626;
    }

    /* EMPTY */
    .empty {
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
        padding: 8px 14px;
        margin: 0 3px;
        border-radius: 999px;
        text-decoration: none;
        background: #f3f4f6;
        color: #333;
        font-weight: 600;
    }

    .pagination a.active {
        background: #f97316;
        color: white;
    }
</style>

<div class="page-wrap">

    <!-- HEADER -->
    <div class="page-header">
        <h2>✍️ Author Management</h2>

        <a href="${pageContext.request.contextPath}/admin/authors?action=add"
           class="btn-add">
            + Add Author
        </a>
    </div>

    <!-- SEARCH -->
    <form method="get" class="search-box">
        <input type="text" name="search" value="${search}"
               placeholder="Search author...">
        <button>Search</button>
    </form>

    <!-- TABLE -->
    <table>
        <thead>
            <tr>
                <th width="80">ID</th>
                <th width="220">Name</th>
                <th>Bio</th>
                <th width="180">Actions</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach items="${authors}" var="a">
                <tr>
                    <td><span class="badge">#${a.author_id}</span></td>

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
                           onclick="return confirm('Delete this author?')">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty authors}">
                <tr>
                    <td colspan="4" class="empty">
                        📭 No authors found <br>
                        <small>Try another keyword</small>
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