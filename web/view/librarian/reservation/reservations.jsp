<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"
          uri="http://java.sun.com/jsp/jstl/core"%>
<style>.table{
        width:100%;
        border-collapse:collapse;
        background:white;
    }

    .table th,
    .table td{
        padding:10px;
        border-bottom:1px solid #ddd;
    }

    .table th{
        background:#f4f6f9;
        text-align:left;
    }

    .status{
        padding:4px 10px;
        border-radius:4px;
        font-size:12px;
        color:white;
    }

    .waiting{
        background:#f39c12;
    }

    .approved{
        background:#27ae60;
    }

    .rejected{
        background:#e74c3c;
    }</style>
<h2>Reservations</h2>

<table class="table">

    <thead>
        <tr>
            <th>ID</th>
            <th>Reader</th>
            <th>Book</th>
            <th>Quantity</th>
            <th>Created At</th>
            <th>Status</th>
        </tr>
    </thead>

    <tbody>

        <c:forEach items="${reservations}" var="r">

            <tr>
                <td>${r.reservationId}</td>
                <td>${r.readerName}</td>
                <td>${r.bookTitle}</td>
                <td>${r.quantity}</td>
                <td>${r.createdAt}</td>
                <td>

                    <c:choose>

                        <c:when test="${r.status == 'WAITING'}">
                            <span class="status waiting">WAITING</span>
                        </c:when>

                        <c:when test="${r.status == 'FULFILLED'}">
                            <span class="status approved">FULFILLED</span>
                        </c:when>

                        <c:when test="${r.status == 'CANCELLED'}">
                            <span class="status rejected">CANCELLED</span>
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