<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<script>
    function goToPage() {
        let input = document.getElementById("pageInput");
        let page = parseInt(input.value);
        let total = ${totalPages};

        if (isNaN(page) || page < 1) {
            page = 1;
        } else if (page > total) {
            page = total;
        }

        const params = new URLSearchParams(window.location.search);
        params.set("page", page);

        window.location.href = "?" + params.toString();
    }
</script>
<div class="page-header">
    <h2>📚 Book Management</h2>

    <div style="display:flex; gap:14px; align-items:center;">

        <!-- SEARCH FORM -->
        <form method="get"
              action="${pageContext.request.contextPath}/admin/books/list"
              class="search-bar">

            <!-- KEYWORD -->
            <input type="text"
                   name="keyword"
                   placeholder="🔍 Search book..."
                   value="${param.keyword}">

            <!-- AUTHOR -->
            <select name="author_id">
                <option value="">All Authors</option>
                <c:forEach items="${authors}" var="a">
                    <option value="${a.author_id}"
                            ${param.author_id == a.author_id ? 'selected' : ''}>
                        ${a.author_name}
                    </option>
                </c:forEach>
            </select>

            <!-- CATEGORY -->
            <select name="category_id">
                <option value="">All Categories</option>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.category_id}"
                            ${param.category_id == c.category_id ? 'selected' : ''}>
                        ${c.category_name}
                    </option>
                </c:forEach>
            </select>

            <!-- STATUS -->
            <select name="status">
                <option value="">All Status</option>
                <option value="Active"
                        ${param.status == 'Active' ? 'selected' : ''}>
                    Active
                </option>
                <option value="Inactive"
                        ${param.status == 'Inactive' ? 'selected' : ''}>
                    Inactive
                </option>
            </select>

            <button type="submit">
                Search
            </button>
        </form>

        <!-- ADD BOOK -->
        <a href="${pageContext.request.contextPath}/admin/books?action=add"
           class="btn-orange">
            + Add New Book
        </a>
    </div>
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
            <th width="160">Actions</th>
        </tr>
    </thead>

    <tbody>
        <c:forEach var="b" items="${books}">
            <tr class="clickable-row"
                onclick="window.location = '${pageContext.request.contextPath}/admin/books/detail?id=${b.bookId}'">

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

                <!-- ACTIONS (STOP PROPAGATION) -->
                <td onclick="event.stopPropagation();">
                    <a class="btn-action btn-delete"
                       title="Xóa"
                       href="${pageContext.request.contextPath}/admin/books?action=delete&id=${b.bookId}"
                       onclick="return confirm('Bạn có chắc muốn xóa sách này?');">
                        🗑
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

<c:if test="${totalPages > 1}">
    <nav class="mt-4">
        <ul class="pagination pagination-custom justify-content-center">

            <!-- FIRST -->
            <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=1&keyword=${keyword}&author_id=${authorId}&category_id=${categoryId}">
                    &laquo;&laquo;
                </a>
            </li>

            <!-- PREV -->
            <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${pageIndex - 1}&keyword=${keyword}&author_id=${authorId}&category_id=${categoryId}">
                    &laquo;
                </a>
            </li>

            <!-- PAGE RANGE -->
            <c:set var="start" value="${pageIndex - 2 < 1 ? 1 : pageIndex - 2}" />
            <c:set var="end" value="${pageIndex + 2 > totalPages ? totalPages : pageIndex + 2}" />

            <c:forEach begin="${start}" end="${end}" var="i">
                <li class="page-item ${i == pageIndex ? 'active' : ''}">
                    <a class="page-link"
                       href="?page=${i}&keyword=${keyword}&author_id=${authorId}&category_id=${categoryId}">
                        ${i}
                    </a>
                </li>
            </c:forEach>

            <!-- NEXT -->
            <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${pageIndex + 1}&keyword=${keyword}&author_id=${authorId}&category_id=${categoryId}">
                    &raquo;
                </a>
            </li>

            <!-- LAST -->
            <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${totalPages}&keyword=${keyword}&author_id=${authorId}&category_id=${categoryId}">
                    &raquo;&raquo;
                </a>
            </li>

        </ul>
    </nav>
</c:if>



</div>

<style>
    .page-container {
        background: #ffffff;
        padding: 28px 30px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 18px 40px rgba(0,0,0,0.08);
    }

    /* HEADER */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }

    .page-header h2 {
        color: #c2410c; /* cam trầm */
        font-weight: 700;
        margin: 0;
        font-size: 24px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* ADD BUTTON */
    .btn-orange {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        border-radius: 999px;
        padding: 10px 24px;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.2s ease;
    }

    .btn-orange:hover {
        transform: translateY(-1px);
        box-shadow: 0 8px 20px rgba(234,88,12,0.45);
        color: #fff;
    }

    /* TABLE */
    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        background: #fff;
        border-radius: 14px;
        overflow: hidden;
        font-size: 14px;
    }

    thead th {
        background: #fff7ed;
        color: #9a3412;
        padding: 14px 14px;
        font-weight: 700;
        border-bottom: 2px solid #fed7aa;
        text-align: left;
    }

    tbody td {
        padding: 14px 14px;
        border-bottom: 1px solid #f3f4f6;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #fff7ed;
    }

    /* STATUS BADGE */
    .status {
        padding: 6px 16px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        display: inline-block;
        text-transform: capitalize;
    }

    .ACTIVE {
        background: #22c55e;
    }

    .INACTIVE {
        background: #9ca3af;
    }

    /* ACTION BUTTON */
    .btn-action {
        padding: 6px 16px;
        border-radius: 999px;
        font-size: 13px;
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

    .Active {
        color: green;

    }

    .Inactive {
        color: gray;
    }

    /* SEARCH BAR */
    /* SEARCH BAR */
    .search-bar {
        display: flex;
        gap: 8px;
        align-items: center;
        flex-wrap: nowrap;
    }

    /* keyword */
    .search-bar input {
        width: 260px;              /* rộng hơn */
        height: 42px;
        padding: 0 14px;
        border-radius: 999px;
        border: 1px solid #fed7aa;
        font-size: 14px;
    }

    /* filter select */
    .search-bar select {
        width: 130px;              /* THU GỌN */
        height: 42px;
        padding: 0 12px;
        border-radius: 999px;
        border: 1px solid #fed7aa;
        font-size: 13px;
        background: #fff;
    }

    /* button */
    .search-bar button {
        height: 42px;
        padding: 0 18px;
        border-radius: 999px;
        border: none;
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .search-bar button:hover {
        box-shadow: 0 8px 20px rgba(234,88,12,0.45);
        transform: translateY(-1px);
    }


    .clickable-row {
        cursor: pointer;
    }

    .clickable-row:hover {
        background: #fff3e0;
    }


    .pagination {
        display: flex !important;
        justify-content: center;
        padding-left: 0;
        list-style: none;
    }

    .pagination .page-item {
        display: inline-block !important;
    }

    .pagination .page-link {
        color: #ea580c;
        border-radius: 8px;
        margin: 0 2px;
        border: 1px solid #fed7aa;
    }

    .pagination .page-item.active .page-link {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        border-color: #ea580c;
        color: #fff;
    }

    .pagination .page-link:hover {
        background-color: #fff7ed;
    }

    .pagination-custom .page-item.disabled .page-link {
        pointer-events: none;
        cursor: not-allowed;
        opacity: 0.4;
    }


    .pagination-custom .page-link {
        color: #ea580c;
        border-radius: 999px;
        margin: 0 4px;
        padding: 6px 14px;
        border: 1px solid #fed7aa;
        font-weight: 600;
        transition: all 0.15s ease;
    }

    .pagination-custom .page-link:hover {
        background: #fff7ed;
        color: #c2410c;
    }

    .pagination-custom .page-item.active .page-link {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        border-color: transparent;
        color: #fff;
    }

    .pagination-custom .page-item.disabled .page-link {
        color: #9ca3af;
        background: #f9fafb;
        border-color: #e5e7eb;
        pointer-events: none;
    }


</style>


