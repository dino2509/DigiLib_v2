<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .order-box{
        background:white;
        padding:25px;
        border-radius:12px;
        box-shadow:0 8px 25px rgba(0,0,0,0.08);
    }

    .order-title{
        font-size:24px;
        font-weight:700;
        margin-bottom:20px;
    }

    .order-table{
        width:100%;
        border-collapse:collapse;
    }

    .order-table th, .order-table td{
        padding:12px;
        border-bottom:1px solid #eee;
    }

    .total{
        margin-top:20px;
        font-size:20px;
        font-weight:bold;
    }

    .payment-method{
        margin-top:20px;
    }

    .btn-pay{
        margin-top:20px;
        padding:10px 20px;
        background:#3498db;
        color:white;
        border:none;
        border-radius:6px;
    }
</style>

<div class="order-box">

    <div class="order-title">🧾 Order Summary</div>

    <form action="${pageContext.request.contextPath}/reader/checkout" method="post">

        <!-- giữ lại item -->
        <c:forEach var="id" items="${cartItemIds}">
            <input type="hidden" name="cartItemIds" value="${id}">
        </c:forEach>

        <!-- TABLE -->
        <table class="order-table">

            <tr>
                <th>Book</th>
                <th>Price</th>
                <th>Qty</th>
                <th>Total</th>
            </tr>

            <c:forEach var="item" items="${items}">
                <tr>
                    <td>${item.bookTitle}</td>
                    <td>${item.price} ${item.currency}</td>
                    <td>${item.quantity}</td>
                    <td>${item.total} ${item.currency}</td>
                </tr>
            </c:forEach>

        </table>

        <div class="total">
            Tổng tiền: ${total} ${items[0].currency}
        </div>

        <!-- PAYMENT METHOD -->
        <div class="payment-method">
            <label><b>Chọn phương thức thanh toán:</b></label><br>

            <input type="radio" name="paymentMethod" value="CASH" checked>
            Thanh toán tiền mặt<br>

            <input type="radio" name="paymentMethod" value="QR">
            Chuyển khoản<br>
        </div>

        <button class="btn-pay">
            Thanh toán
        </button>

    </form>

</div>