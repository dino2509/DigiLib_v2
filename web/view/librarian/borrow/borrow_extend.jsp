<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<style>

    .extend-wrapper{
        padding:20px;
    }

    .page-title{
        font-size:22px;
        margin-bottom:20px;
        color:#333;
    }

    /* FILTER BAR */

    .filter-bar{
        display:flex;
        justify-content:space-between;
        margin-bottom:15px;
    }

    .filter-bar form{
        display:flex;
        gap:10px;
    }

    .filter-bar input,
    .filter-bar select{
        padding:6px 8px;
        border:1px solid #ddd;
        border-radius:4px;
    }

    .btn-filter{
        background:#ff7a00;
        color:white;
        border:none;
        padding:6px 10px;
        border-radius:4px;
        cursor:pointer;
    }

    /* CARD */

    .extend-card{
        background:white;
        border-radius:8px;
        box-shadow:0 2px 10px rgba(0,0,0,0.05);
        overflow:hidden;
    }

    .extend-table{
        width:100%;
        border-collapse:collapse;
    }

    .extend-table thead{
        background:#ff7a00;
        color:white;
    }

    .extend-table th{
        padding:14px;
        text-align:left;
    }

    .extend-table td{
        padding:14px;
        border-bottom:1px solid #eee;
    }

    .extend-table tr:hover{
        background:#fafafa;
    }

    /* STATUS */

    .badge{
        padding:4px 10px;
        border-radius:4px;
        font-size:12px;
        font-weight:600;
    }

    .badge-pending{
        background:#fff3cd;
        color:#856404;
    }

    .badge-approved{
        background:#d4edda;
        color:#155724;
    }

    .badge-rejected{
        background:#f8d7da;
        color:#721c24;
    }

    /* ACTION */

    .actions form{
        display:flex;
        gap:6px;
    }

    .btn{
        border:none;
        padding:6px 12px;
        border-radius:4px;
        font-size:13px;
        cursor:pointer;
    }

    .btn-approve{
        background:#28a745;
        color:white;
    }

    .btn-reject{
        background:#dc3545;
        color:white;
    }

    .btn-approve:hover{
        background:#1e7e34;
    }

    .btn-reject:hover{
        background:#bd2130;
    }

    .processed{
        font-size:12px;
        color:#777;
    }

    /* EMPTY */

    .empty{
        text-align:center;
        padding:25px;
        color:#888;
    }

    /* PAGINATION */

    .pagination{
        display:flex;
        justify-content:center;
        margin-top:20px;
        gap:5px;
    }

    .pagination a{
        padding:6px 12px;
        border:1px solid #ddd;
        text-decoration:none;
        color:#333;
        border-radius:4px;
    }

    .pagination a:hover{
        background:#ff7a00;
        color:white;
    }

    .pagination a.active{
        background:#ff7a00;
        color:white;
        border-color:#ff7a00;
    }

</style>


<div class="extend-wrapper">

    <h2 class="page-title">Borrow Extend Requests</h2>


    <!-- FILTER BAR -->

    <div class="filter-bar">

        <form method="get"
              action="${pageContext.request.contextPath}/librarian/borrow-extend">

            <input type="text"
                   name="search"
                   value="${search}"
                   placeholder="Search book or copy code">

            <select name="status">

                <option value="">All Status</option>

                <option value="PENDING"
                        <c:if test="${status=='PENDING'}">selected</c:if>>
                            Pending
                        </option>

                        <option value="APPROVED"
                        <c:if test="${status=='APPROVED'}">selected</c:if>>
                            Approved
                        </option>

                        <option value="REJECTED"
                        <c:if test="${status=='REJECTED'}">selected</c:if>>
                            Rejected
                        </option>

                </select>

                <button class="btn-filter">
                    Filter
                </button>

            </form>

        </div>



        <div class="extend-card">

            <table class="extend-table">

                <thead>

                    <tr>
                        <th>Book</th>
                        <th>Copy Code</th>
                        <th>Old Due</th>
                        <th>Requested Due</th>
                        <th>Requested At</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>

                </thead>

                <tbody>

                <c:choose>

                    <c:when test="${not empty extendList}">

                        <c:forEach var="e" items="${extendList}">

                            <tr>

                                <td>
                                    <strong>${e.bookTitle}</strong>
                                </td>

                                <td>${e.copyCode}</td>

                                <td>
                                    <fmt:formatDate value="${e.oldDueDate}" pattern="yyyy-MM-dd"/>
                                </td>

                                <td>
                                    <fmt:formatDate value="${e.requestedDueDate}" pattern="yyyy-MM-dd"/>
                                </td>

                                <td>
                                    <fmt:formatDate value="${e.requestedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </td>

                                <td>

                                    <c:choose>

                                        <c:when test="${e.status eq 'PENDING'}">
                                            <span class="badge badge-pending">Pending</span>
                                        </c:when>

                                        <c:when test="${e.status eq 'APPROVED'}">
                                            <span class="badge badge-approved">Approved</span>
                                        </c:when>

                                        <c:when test="${e.status eq 'REJECTED'}">
                                            <span class="badge badge-rejected">Rejected</span>
                                        </c:when>

                                    </c:choose>

                                </td>

                                <td class="actions">

                                    <c:if test="${e.status eq 'PENDING'}">

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/librarian/process-extend">

                                            <input type="hidden"
                                                   name="extendId"
                                                   value="${e.extendId}">

                                            <button class="btn btn-approve"
                                                    name="action"
                                                    value="approve"
                                                    onclick="return confirm('Approve this extend request?')">
                                                Approve
                                            </button>

                                            <button class="btn btn-reject"
                                                    name="action"
                                                    value="reject"
                                                    onclick="return confirm('Reject this extend request?')">
                                                Reject
                                            </button>

                                        </form>

                                    </c:if>

                                    <c:if test="${e.status ne 'PENDING'}">
                                        <span class="processed">Processed</span>
                                    </c:if>

                                </td>

                            </tr>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <tr>
                            <td colspan="7" class="empty">
                                No extend requests found
                            </td>
                        </tr>

                    </c:otherwise>

                </c:choose>

            </tbody>

        </table>

    </div>



    <!-- PAGINATION -->

    <div class="pagination">

        <c:forEach begin="1" end="${totalPages}" var="i">

            <c:url var="pageUrl" value="/librarian/borrow-extend">

                <c:param name="page" value="${i}"/>

                <c:if test="${not empty search}">
                    <c:param name="search" value="${search}"/>
                </c:if>

                <c:if test="${not empty status}">
                    <c:param name="status" value="${status}"/>
                </c:if>

            </c:url>

            <a href="${pageContext.request.contextPath}${pageUrl}"
               class="${i==currentPage?'active':''}">
                ${i}
            </a>

        </c:forEach>

    </div>

</div>