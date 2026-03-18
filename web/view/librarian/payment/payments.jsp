<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    .page-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .page-title{
        font-size:22px;
        font-weight:600;
        color:#ff7a00;
    }

    .filter-box{
        display:flex;
        gap:8px;
    }

    .filter-box input,
    .filter-box select{
        padding:7px 10px;
        border:1px solid #ddd;
        border-radius:4px;
    }

    .btn-search{
        background:#ff7a00;
        border:none;
        color:white;
        padding:7px 12px;
        border-radius:4px;
        cursor:pointer;
    }

    /* table */
    .table-box{
        background:white;
        border-radius:8px;
        overflow:hidden;
        box-shadow:0 2px 6px rgba(0,0,0,0.05);
    }

    .table{
        width:100%;
        border-collapse:collapse;
    }

    .table thead{
        background:#ff7a00;
        color:white;
    }

    .table th, .table td{
        padding:12px;
    }

    .table tr:hover{
        background:#fff5ed;
    }

    /* status */
    .status{
        padding:4px 10px;
        border-radius:20px;
        font-size:12px;
        font-weight:600;
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

    /* type */
    .type{
        padding:4px 10px;
        border-radius:20px;
        font-size:12px;
        font-weight:600;
    }

    .type.ORDER{
        background:#e3f2fd;
        color:#0d47a1;
    }

    .type.FINE{
        background:#fdecea;
        color:#c62828;
    }

    .transaction{
        font-family:monospace;
        font-size:13px;
    }

    .pagination{
        margin-top:20px;
        display:flex;
        justify-content:center;
        gap:6px;
    }

    .page-btn{
        padding:6px 12px;
        background:#eee;
        border-radius:4px;
        text-decoration:none;
    }

    .page-btn.active{
        background:#ff7a00;
        color:white;
    }
</style>

<div class="page-header">
    <div class="page-title">💳 Payments</div>

    <form class="filter-box" method="get">
        <input type="text" name="search" value="${search}"
               placeholder="Search reader / order / fine / txn">

        <select name="status">
            <option value="">All Status</option>
            <option value="PAID" ${status=='PAID'?'selected':''}>PAID</option>
            <option value="PENDING" ${status=='PENDING'?'selected':''}>PENDING</option>
            <option value="FAILED" ${status=='FAILED'?'selected':''}>FAILED</option>
        </select>

        <button class="btn-search">🔍</button>
    </form>
</div>

<div class="table-box">
    <table class="table">

        <thead>
            <tr>
                <th>ID</th>
                <th>Type</th>
                <th>Reference</th>
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
                <tr class="${p.type == 'FINE' ? 'fine-row' : ''}">

                    <td><b>#${p.paymentId}</b></td>

                    <td>
                        <span class="type ${p.type}">
                            <c:choose>
                                <c:when test="${p.type=='ORDER'}">🧾 Order</c:when>
                                <c:otherwise>💸 Fine</c:otherwise>
                            </c:choose>
                        </span>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${p.type=='ORDER'}">
                                <a href="order-detail?id=${p.orderId}">#${p.orderId}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="fine-detail?id=${p.fineId}">#${p.fineId}</a>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>👤 ${p.readerName}</td>

                    <td>
                        <fmt:formatNumber value="${p.amount}" groupingUsed="true"/>
                    </td>

                    <td>${p.paymentMethod}</td>

                    <td>
                        <span class="status ${p.paymentStatus}">
                            ${p.paymentStatus}
                        </span>
                    </td>

                    <td class="transaction">${p.transactionCode}</td>

                    <td>
                        <fmt:formatDate value="${p.paidAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>

                </tr>
            </c:forEach>
        </tbody>

    </table>
</div>

<div class="pagination">
    <c:forEach begin="1" end="${totalPages}" var="p">
        <a class="page-btn ${p==currentPage?'active':''}"
           href="?page=${p}&search=${search}&status=${status}">
            ${p}
        </a>
    </c:forEach>
</div>