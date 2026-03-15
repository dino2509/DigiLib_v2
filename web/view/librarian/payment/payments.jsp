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

    .table th{
        padding:12px;
        text-align:left;
    }

    .table td{
        padding:12px;
        border-bottom:1px solid #eee;
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

    /* transaction */

    .transaction{
        font-family:monospace;
        font-size:13px;
        color:#555;
    }

    /* pagination */

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
        color:#333;
    }

    .page-btn.active{
        background:#ff7a00;
        color:white;
    }

</style>



<div class="page-header">

    <div class="page-title">
        💳 Payments
    </div>

    <form class="filter-box"
          method="get"
          action="${pageContext.request.contextPath}/librarian/payments">

        <input type="text"
               name="search"
               value="${param.search}"
               placeholder="Search reader / order / transaction">

        <select name="status">

            <option value="">All Status</option>

            <option value="PAID"
                    <c:if test="${param.status=='PAID'}">selected</c:if>>
                        PAID
                    </option>

                    <option value="PENDING"
                    <c:if test="${param.status=='PENDING'}">selected</c:if>>
                        PENDING
                    </option>

                    <option value="FAILED"
                    <c:if test="${param.status=='FAILED'}">selected</c:if>>
                        FAILED
                    </option>

            </select>

            <button class="btn-search">🔍</button>

        </form>

    </div>



    <div class="table-box">

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

                    <td>
                        <b>#${p.paymentId}</b>
                    </td>

                    <td>

                        <a href="${pageContext.request.contextPath}/librarian/order-detail?id=${p.orderId}">
                            #${p.orderId}
                        </a>

                    </td>

                    <td>
                        👤 ${p.readerName}
                    </td>

                    <td>

                        <fmt:formatNumber value="${p.amount}"
                                          type="number"
                                          groupingUsed="true"/>

                    </td>

                    <td>
                        ${p.paymentMethod}
                    </td>

                    <td>

                        <span class="status ${p.paymentStatus}">
                            ${p.paymentStatus}
                        </span>

                    </td>

                    <td class="transaction">
                        ${p.transactionCode}
                    </td>

                    <td>

                        <fmt:formatDate value="${p.paidAt}"
                                        pattern="yyyy-MM-dd HH:mm"/>

                    </td>

                </tr>

            </c:forEach>

        </tbody>

    </table>

</div>



<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="p">

        <c:url var="pageUrl" value="/librarian/payments">

            <c:param name="page" value="${p}" />

            <c:if test="${not empty search}">
                <c:param name="search" value="${search}" />
            </c:if>

            <c:if test="${not empty status}">
                <c:param name="status" value="${status}" />
            </c:if>

        </c:url>

        <a class="page-btn ${p==currentPage?'active':''}"
           href="${pageUrl}">

            ${p}

        </a>

    </c:forEach>

</div>