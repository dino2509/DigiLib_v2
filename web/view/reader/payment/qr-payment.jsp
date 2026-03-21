<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .payment-container {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        max-width: 900px;
        margin: auto;
    }

    .payment-title {
        font-size: 26px;
        font-weight: bold;
        margin-bottom: 20px;
        color: #333;
    }

    .info {
        margin-bottom: 15px;
        color: #555;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }

    th, td {
        padding: 10px;
        border-bottom: 1px solid #ddd;
        text-align: left;
    }

    th {
        background: #f5f5f5;
    }

    .total {
        text-align: right;
        font-size: 20px;
        font-weight: bold;
        margin-top: 15px;
        color: #e74c3c;
    }

    .qr-section {
        text-align: center;
        margin-top: 30px;
    }

    .qr-img {
        width: 250px;
        margin: 15px 0;
    }

    .transfer-info {
        background: #f9f9f9;
        padding: 15px;
        border-radius: 8px;
        margin-top: 10px;
        font-size: 15px;
    }

    .btn-confirm {
        margin-top: 25px;
        padding: 12px 20px;
        background: #2ecc71;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
    }

    .btn-confirm:hover {
        background: #27ae60;
    }

    .note {
        margin-top: 15px;
        color: #999;
        font-size: 14px;
    }
</style>

<div class="payment-container">

    <div class="payment-title">
        📄 Invoice #${order.orderId}
    </div>

    <div class="info"><b>Reader:</b> ${order.readerName}</div>
    <div class="info"><b>Created At:</b> ${order.createdAt}</div>

    <table>
        <thead>
            <tr>
                <th>Book</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Total</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${items}" var="i">
                <tr>
                    <td>${i.bookTitle}</td>
                    <td>${i.quantity}</td>
                    <td>${i.price}</td>
                    <td>${i.price * i.quantity}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="total">
        Total: ${order.totalAmount} VND
    </div>

    <!-- QR SECTION -->
    <div class="qr-section">

        <h3>📱 Scan QR to Pay</h3>

        <img src="${qrUrl}" class="qr-img"/>

        <div class="transfer-info">
            <b>Transfer Content:</b><br/>
            DigiLib ${order.orderId}
        </div>

        <div class="note">
            Please transfer the exact amount and content.<br/>
            After payment, click the button below.
        </div>

        <!-- CONFIRM BUTTON -->
        <form action="${pageContext.request.contextPath}/reader/confirm-paid" method="post">
            <input type="hidden" name="orderId" value="${order.orderId}"/>
            <button class="btn-confirm">
                ✔ I have paid
            </button>
        </form>
        <form action="${pageContext.request.contextPath}/reader/cancel-order" method="post"
              onsubmit="return confirm('Are you sure you want to cancel this order?');">

            <input type="hidden" name="orderId" value="${order.orderId}"/>

            <button style="
                    margin-top:10px;
                    padding:10px 20px;
                    background:#e74c3c;
                    color:white;
                    border:none;
                    border-radius:8px;
                    cursor:pointer;
                    font-size:15px;">
                ❌ Cancel Payment
            </button>
        </form>

    </div>

</div>