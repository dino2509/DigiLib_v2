<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .confirm-box{
        background:white;
        padding:25px;
        border-radius:12px;
        box-shadow:0 8px 25px rgba(0,0,0,0.08);
    }

    .confirm-title{
        font-size:24px;
        font-weight:700;
        margin-bottom:20px;
        color:#2c3e50;
    }

    .confirm-table{
        width:100%;
        border-collapse:collapse;
    }

    .confirm-table th, .confirm-table td{
        padding:12px;
        border-bottom:1px solid #eee;
        text-align:left;
    }

    .total{
        margin-top:20px;
        font-size:20px;
        font-weight:bold;
        color:#e74c3c;
    }

    .btn-group{
        margin-top:25px;
        display:flex;
        gap:10px;
    }

    .btn-confirm{
        padding:10px 20px;
        background:#27ae60;
        color:white;
        border:none;
        border-radius:6px;
        cursor:pointer;
    }

    .btn-cancel{
        padding:10px 20px;
        background:#e74c3c;
        color:white;
        border:none;
        border-radius:6px;
        text-decoration:none;
        display:inline-block;
    }
</style>

<div class="confirm-box">

    <div class="confirm-title">✅ Xác nhận đơn hàng</div>

    <form action="${pageContext.request.contextPath}/reader/checkout/confirm" method="post">

        <!-- giữ lại cartItemIds -->
        <c:forEach var="id" items="${cartItemIds}">
            <input type="hidden" name="cartItemIds" value="${id}">
        </c:forEach>

        <!-- bảng sản phẩm -->
        <table class="confirm-table">
            <tr>
                <th>Sách</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
            </tr>

            <c:forEach var="item" items="${items}">
                <tr>
                    <td>${item.bookTitle}</td>
                    <td>${item.price} ${item.currency}</td>
                    <td>${item.quantity}</td>
                    <td>
                        ${item.price * item.quantity} ${item.currency}
                    </td>
                </tr>
            </c:forEach>
        </table>

        <!-- tổng tiền -->
        <div class="total">
            Tổng tiền: ${total} ${items[0].currency}
        </div>

        <!-- nút -->
        <div class="btn-group">
            <button type="submit" class="btn-confirm">
                Xác nhận Thanh Toán
            </button>

            <a href="${pageContext.request.contextPath}/reader/cart" class="btn-cancel">
                Hủy
            </a>
        </div>

    </form>

</div>