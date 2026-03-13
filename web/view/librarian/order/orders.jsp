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

<h2>Ebook Orders</h2>

<table class="table">

    <thead>
        <tr>
            <th>ID</th>
            <th>Reader</th>
            <th>Total</th>
            <th>Currency</th>
            <th>Status</th>
            <th>Created</th>
            <th></th>
        </tr>
    </thead>

    <tbody>

        <c:forEach var="o" items="${orders}">
            <tr>

                <td>#${o.orderId}</td>

                <td>${o.readerName}</td>

                <td>${o.totalAmount}</td>

                <td>${o.currency}</td>

                <td>
                    <span class="status ${o.status}">
                        ${o.status}
                    </span>
                </td>

                <td>${o.createdAt}</td>

                <td>
                    <a href="${pageContext.request.contextPath}/librarian/order-detail?id=${o.orderId}">
                        View
                    </a>
                </td>

            </tr>
        </c:forEach>

    </tbody>

</table>


<!-- Pagination -->

<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="p">

        <a class="${p==currentPage?'active':''}"
           href="${pageContext.request.contextPath}/librarian/orders?page=${p}">

            ${p}

        </a>

    </c:forEach>

</div>