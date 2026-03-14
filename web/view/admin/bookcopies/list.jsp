<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    .page-wrap{
        max-width:1200px;
        margin:auto;
        background:#fff;
        padding:28px;
        border-radius:16px;
        border:1px solid #fed7aa;
    }

    .page-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .btn-add{
        background:#f97316;
        padding:10px 18px;
        border-radius:999px;
        color:white;
        text-decoration:none;
        font-weight:600;
    }

    .filter-bar{
        display:flex;
        gap:10px;
        align-items:center;
        margin-bottom:20px;
    }

    .filter-bar input,
    .filter-bar select{
        padding:6px 10px;
        border-radius:8px;
        border:1px solid #ddd;
    }

    .btn-filter{
        background:#f97316;
        color:white;
        border:none;
        padding:6px 12px;
        border-radius:6px;
    }

    .btn-clear{
        background:#e5e7eb;
        padding:6px 12px;
        border-radius:6px;
        text-decoration:none;
    }

    table{
        width:100%;
        border-collapse:collapse;
    }

    thead th{
        background:#fff7ed;
        padding:12px;
        color:#9a3412;
    }

    tbody td{
        padding:12px;
        border-bottom:1px solid #eee;
        text-align:center;
    }

    .badge-status{
        padding:4px 12px;
        border-radius:999px;
        font-size:12px;
        color:white;
        font-weight:600;
    }

    .AVAILABLE{
        background:#16a34a;
    }
    .BORROWED{
        background:#f59e0b;
    }

    .action-group{
        display:flex;
        justify-content:center;
        gap:8px;
    }

    .action-btn{
        padding:6px 12px;
        border-radius:999px;
        color:white;
        text-decoration:none;
        font-size:13px;
    }

    .btn-edit{
        background:#f59e0b;
    }
    .btn-delete{
        background:#dc2626;
    }

    .pagination{
        margin-top:25px;
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .page-btn{
        padding:6px 12px;
        border-radius:6px;
        border:1px solid #ddd;
        text-decoration:none;
        color:#374151;
    }

    .page-btn.active{
        background:#f97316;
        color:white;
        border:none;
    }

    .book-title{
        font-weight:600;
    }

    .book-id{
        font-size:12px;
        color:#6b7280;
    }

</style>


<div class="page-wrap">

    <div class="page-header">

        <h2>📚 Book Copy Management</h2>

        <a href="${pageContext.request.contextPath}/admin/bookcopies?action=add"
           class="btn-add">
            + Add Book Copy
        </a>

    </div>


    <!-- FILTER -->

    <form method="get"
          action="${pageContext.request.contextPath}/admin/bookcopies/list"
          class="filter-bar">

        <span>Book ID:</span>

        <input type="number"
               name="book_id"
               value="${bookId}"/>

        <span>Status:</span>

        <select name="status">

            <option value="">All</option>

            <option value="AVAILABLE"
                    <c:if test="${status eq 'AVAILABLE'}">selected</c:if>>
                        Available
                    </option>

                    <option value="BORROWED"
                    <c:if test="${status eq 'BORROWED'}">selected</c:if>>
                        Borrowed
                    </option>

            </select>

            <button class="btn-filter">Filter</button>

            <a href="${pageContext.request.contextPath}/admin/bookcopies/list"
           class="btn-clear">
            Clear
        </a>

    </form>


    <table>

        <thead>

            <tr>
                <th>ID</th>
                <th>Book</th>
                <th>Copy Code</th>
                <th>Status</th>
                <th>Created</th>
                <th width="220">Actions</th>
            </tr>

        </thead>

        <tbody>

            <c:forEach items="${bookCopies}" var="c">

                <tr>

                    <td>${c.copyId}</td>

                    <td>

                        <div class="book-title">${c.bookTitle}</div>
                        <div class="book-id">ID: ${c.bookId}</div>

                    </td>

                    <td><b>${c.copyCode}</b></td>

                    <td>

                        <span class="badge-status ${c.status}">
                            ${c.status}
                        </span>

                    </td>

                    <td>${c.createdAt}</td>

                    <td>

                        <div class="action-group">

                            <a class="action-btn btn-edit"
                               href="${pageContext.request.contextPath}/admin/bookcopies?action=edit&id=${c.copyId}">
                                Edit
                            </a>

                            <c:if test="${c.status ne 'BORROWED'}">

                                <a class="action-btn btn-delete"
                                   href="${pageContext.request.contextPath}/admin/bookcopies?action=delete&id=${c.copyId}"
                                   onclick="return confirm('Deactivate this copy?')">
                                    Deactivate
                                </a>

                            </c:if>

                            <c:if test="${c.status eq 'BORROWED'}">

                                <span style="color:#6b7280">(Borrowed)</span>

                            </c:if>

                        </div>

                    </td>

                </tr>

            </c:forEach>


            <c:if test="${empty bookCopies}">
                <tr>
                    <td colspan="6">No copies found</td>
                </tr>
            </c:if>

        </tbody>

    </table>



    <!-- PAGINATION -->

    <c:if test="${totalPages > 1}">
        <div class="pagination">

            <c:forEach begin="1" end="${totalPages}" var="p">

                <a class="page-btn <c:if test='${p == page}'>active</c:if>"
                   href="${pageContext.request.contextPath}/admin/bookcopies/list?page=${p}
                   <c:if test='${not empty bookId}'>&book_id=${bookId}</c:if>
                   <c:if test='${not empty status}'>&status=${status}</c:if>">

                   ${p}

                </a>

            </c:forEach>

        </div>
    </c:if>

</div>