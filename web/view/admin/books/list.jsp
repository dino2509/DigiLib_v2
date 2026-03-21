<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container">

    <!-- HEADER -->
    <div class="header">
        <div>
            <h2>📚 Book Management</h2>
            <span class="sub">Manage your library books</span>
        </div>

        <a href="${pageContext.request.contextPath}/admin/books?action=add"
           class="btn-primary">+ Add Book</a>
    </div>

    <!-- FILTER -->
    <form method="get" class="filter">

        <input type="text" name="keyword"
               placeholder="Search title..."
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
                    <th>ID</th>
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
                            <c:choose>
                                <c:when test="${b.isbn != null}">
                                    <span class="badge">${b.isbn}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="muted">N/A</span>
                                </c:otherwise>
                            </c:choose>
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

    <!-- PAGINATION (FIXED) -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">

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

        </div>
    </c:if>

</div>

<style>
    .container{
        background:#fff;
        padding:30px;
        border-radius:20px;
        box-shadow:0 10px 30px rgba(0,0,0,0.05);
    }

    /* HEADER */
    .header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .sub{
        font-size:13px;
        color:#6b7280;
    }

    /* FILTER */
    .filter{
        display:grid;
        grid-template-columns: 2fr 1fr 1fr 1fr 1fr auto;
        gap:10px;
        margin-bottom:20px;
    }

    .filter input, .filter select{
        height:42px;
        border-radius:10px;
        border:1px solid #ddd;
        padding:0 12px;
    }

    /* BUTTON */
    .btn-primary{
        background:#f97316;
        color:white;
        padding:10px 18px;
        border-radius:999px;
        text-decoration:none;
        font-weight:600;
    }

    .btn-search{
        background:#111827;
        color:white;
        border:none;
        border-radius:10px;
    }

    /* TABLE */
    .table-wrap{
        overflow:auto;
    }

    table{
        width:100%;
        border-collapse:collapse;
    }

    thead{
        background:#f9fafb;
    }

    th{
        text-align:left;
        padding:14px;
        font-size:13px;
        color:#6b7280;
    }

    td{
        padding:14px;
    }

    tbody tr{
        border-top:1px solid #f1f1f1;
        cursor:pointer;
    }

    tbody tr:hover{
        background:#f9fafb;
    }

    /* BADGE */
    .badge{
        background:#f3f4f6;
        padding:4px 10px;
        border-radius:999px;
        font-size:12px;
    }

    /* STATUS */
    .status{
        padding:4px 10px;
        border-radius:999px;
        font-size:12px;
        color:white;
    }

    .ACTIVE{
        background:#22c55e;
    }
    .INACTIVE{
        background:#9ca3af;
    }

    .muted{
        color:#9ca3af;
    }

    /* PAGINATION */
    .pagination{
        margin-top:20px;
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .pagination a{
        padding:6px 12px;
        border-radius:8px;
        background:#f3f4f6;
        text-decoration:none;
    }

    .pagination a.active{
        background:#f97316;
        color:white;
    }

    .pagination a.disabled{
        opacity:0.3;
        pointer-events:none;
    }

    .empty{
        text-align:center;
        padding:40px;
    }
</style>