<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .box{
        background:white;
        padding:40px;
        border-radius:12px;
        box-shadow:0 8px 25px rgba(0,0,0,0.08);
        text-align:center;
    }

    .icon{
        font-size:60px;
        color:#f39c12;
    }

    .title{
        font-size:26px;
        font-weight:700;
        margin-top:15px;
        color:#2c3e50;
    }

    .desc{
        margin-top:10px;
        color:#7f8c8d;
        font-size:16px;
    }

    .order-info{
        margin-top:20px;
        font-size:18px;
        font-weight:500;
    }

    .highlight{
        color:#e67e22;
        font-weight:bold;
    }

    .btn-group{
        margin-top:30px;
    }

    .btn{
        padding:10px 20px;
        border:none;
        border-radius:6px;
        text-decoration:none;
        color:white;
        margin:5px;
        display:inline-block;
    }

    .btn-home{
        background:#3498db;
    }

    .btn-order{
        background:#2ecc71;
    }
</style>

<div class="box">

    <div class="icon">📚</div>

    <div class="title">
        Đặt sách thành công!
    </div>

    <div class="desc">
        Đơn hàng của bạn đã được ghi nhận.<br>
        Vui lòng đến <b class="highlight">thư viện</b> để thanh toán và nhận sách.
    </div>

    <!-- orderId -->
    <c:if test="${not empty param.orderId}">
        <div class="order-info">
            Mã đơn hàng: <b>#${param.orderId}</b>
        </div>
    </c:if>

    <div class="desc">
        📧 Thông tin chi tiết đã được gửi qua email của bạn.
    </div>

    <div class="desc" style="margin-top:10px;">
        ⏰ Vui lòng đến trong thời gian quy định để tránh bị hủy đơn.
    </div>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/reader/dashboard" class="btn btn-home">
            Về trang chủ
        </a>

        <a href="${pageContext.request.contextPath}/reader/orders" class="btn btn-order">
            Xem đơn hàng
        </a>
    </div>

</div>