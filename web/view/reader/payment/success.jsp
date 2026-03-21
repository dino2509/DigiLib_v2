<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .success-container {
        max-width: 700px;
        margin: 50px auto;
        background: white;
        padding: 40px;
        border-radius: 12px;
        text-align: center;
        box-shadow: 0 8px 25px rgba(0,0,0,0.08);
    }

    .icon {
        font-size: 60px;
        color: #2ecc71;
        margin-bottom: 20px;
    }

    .title {
        font-size: 26px;
        font-weight: bold;
        margin-bottom: 10px;
        color: #333;
    }

    .subtitle {
        font-size: 16px;
        color: #666;
        margin-bottom: 20px;
    }

    .order-info {
        background: #f9f9f9;
        padding: 15px;
        border-radius: 8px;
        margin: 20px 0;
        font-size: 15px;
    }

    .btn-group {
        margin-top: 25px;
    }

    .btn {
        padding: 12px 20px;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        font-size: 15px;
        margin: 5px;
    }

    .btn-primary {
        background: #3498db;
        color: white;
    }

    .btn-primary:hover {
        background: #2980b9;
    }

    .btn-secondary {
        background: #2ecc71;
        color: white;
    }

    .btn-secondary:hover {
        background: #27ae60;
    }
</style>

<div class="success-container">

    <div class="icon">✔</div>

    <div class="title">
        Payment Successful!
    </div>

    <div class="subtitle">
        Thank you for your purchase.<br/>
        Your order has been confirmed.
    </div>

    <div class="order-info">
        <b>Order ID:</b> #${param.orderId}<br/>
        <b>Status:</b> WAITING PICKUP<br/>
        <b>Note:</b> Please come to the library to receive your books.
    </div>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/reader/orders">
            <button class="btn btn-primary">📄 View My Orders</button>
        </a>

        <a href="${pageContext.request.contextPath}/reader/books">
            <button class="btn btn-secondary">📚 Continue Shopping</button>
        </a>
    </div>

</div>