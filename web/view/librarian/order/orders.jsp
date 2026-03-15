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

    /* filter */

    .filter-box{
        display:flex;
        gap:8px;
    }

    .filter-box input{
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

    .order-table{
        width:100%;
        border-collapse:collapse;
    }

    .order-table thead{
        background:#ff7a00;
        color:white;
    }

    .order-table th{
        padding:12px;
        text-align:left;
    }

    .order-table td{
        padding:12px;
        border-bottom:1px solid #eee;
    }

    .order-table tr:hover{
        background:#fff5ed;
    }

    /* badges */

    .status{
        padding:5px 10px;
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

    /* action */

    .btn-view{
        padding:6px 10px;
        background:#17a2b8;
        color:white;
        border-radius:4px;
        text-decoration:none;
        font-size:13px;
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
        📚 Ebook Orders
    </div>

    <form class="filter-box"
          method="get"
          action="${pageContext.request.contextPath}/librarian/orders">

        <input type="text"
               name="search"
               value="${param.search}"
               placeholder="Search reader or order ID">

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

            <button class="btn-search">
                🔍
            </button>

        </form>

    </div>


    <div class="table-box">

        <table class="order-table">

            <thead>
                <tr>
                    <th>ID</th>
                    <th>Reader</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th></th>
                </tr>
            </thead>

            <tbody>

            <c:forEach var="o" items="${orders}">

                <tr>

                    <td>
                        <b>#${o.orderId}</b>
                    </td>

                    <td>
                        👤 ${o.readerName}
                    </td>

                    <td>

                        <fmt:formatNumber value="${o.totalAmount}"
                                          type="number"
                                          groupingUsed="true"/>

                        ${o.currency}

                    </td>

                    <td>

                        <span class="status ${o.status}">
                            ${o.status}
                        </span>

                    </td>

                    <td>

                        <fmt:formatDate value="${o.createdAt}"
                                        pattern="yyyy-MM-dd HH:mm"/>

                    </td>

                    <td>

                        <a class="btn-view"
                           href="${pageContext.request.contextPath}/librarian/order-detail?id=${o.orderId}">

                            View

                        </a>

                    </td>

                </tr>

            </c:forEach>

        </tbody>

    </table>

</div>


<!-- Pagination -->

<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="p">

        <c:url var="pageUrl" value="/librarian/orders">

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