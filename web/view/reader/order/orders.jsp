<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
    .order-container{
        background:#f5f7fa;
        padding:30px;
        min-height:100vh;
    }

    .order-card{
        background:white;
        padding:25px;
        border-radius:14px;
        box-shadow:0 10px 30px rgba(0,0,0,0.08);
    }

    .order-title{
        font-size:26px;
        font-weight:700;
        margin-bottom:20px;
        color:#2c3e50;
    }

    /* TABLE */
    .table{
        width:100%;
        border-collapse:collapse;
        overflow:hidden;
        border-radius:10px;
    }

    .table th{
        background:#f1f3f6;
        padding:14px;
        font-size:14px;
        color:#555;
        text-transform:uppercase;
    }

    .table td{
        padding:14px;
        border-bottom:1px solid #eee;
        font-size:15px;
    }

    .table tr:hover{
        background:#fafafa;
    }

    /* STATUS BADGE */
    .status{
        padding:6px 12px;
        border-radius:20px;
        font-size:12px;
        font-weight:600;
    }

    .waiting{
        background:#fff3cd;
        color:#856404;
    }

    .pickup{
        background:#d6eaff;
        color:#0b5ed7;
    }

    .completed{
        background:#d4edda;
        color:#155724;
    }

    .failed{
        background:#f8d7da;
        color:#721c24;
    }

    /* PAGINATION */
    .pagination{
        margin-top:25px;
        text-align:center;
    }

    .page-btn{
        display:inline-block;
        padding:8px 14px;
        margin:3px;
        border-radius:6px;
        border:1px solid #ddd;
        background:white;
        color:#555;
        text-decoration:none;
        transition:0.2s;
    }

    .page-btn:hover{
        background:#3498db;
        color:white;
    }

    .page-btn.active{
        background:#3498db;
        color:white;
        border:none;
    }

    /* EMPTY */
    .empty-box{
        text-align:center;
        padding:40px;
        color:#999;
        font-size:16px;
    }
</style>

<div class="order-container">

    <div class="order-card">

        <div class="order-title">📦 My Orders</div>

        <c:if test="${empty orders}">
            <div class="empty-box">
                🚫 You have no orders yet.
            </div>
        </c:if>

        <c:if test="${not empty orders}">

            <table class="table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Book</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="o" items="${orders}" varStatus="loop">
                        <tr>

                            <!-- STT -->
                            <td>
                                <b>${(currentPage - 1) * 5 + loop.index + 1}</b>
                            </td>

                            <td>
                                <strong>${o.bookTitle}</strong>
                            </td>

                            <td>
                                ${o.price} VND
                            </td>

                            <td>${o.quantity}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 'WAITING_PAYMENT'}">
                                        <span class="status waiting">Waiting Payment</span>
                                    </c:when>
                                    <c:when test="${o.status == 'WAITING_PICKUP'}">
                                        <span class="status pickup">Ready to Pickup</span>
                                    </c:when>
                                    <c:when test="${o.status == 'COMPLETED'}">
                                        <span class="status completed">Completed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status failed">Failed</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- PAGINATION -->
            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="?page=${i}" 
                       class="page-btn ${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
            </div>

        </c:if>

    </div>

</div>