<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

    .order-container{
        background:white;
        padding:25px;
        border-radius:8px;
        box-shadow:0 2px 8px rgba(0,0,0,0.1);
    }

    .order-title{
        font-size:24px;
        font-weight:600;
        margin-bottom:20px;
    }

    .order-table{
        width:100%;
        border-collapse:collapse;
    }

    .order-table th{
        background:#f4f6f9;
        padding:12px;
        border-bottom:2px solid #ddd;
    }

    .order-table td{
        padding:12px;
        border-bottom:1px solid #eee;
    }

    .order-table tr:hover{
        background:#fafafa;
    }

    .status-paid{
        background:#2ecc71;
        color:white;
        padding:4px 10px;
        border-radius:12px;
        font-size:12px;
    }

    .status-pending{
        background:#f39c12;
        color:white;
        padding:4px 10px;
        border-radius:12px;
        font-size:12px;
    }

    .empty-box{
        text-align:center;
        padding:40px;
        color:#888;
    }

    .pay-btn{
        margin-top:20px;
        background:#27ae60;
        color:white;
        border:none;
        padding:10px 18px;
        border-radius:5px;
        cursor:pointer;
    }

    .pay-btn:hover{
        background:#219150;
    }

</style>


<div class="order-container">

    <div class="order-title">
        My Orders
    </div>


    <c:if test="${empty orders}">

        <div class="empty-box">
            You have no orders yet.
        </div>

    </c:if>


    <c:if test="${not empty orders}">

        <form action="${pageContext.request.contextPath}/reader/payment" method="post">

            <table class="order-table">

                <thead>

                    <tr>
                        <th>Select</th>
                        <th>Order ID</th>
                        <th>Book</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>

                </thead>

                <tbody>

                    <c:forEach var="o" items="${orders}">

                        <tr>

                            <td>
                                <c:if test="${o.status != 'PAID'}">
                                    <input type="checkbox" name="orderIds" value="${o.orderId}">
                                </c:if>
                            </td>

                            <td>#${o.orderId}</td>

                            <td><strong>${o.bookTitle}</strong></td>

                            <td>
                                $<fmt:formatNumber value="${o.price}" minFractionDigits="2"/>
                            </td>

                            <td>${o.quantity}</td>

                            <td>
                                $<fmt:formatNumber value="${o.total}" minFractionDigits="2"/>
                            </td>

                            <td>

                                <c:choose>

                                    <c:when test="${o.status == 'PAID'}">
                                        <span class="status-paid">PAID</span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="status-pending">PENDING</span>
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

            <button class="pay-btn">
                Pay Selected Orders
            </button>

        </form>

    </c:if>

</div>