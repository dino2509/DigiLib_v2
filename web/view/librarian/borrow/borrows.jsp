<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

    .borrow-wrapper{
        background:white;
        padding:20px;
        border-radius:8px;
        box-shadow:0 2px 8px rgba(0,0,0,0.06);
    }

    /* HEADER */

    .page-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .page-header h2{
        font-size:22px;
        color:#444;
    }

    /* FILTER */

    .filter-box{
        display:flex;
        gap:10px;
    }

    .filter-box input,
    .filter-box select{
        padding:8px 10px;
        border:1px solid #ddd;
        border-radius:4px;
        font-size:14px;
    }

    .btn-search{
        background:#ff7a00;
        border:none;
        color:white;
        padding:8px 12px;
        border-radius:4px;
        cursor:pointer;
        transition:0.2s;
    }

    .btn-search:hover{
        background:#e56700;
    }

    /* TABLE */

    .table-box{
        overflow-x:auto;
    }

    .borrow-table{
        width:100%;
        border-collapse:collapse;
        background:white;
    }

    .borrow-table thead{
        position:sticky;
        top:0;
        background:#ff7a00;
        color:white;
    }

    .borrow-table th{
        padding:12px;
        text-align:left;
        font-size:14px;
    }

    .borrow-table td{
        padding:12px;
        border-bottom:1px solid #eee;
        font-size:14px;
    }

    .borrow-table tr:hover{
        background:#fff5ed;
    }

    /* ID */

    .borrow-id{
        font-weight:600;
        color:#ff7a00;
    }

    /* READER */

    .reader-cell{
        display:flex;
        gap:6px;
        align-items:center;
    }

    /* STATUS */

    .status{
        padding:4px 10px;
        border-radius:20px;
        font-size:12px;
        font-weight:600;
        display:inline-flex;
        gap:4px;
        align-items:center;
    }

    .borrowing{
        background:#fff3cd;
        color:#856404;
    }

    .returned{
        background:#d4edda;
        color:#155724;
    }

    /* ACTION BUTTONS */

    .actions{
        display:flex;
        gap:6px;
    }

    .btn{
        padding:6px 10px;
        border-radius:4px;
        text-decoration:none;
        font-size:13px;
        display:flex;
        align-items:center;
        gap:4px;
    }

    .btn.view{
        background:#17a2b8;
        color:white;
    }

    .btn.return{
        background:#28a745;
        color:white;
    }

    .btn.extend{
        background:#ffc107;
        color:#333;
    }

    /* EMPTY */

    .empty{
        text-align:center;
        padding:30px;
        color:#999;
    }

    .empty i{
        font-size:28px;
        margin-bottom:8px;
        display:block;
    }

    /* PAGINATION */

    .pagination{
        margin-top:25px;
        display:flex;
        justify-content:center;
        align-items:center;
        gap:6px;
    }

    .page-btn{
        padding:6px 12px;
        background:#eee;
        border-radius:4px;
        text-decoration:none;
        color:#333;
        font-size:14px;
        transition:0.2s;
    }

    .page-btn:hover{
        background:#ff7a00;
        color:white;
    }

    .page-btn.active{
        background:#ff7a00;
        color:white;
        font-weight:bold;
    }

</style>



<div class="borrow-wrapper">

    <div class="page-header">

        <h2>Borrow Records</h2>

        <form class="filter-box"
              method="get"
              action="${pageContext.request.contextPath}/librarian/borrows">

            <input type="text"
                   name="search"
                   value="${param.search}"
                   placeholder="Search reader or borrow ID">

            <select name="status">

                <option value="">All Status</option>

                <option value="BORROWING"
                        <c:if test="${param.status=='BORROWING'}">selected</c:if>>
                            Borrowing
                        </option>

                        <option value="RETURNED"
                        <c:if test="${param.status=='RETURNED'}">selected</c:if>>
                            Returned
                        </option>

                </select>

                <button type="submit" class="btn-search">
                    <i class="fa-solid fa-search"></i>
                </button>

            </form>

        </div>



        <div class="table-box">

            <table class="borrow-table">

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Reader</th>
                        <th>Borrow Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>

                <c:choose>

                    <c:when test="${not empty borrows}">

                        <c:forEach var="b" items="${borrows}">

                            <tr>

                                <td class="borrow-id">
                                    #${b.borrowId}
                                </td>

                                <td class="reader-cell">
                                    <i class="fa-solid fa-user"></i>
                                    <span>${b.readerName}</span>
                                </td>

                                <td>
                                    <fmt:formatDate value="${b.borrowDate}" pattern="yyyy-MM-dd HH:mm"/>
                                </td>

                                <td>

                                    <c:choose>

                                        <c:when test="${b.status == 'BORROWING'}">

                                            <span class="status borrowing">
                                                <i class="fa-solid fa-book"></i>
                                                Borrowing
                                            </span>

                                        </c:when>

                                        <c:when test="${b.status == 'RETURNED'}">

                                            <span class="status returned">
                                                <i class="fa-solid fa-check"></i>
                                                Returned
                                            </span>

                                        </c:when>

                                        <c:otherwise>

                                            <span class="status">
                                                ${b.status}
                                            </span>

                                        </c:otherwise>

                                    </c:choose>

                                </td>

                                <td class="actions">

                                    <a class="btn view"
                                       href="${pageContext.request.contextPath}/librarian/borrow-detail?id=${b.borrowId}">

                                        <i class="fa-solid fa-eye"></i>
                                        Detail

                                    </a>

                                    <c:if test="${b.status == 'BORROWING'}">

                                        <a class="btn return"
                                           href="${pageContext.request.contextPath}/librarian/return?borrowId=${b.borrowId}">

                                            <i class="fa-solid fa-rotate-left"></i>
                                            Return

                                        </a>

                                        <a class="btn extend"
                                           href="${pageContext.request.contextPath}/librarian/extend-borrow?borrowId=${b.borrowId}">

                                            <i class="fa-solid fa-clock"></i>
                                            Extend

                                        </a>

                                    </c:if>

                                </td>

                            </tr>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <tr>

                            <td colspan="5" class="empty">

                                <i class="fa-solid fa-book-open"></i>

                                <p>No borrow records found</p>

                            </td>

                        </tr>

                    </c:otherwise>

                </c:choose>

            </tbody>

        </table>

    </div>



    <!-- Pagination -->

    <div class="pagination">

        <c:forEach begin="1" end="${totalPages}" var="i">

            <c:url var="pageUrl" value="/librarian/borrows">

                <c:param name="page" value="${i}" />

                <c:if test="${not empty search}">
                    <c:param name="search" value="${search}" />
                </c:if>

                <c:if test="${not empty status}">
                    <c:param name="status" value="${status}" />
                </c:if>

            </c:url>

            <a href="${pageUrl}"
               class="page-btn ${i==currentPage?'active':''}">

                ${i}

            </a>

        </c:forEach>

    </div>

</div>