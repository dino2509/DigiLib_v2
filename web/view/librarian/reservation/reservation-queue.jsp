<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>.page-heading{
        margin-bottom:20px;
        color:#444;
    }

    .table-wrapper{
        background:white;
        border-radius:8px;
        overflow:hidden;
        box-shadow:0 2px 8px rgba(0,0,0,0.05);
    }

    .table{
        width:100%;
        border-collapse:collapse;
    }

    .table thead{
        background:#ff7a00;
    }

    .table th{
        color:white;
        padding:14px;
        font-weight:600;
    }

    .table td{
        padding:12px;
        border-bottom:1px solid #eee;
    }

    .table tr:hover{
        background:#fafafa;
    }

    .book-title{
        font-weight:600;
        color:#333;
    }

    .badge{
        padding:4px 10px;
        border-radius:20px;
        font-size:12px;
        font-weight:600;
    }

    .waiting{
        background:#ffe5c7;
        color:#ff7a00;
    }

    .actions{
        display:flex;
        gap:8px;
    }

    .btn{
        padding:6px 12px;
        border-radius:4px;
        text-decoration:none;
        font-size:13px;
        color:white;
    }

    .btn-success{
        background:#27ae60;
    }

    .btn-success:hover{
        background:#219150;
    }

    .btn-danger{
        background:#e74c3c;
    }

    .btn-danger:hover{
        background:#c0392b;
    }

    .empty{
        text-align:center;
        padding:30px;
        color:#777;
    }</style>
<h2 class="page-heading">Reservation Queue</h2>

<div class="table-wrapper">

    <table class="table">

        <thead>
            <tr>
                <th>ID</th>
                <th>Reader</th>
                <th>Book</th>
                <th>Quantity</th>
                <th>Created</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>

        <tbody>

            <c:choose>

                <c:when test="${not empty queue}">

                    <c:forEach items="${queue}" var="r">

                        <tr>

                            <td>#${r.reservationId}</td>

                            <td>${r.readerName}</td>

                            <td class="book-title">
                                ${r.bookTitle}
                            </td>

                            <td>${r.quantity}</td>

                            <td>
                                <fmt:formatDate value="${r.createdAt}"
                                                pattern="dd/MM/yyyy HH:mm"/>
                            </td>

                            <td>
                                <span class="badge waiting">
                                    WAITING
                                </span>
                            </td>

                            <td class="actions">

                                <a class="btn btn-success"
                                   href="${pageContext.request.contextPath}/librarian/reservation-fulfill?id=${r.reservationId}">
                                    <i class="fa-solid fa-check"></i> Fulfill
                                </a>

                                <a class="btn btn-danger"
                                   href="${pageContext.request.contextPath}/librarian/reservation-cancel?id=${r.reservationId}">
                                    <i class="fa-solid fa-xmark"></i> Cancel
                                </a>

                            </td>

                        </tr>

                    </c:forEach>

                </c:when>

                <c:otherwise>

                    <tr>
                        <td colspan="7" class="empty">
                            No reservations in queue
                        </td>
                    </tr>

                </c:otherwise>

            </c:choose>

        </tbody>

    </table>

</div>