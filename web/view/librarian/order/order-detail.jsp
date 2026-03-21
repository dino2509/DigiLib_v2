<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .box{
        background:white;
        padding:25px;
        border-radius:12px;
        box-shadow:0 8px 25px rgba(0,0,0,0.08);
    }

    .title{
        font-size:22px;
        font-weight:700;
        margin-bottom:20px;
    }

    .info{
        margin-bottom:20px;
    }

    .table{
        width:100%;
        border-collapse:collapse;
    }

    .table th, .table td{
        padding:10px;
        border-bottom:1px solid #eee;
    }

    .btn{
        padding:8px 15px;
        background:green;
        color:white;
        border:none;
        border-radius:5px;
        margin-top:20px;
    }
</style>

<div class="box">

    <div class="title">📦 Order Detail</div>

    <!-- INFO -->
    <div class="info">
        <p><b>Order ID:</b> #${order.orderId}</p>
        <p><b>Reader:</b> ${order.readerName}</p>
        <p><b>Status:</b> ${order.status}</p>
        <p><b>Total:</b> ${order.totalAmount} ${order.currency}</p>
        <p><b>Date:</b> ${order.createdAt}</p>
    </div>

    <!-- ITEMS -->
    <table class="table">
        <tr>
            <th>Book</th>
            <th>Price</th>
            <th>Qty</th>
            <th>Total</th>
        </tr>

        <c:forEach var="item" items="${items}">
            <tr>
                <td>${item.bookTitle}</td>
                <td>${item.price}</td>
                <td>${item.quantity}</td>
                <td>${item.price * item.quantity}</td>
            </tr>
        </c:forEach>
    </table>

    <!-- CONFIRM CASH -->
    <c:if test="${order.status == 'WAITING_PAYMENT'}">
        <form action="${pageContext.request.contextPath}/librarian/order/confirm-cash" method="post">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <button class="btn">
                Xác nhận thanh toán & giao sách
            </button>
        </form>
    </c:if>
    <!-- CANCEL ORDER -->
    <c:if test="${order.status == 'WAITING_PAYMENT' || order.status == 'WAITING_PICKUP'}">
        <form action="${pageContext.request.contextPath}/librarian/order/cancel" method="post">

            <input type="hidden" name="orderId" value="${order.orderId}">

            <textarea name="reason" placeholder="Nhập lý do hủy..." 
                      style="width:100%;margin-top:10px;padding:8px;border-radius:5px;"></textarea>

            <button 
                onclick="return confirm('Bạn có chắc muốn hủy đơn này không?')"
                style="background:red;color:white;padding:8px 15px;border:none;border-radius:5px;margin-top:10px;">
                Hủy giao dịch
            </button>
        </form>
    </c:if>
    <!-- CONFIRM PICKUP -->
    <c:if test="${order.status == 'WAITING_PICKUP'}">
        <form action="${pageContext.request.contextPath}/librarian/order/complete" method="post">
            <input type="hidden" name="orderId" value="${order.orderId}">

            <button 
                onclick="return confirm('Xác nhận đã giao sách cho người đọc?')"
                style="background:#2ecc71;color:white;padding:10px 18px;border:none;border-radius:6px;margin-top:15px;">
                📚 Xác nhận đã giao sách
            </button>
        </form>
    </c:if>

</div>