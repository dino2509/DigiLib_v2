<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="container">

    <!-- HEADER -->
    <div class="header">
        <div>
            <h2>📚 Book Management</h2>
            <span class="sub">Manage your digital library</span>
        </div>

        <a href="${pageContext.request.contextPath}/admin/books?action=add"
           class="btn-primary">+ Add Book</a>
    </div>

    <!-- FILTER -->
    <form method="get" class="filter">

        <input type="text" name="keyword"
               placeholder="🔍 Search title..."
               value="${keyword}">

        <input type="number" name="isbn"
               placeholder="ISBN..."
               value="${isbn}">

        <select name="author_id">
            <option value="">Author</option>
            <c:forEach items="${authors}" var="a">
                <option value="${a.author_id}"
                        ${authorId == a.author_id ? 'selected' : ''}>
                    ${a.author_name}
                </option>
            </c:forEach>
        </select>

        <select name="category_id">
            <option value="">Category</option>
            <c:forEach items="${categories}" var="c">
                <option value="${c.category_id}"
                        ${categoryId == c.category_id ? 'selected' : ''}>
                    ${c.category_name}
                </option>
            </c:forEach>
        </select>

        <select name="status">
            <option value="">Status</option>
            <option value="ACTIVE" ${status=='ACTIVE'?'selected':''}>Active</option>
            <option value="INACTIVE" ${status=='INACTIVE'?'selected':''}>Inactive</option>
        </select>

        <button class="btn-search">Search</button>

    </form>

    <!-- TABLE -->
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Book</th>
                    <th>ISBN</th>
                    <th>Price</th>
                    <th>Category</th>
                    <th>Author</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th></th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="b" items="${books}">
                    <tr onclick="location.href = '${pageContext.request.contextPath}/admin/books/detail?id=${b.bookId}'">

                        <td class="id">#${b.bookId}</td>

                        <td class="title">
                            <strong>${b.title}</strong>
                        </td>

                        <td>
                            <span class="badge">${b.isbn != null ? b.isbn : 'N/A'}</span>
                        </td>

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

                        <td>
                            <fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy"/>
                        </td>

                        <td onclick="event.stopPropagation();">
                            <a class="btn-delete"
                               href="${pageContext.request.contextPath}/admin/books?action=delete&id=${b.bookId}"
                               onclick="return confirm('Delete book?')">
                                🗑
                            </a>
                        </td>

                    </tr>
                </c:forEach>

                <c:if test="${empty books}">
                    <tr>
                        <td colspan="9" class="empty">
                            📭 No books found
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- PAGINATION PRO -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">

            <!-- FIRST -->
            <a class="${pageIndex == 1 ? 'disabled' : ''}"
               href="?page=1&keyword=${keyword}&isbn=${isbn}&author_id=${authorId}&category_id=${categoryId}&status=${status}">
                «
            </a>

            <!-- PREV -->
            <a class="${pageIndex == 1 ? 'disabled' : ''}"
               href="?page=${pageIndex-1}&keyword=${keyword}&isbn=${isbn}&author_id=${authorId}&category_id=${categoryId}&status=${status}">
                ←
            </a>

            <!-- RANGE -->
            <c:set var="start" value="${pageIndex-2 < 1 ? 1 : pageIndex-2}" />
            <c:set var="end" value="${pageIndex+2 > totalPages ? totalPages : pageIndex+2}" />

            <c:forEach begin="${start}" end="${end}" var="i">
                <a class="${i == pageIndex ? 'active' : ''}"
                   href="?page=${i}&keyword=${keyword}&isbn=${isbn}&author_id=${authorId}&category_id=${categoryId}&status=${status}">
                    ${i}
                </a>
            </c:forEach>

            <!-- NEXT -->
            <a class="${pageIndex == totalPages ? 'disabled' : ''}"
               href="?page=${pageIndex+1}&keyword=${keyword}&isbn=${isbn}&author_id=${authorId}&category_id=${categoryId}&status=${status}">
                →
            </a>

            <!-- LAST -->
            <a class="${pageIndex == totalPages ? 'disabled' : ''}"
               href="?page=${totalPages}&keyword=${keyword}&isbn=${isbn}&author_id=${authorId}&category_id=${categoryId}&status=${status}">
                »
            </a>

        </div>
    </c:if>

</div>

<style>
    .container{
        background:#fff;
        padding:30px;
        border-radius:20px;
        box-shadow:0 12px 40px rgba(0,0,0,0.08);
    }

    /* HEADER */
    .header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:24px;
    }

    .sub{
        font-size:13px;
        color:#6b7280;
    }

    /* FILTER */
    .filter{
        display:grid;
        grid-template-columns:2fr 1fr 1fr 1fr 1fr auto;
        gap:12px;
        margin-bottom:24px;
    }

    .filter input, .filter select{
        height:44px;
        border-radius:12px;
        border:1px solid #ddd;
        padding:0 12px;
        transition:0.2s;
    }

    .filter input:focus, .filter select:focus{
        border-color:#f97316;
        box-shadow:0 0 0 3px rgba(249,115,22,0.2);
    }

    /* BUTTON */
    .btn-primary{
        background:linear-gradient(135deg,#fb923c,#ea580c);
        color:white;
        padding:10px 18px;
        border-radius:999px;
        text-decoration:none;
        font-weight:600;
    }

    .btn-search{
        background:#ea580c;
        color:white;
        border:none;
        border-radius:12px;
    }
    .btn-delete {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;

        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: #fff;

        padding: 8px 14px;
        border-radius: 999px;

        font-size: 13px;
        font-weight: 600;
        text-decoration: none;

        transition: all 0.2s ease;
    }

    /* HOVER */
    .btn-delete:hover {
        transform: translateY(-1px);
        box-shadow: 0 8px 20px rgba(220,38,38,0.4);
        background: linear-gradient(135deg, #dc2626, #b91c1c);
    }

    /* ACTIVE (click) */
    .btn-delete:active {
        transform: scale(0.95);
    }

    /* DISABLED */
    .btn-delete.disabled {
        opacity: 0.4;
        pointer-events: none;
    }

    /* TABLE */
    table{
        width:100%;
        border-collapse:collapse;
    }

    thead{
        background:#fff7ed;
    }

    th{
        padding:14px;
        font-size:13px;
        color:#9a3412;
    }

    td{
        padding:14px;
    }

    tbody tr{
        border-top:1px solid #f1f1f1;
        transition:0.2s;
    }

    tbody tr:hover{
        background:#fff7ed;
        transform:scale(1.01);
    }

    /* STATUS */
    .status{
        padding:5px 12px;
        border-radius:999px;
        font-size:12px;
        color:white;
    }

    .active{
        background:#22c55e;
    }
    .Active{
        background:#22c55e;
    }
    .inactive{
        background:#9ca3af;
    }
    .Inactive{
        background:#9ca3af;
    }

    /* BADGE */
    .badge{
        background:#f3f4f6;
        padding:4px 10px;
        border-radius:999px;
    }

    /* PAGINATION */
    .pagination{
        margin-top:24px;
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .pagination a{
        padding:8px 14px;
        border-radius:10px;
        background:#fff;
        border:1px solid #fed7aa;
        color:#ea580c;
        font-weight:600;
        text-decoration:none;
        transition:0.2s;
    }

    .pagination a:hover{
        background:#fff7ed;
    }

    .pagination a.active{
        background:#ea580c;
        color:white;
    }

    .pagination a.disabled{
        opacity:0.3;
        pointer-events:none;
    }

    .empty{
        text-align:center;
        padding:40px;
        color:#9ca3af;
    }
</style>