<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

    .reservation-wrapper{
        padding:20px;
    }

    .page-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .page-title{
        font-size:24px;
        font-weight:600;
        color:#333;
    }

    /* FILTER */

    .filter-bar form{
        display:flex;
        gap:10px;
    }

    .filter-bar input,
    .filter-bar select{
        padding:8px;
        border:1px solid #ddd;
        border-radius:6px;
        font-size:13px;
    }

    .btn-filter{
        background:#ff7a00;
        color:white;
        border:none;
        padding:8px 14px;
        border-radius:6px;
        cursor:pointer;
        font-weight:500;
    }

    /* TABLE CARD */

    .table-box{
        background:white;
        border-radius:10px;
        box-shadow:0 4px 16px rgba(0,0,0,0.08);
        overflow:hidden;
    }

    /* TABLE */

    .table{
        width:100%;
        border-collapse:collapse;
    }

    .table th{
        background:#ff7a00;
        color:white;
        padding:14px;
        font-size:14px;
    }

    .table td{
        padding:14px;
        border-bottom:1px solid #eee;
        font-size:14px;
    }

    .table tr:hover{
        background:#fafafa;
    }

    /* BOOK CELL */

    .book-cell{
        display:flex;
        flex-direction:column;
        gap:4px;
    }

    .book-title{
        font-weight:600;
    }

    .book-meta{
        font-size:12px;
        color:#777;
    }

    /* AVAILABLE */

    .available{
        font-size:12px;
        padding:4px 8px;
        border-radius:12px;
        background:#eafaf1;
        color:#27ae60;
        font-weight:600;
        display:inline-block;
    }

    .unavailable{
        background:#fdecea;
        color:#e74c3c;
    }

    /* STATUS */

    .status{
        padding:5px 12px;
        border-radius:20px;
        font-size:12px;
        font-weight:600;
        color:white;
    }

    .waiting{
        background:#f39c12;
    }
    .fulfilled{
        background:#27ae60;
    }
    .cancelled{
        background:#e74c3c;
    }

    /* ACTION */

    .actions{
        display:flex;
        gap:6px;
    }

    .btn{
        padding:6px 10px;
        border-radius:5px;
        border:none;
        font-size:12px;
        cursor:pointer;
        color:white;
    }

    .btn-fulfill{
        background:#27ae60;
    }
    .btn-cancel{
        background:#e74c3c;
    }

    .btn-disabled{
        background:#bbb;
        cursor:not-allowed;
    }

    /* PAGINATION */

    .pagination{
        display:flex;
        justify-content:center;
        margin-top:25px;
        gap:6px;
    }

    .pagination a{
        padding:7px 14px;
        border-radius:6px;
        border:1px solid #ddd;
        text-decoration:none;
        color:#333;
    }

    .pagination a.active{
        background:#ff7a00;
        color:white;
        border-color:#ff7a00;
    }

</style>


<div class="reservation-wrapper">

    <div class="page-header">

        <h2 class="page-title">Reservations</h2>

        <div class="filter-bar">

            <form method="get"
                  action="${pageContext.request.contextPath}/librarian/reservations">

                <input type="text"
                       name="search"
                       value="${search}"
                       placeholder="Search reader or book">

                <select name="status">

                    <option value="">All Status</option>

                    <option value="WAITING"
                            <c:if test="${status=='WAITING'}">selected</c:if>>
                                Waiting
                            </option>

                            <option value="FULFILLED"
                            <c:if test="${status=='FULFILLED'}">selected</c:if>>
                                Fulfilled
                            </option>

                            <option value="CANCELLED"
                            <c:if test="${status=='CANCELLED'}">selected</c:if>>
                                Cancelled
                            </option>

                    </select>

                    <button class="btn-filter">Filter</button>

                </form>

            </div>

        </div>


        <div class="table-box">

            <table class="table">

                <thead>

                    <tr>
                        <th>ID</th>
                        <th>Reader</th>
                        <th>Book</th>
                        <th>Qty</th>
                        <th>Created</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>

                </thead>

                <tbody>

                <c:forEach items="${reservations}" var="r">

                    <tr>

                        <td>#${r.reservationId}</td>

                        <td>${r.readerName}</td>

                        <td class="book-cell">

                            <div class="book-title">
                                ${r.bookTitle}
                            </div>

                            <div class="book-meta">

                                <c:choose>

                                    <c:when test="${r.availableCopies > 0}">
                                        <span class="available">
                                            ${r.availableCopies} copies available
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="available unavailable">
                                            No copy available
                                        </span>
                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </td>

                        <td>${r.quantity}</td>

                        <td>
                            <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>

                            <c:choose>

                                <c:when test="${r.status == 'WAITING'}">
                                    <span class="status waiting">Waiting</span>
                                </c:when>

                                <c:when test="${r.status == 'FULFILLED'}">
                                    <span class="status fulfilled">Fulfilled</span>
                                </c:when>

                                <c:when test="${r.status == 'CANCELLED'}">
                                    <span class="status cancelled">Cancelled</span>
                                </c:when>

                            </c:choose>

                        </td>

                        <td class="actions">

                            <c:if test="${r.status == 'WAITING'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/librarian/process-reservation">

                                    <input type="hidden"
                                           name="reservationId"
                                           value="${r.reservationId}">

                                    <c:choose>

                                        <c:when test="${r.availableCopies > 0}">

                                            <button class="btn btn-fulfill"
                                                    name="action"
                                                    value="fulfill">
                                                Fulfill
                                            </button>

                                        </c:when>

                                        <c:otherwise>

                                            <button class="btn btn-disabled"
                                                    disabled>
                                                No Copy
                                            </button>

                                        </c:otherwise>

                                    </c:choose>

                                    <button class="btn btn-cancel"
                                            name="action"
                                            value="cancel">
                                        Cancel
                                    </button>

                                </form>

                            </c:if>

                            <c:if test="${r.status != 'WAITING'}">
                                -
                            </c:if>

                        </td>

                    </tr>

                </c:forEach>

            </tbody>

        </table>

    </div>


    <div class="pagination">

        <c:forEach begin="1" end="${totalPages}" var="i">

            <c:url var="pageUrl" value="/librarian/reservations">

                <c:param name="page" value="${i}"/>

                <c:if test="${not empty search}">
                    <c:param name="search" value="${search}"/>
                </c:if>

                <c:if test="${not empty status}">
                    <c:param name="status" value="${status}"/>
                </c:if>

            </c:url>

            <a href="${pageUrl}"
               class="${i==currentPage?'active':''}">
                ${i}
            </a>

        </c:forEach>

    </div>

</div>