<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<h2>My Reservations</h2>

<table class="reservation-table">

    <thead>
        <tr>
            <th>ID</th>
            <th>Book</th>
            <th>Quantity</th>
            <th>Reserved At</th>
            <th>Expires At</th>
            <th>Status</th>
        </tr>
    </thead>

    <tbody>

    <c:forEach var="r" items="${reservations}">

        <tr>

            <td>#${r.reservationId}</td>

            <td>${r.bookTitle}</td>

            <td>${r.quantity}</td>

            <td>
        <fmt:formatDate value="${r.createdAt}"
                        pattern="yyyy-MM-dd HH:mm"/>
        </td>

        <td>
        <fmt:formatDate value="${r.expiresAt}"
                        pattern="yyyy-MM-dd HH:mm"/>
        </td>

        <td>

        <c:choose>

            <c:when test="${r.status=='WAITING'}">
                <span class="status waiting">WAITING</span>
            </c:when>

            <c:when test="${r.status=='FULFILLED'}">
                <span class="status ready">FULFILLED</span>
            </c:when>

            <c:when test="${r.status=='CANCELLED'}">
                <span class="status cancel">CANCELLED</span>
            </c:when>

            <c:otherwise>
                ${r.status}
            </c:otherwise>

        </c:choose>

        </td>

        </tr>

    </c:forEach>

</tbody>

</table>


<style>

    .reservation-table{
        width:100%;
        border-collapse:collapse;
        background:white;
    }

    .reservation-table th{
        background:#ff7a00;
        color:white;
        padding:10px;
    }

    .reservation-table td{
        padding:10px;
        border-bottom:1px solid #eee;
    }

    .status{
        padding:4px 10px;
        border-radius:4px;
        font-size:12px;
    }

    .waiting{
        background:#fff3cd;
        color:#856404;
    }

    .ready{
        background:#d4edda;
        color:#155724;
    }

    .cancel{
        background:#f8d7da;
        color:#721c24;
    }

</style>