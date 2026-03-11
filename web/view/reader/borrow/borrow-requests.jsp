<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

    .page-title{
        margin-bottom:20px;
        color:#ff7a00;
    }

    /* table */

    .borrow-table{
        width:100%;
        border-collapse:collapse;
        background:white;
        border-radius:10px;
        overflow:hidden;
        box-shadow:0 4px 12px rgba(0,0,0,0.08);
    }

    .borrow-table th{
        background:#ff7a00;
        color:white;
        padding:12px;
        text-align:left;
    }

    .borrow-table td{
        padding:12px;
        border-bottom:1px solid #eee;
    }

    .borrow-table tr:hover{
        background:#fff6ef;
    }

    /* book list */

    .book-item{
        padding:3px 0;
    }

    /* status */

    .status{
        padding:5px 12px;
        border-radius:20px;
        font-size:13px;
        font-weight:bold;
    }

    .pending{
        background:#fff3cd;
        color:#856404;
    }

    .approved{
        background:#d4edda;
        color:#155724;
    }

    .rejected{
        background:#f8d7da;
        color:#721c24;
    }

</style>


<h2 class="page-title">My Borrow Requests</h2>

<table class="borrow-table">

    <thead>
        <tr>
            <th>ID</th>
            <th>Books</th>
            <th>Requested Date</th>
            <th>Status</th>
        </tr>
    </thead>

    <tbody>

        <c:forEach var="r" items="${requests}">

            <tr>

                <td>#${r.requestId}</td>

                <td>

                    <c:forEach var="item" items="${r.items}">
                        <div class="book-item">
                            📚 ${item.bookTitle} <b>(x${item.quantity})</b>
                        </div>
                    </c:forEach>

                </td>

                <td>
        <fmt:formatDate value="${r.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
    </td>

    <td>

        <c:choose>

            <c:when test="${r.status == 'PENDING'}">
                <span class="status pending">Pending</span>
            </c:when>

            <c:when test="${r.status == 'APPROVED'}">
                <span class="status approved">Approved</span>
            </c:when>

            <c:otherwise>
                <span class="status rejected">Rejected</span>
            </c:otherwise>

        </c:choose>

    </td>

</tr>

</c:forEach>

</tbody>

</table>