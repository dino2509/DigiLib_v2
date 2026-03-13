<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>

    .table{
        width:100%;
        border-collapse:collapse;
    }

    .table th,.table td{
        padding:10px;
        border-bottom:1px solid #ddd;
    }

    .status{
        padding:4px 10px;
        border-radius:4px;
    }

    .status.PAID{
        background:#d4edda;
        color:#155724;
    }

    .status.PENDING{
        background:#fff3cd;
        color:#856404;
    }

    .status.FAILED{
        background:#f8d7da;
        color:#721c24;
    }

    .pagination{
        margin-top:20px;
    }

    .pagination a{
        padding:6px 12px;
        margin-right:5px;
        text-decoration:none;
        background:#eee;
        border-radius:4px;
    }

    .pagination a.active{
        background:#007bff;
        color:white;
    }

</style>

<h2>Payments</h2>

<table class="table">

    <thead>
        <tr>
            <th>ID</th>
            <th>Order</th>
            <th>Reader</th>
            <th>Amount</th>
            <th>Method</th>
            <th>Status</th>
            <th>Transaction</th>
            <th>Paid At</th>
        </tr>
    </thead>

    <tbody>

    <c:forEach var="p" items="${payments}">

        <tr>

            <td>#${p.paymentId}</td>

            <td>#${p.orderId}</td>

            <td>${p.readerName}</td>

            <td>${p.amount}</td>

            <td>${p.paymentMethod}</td>

            <td>
                <span class="status ${p.paymentStatus}">
                    ${p.paymentStatus}
                </span>
            </td>

            <td>${p.transactionCode}</td>

            <td>${p.paidAt}</td>

        </tr>

    </c:forEach>

</tbody>

</table>


<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="p">

        <a class="${p==currentPage?'active':''}"
           href="${pageContext.request.contextPath}/librarian/payments?page=${p}">

            ${p}

        </a>

    </c:forEach>

</div>