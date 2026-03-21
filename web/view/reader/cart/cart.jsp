<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>

    .cart-container{
        background:white;
        padding:25px;
        border-radius:12px;
        box-shadow:0 8px 25px rgba(0,0,0,0.08);
    }

    .cart-title{
        font-size:26px;
        font-weight:700;
        margin-bottom:25px;
    }

    /* TABLE */

    .cart-table{
        width:100%;
        border-collapse:collapse;
    }

    .cart-table th{
        background:#f8f9fb;
        padding:14px;
        border-bottom:2px solid #eee;
    }

    .cart-table td{
        padding:14px;
        border-bottom:1px solid #f0f0f0;
        vertical-align:middle;
    }

    .cart-row:hover{
        background:#fafafa;
    }

    /* BOOK INFO */

    .book-info{
        display:flex;
        gap:12px;
        align-items:center;
    }

    .book-info img{
        width:60px;
        border-radius:6px;
    }

    .book-title{
        font-weight:600;
    }

    /* INPUT */

    .qty-input{
        width:60px;
        padding:6px;
        text-align:center;
    }

    /* BUTTON */

    .btn{
        padding:6px 14px;
        border:none;
        border-radius:6px;
        cursor:pointer;
    }

    .btn-danger{
        background:#e74c3c;
        color:white;
    }

    .btn-primary{
        background:#3498db;
        color:white;
    }

    /* CHECKOUT */

    .checkout-box{
        margin-top:25px;
        display:flex;
        justify-content:space-between;
        align-items:center;
    }

    .total{
        font-size:18px;
        font-weight:600;
    }

    /* PAGINATION */

    .pagination{
        margin-top:20px;
        text-align:center;
    }

    .pagination a{
        padding:6px 12px;
        margin:0 4px;
        border:1px solid #ddd;
        border-radius:6px;
        text-decoration:none;
    }

    .pagination a.active{
        background:#3498db;
        color:white;
    }

    /* EMPTY */

    .empty-cart{
        text-align:center;
        padding:40px;
        color:#777;
    }

</style>
<div>${error}</div>
<div class="cart-container">

    <div class="cart-title">
        🛒 My Shopping Cart
    </div>

    <c:if test="${empty cartItems}">
        <div class="empty-cart">
            <p>Your cart is empty.</p>
        </div>
    </c:if>

    <c:if test="${not empty cartItems}">

        <form action="${pageContext.request.contextPath}/reader/check-order" method="post">

            <table class="cart-table">

                <thead>
                    <tr>
                        <th>Select</th>
                        <th>Book</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>

                    <c:set var="grandTotal" value="0"/>

                    <c:forEach var="item" items="${cartItems}">

                        <tr class="cart-row">

                            <td>
                                <input type="checkbox" name="cartItemIds" value="${item.cartItemId}">
                            </td>

                            <!-- BOOK INFO -->
                            <td>
                                <div class="book-info">
                                    <img src="${pageContext.request.contextPath}/img/book/${item.coverUrl}">
                                    <div>
                                        <div class="book-title">${item.bookTitle}</div>
                                        <div style="font-size:12px;color:#777;">
                                            ${item.authorName}
                                        </div>
                                    </div>
                                </div>
                            </td>

                            <!-- PRICE -->
                            <td>
                                ${item.price} ${item.currency}
                            </td>

                            <!-- QUANTITY (EDITABLE) -->
                            <td>
                                <input type="number"
                                       value="${item.quantity}"
                                       min="1"
                                       class="qty-input"
                                       onchange="updateQuantity(${item.cartItemId}, this.value)">
                            </td>

                            <!-- TOTAL -->
                            <td>
                                ${item.price * item.quantity} ${item.currency}
                            </td>

                            <!-- REMOVE -->
                            <td>
                                <button type="button"
                                        class="btn btn-danger"
                                        onclick="removeItem(${item.cartItemId})">
                                    Remove
                                </button>
                            </td>

                        </tr>

                        <c:set var="grandTotal" value="${grandTotal + (item.price * item.quantity)}"/>

                    </c:forEach>

                </tbody>

            </table>

            <!-- CHECKOUT -->
            <div class="checkout-box">

                <div class="total">
                    Total: ${grandTotal} ${cartItems[0].currency}
                </div>

                <button class="btn btn-primary" onclick="return validateSelection()">
                    Thanh Toán
                </button>

            </div>

        </form>

        <!-- PAGINATION -->


    </c:if>

</div>

<script>
    function updateQuantity(cartItemId, quantity) {

        fetch('${pageContext.request.contextPath}/reader/cart-update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'cartItemId=' + cartItemId + '&quantity=' + quantity
        })
                .then(res => res.text())
                .then(data => {
                    location.reload(); // reload để update total
                });
    }

    function removeItem(cartItemId) {

        if (!confirm("Bạn có chắc muốn xoá?"))
            return;

        fetch('${pageContext.request.contextPath}/reader/cart-remove', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'cartItemId=' + cartItemId
        })
                .then(res => res.text())
                .then(data => {
                    location.reload();
                });
    }
</script>
<script>
    function validateSelection() {
        const checked = document.querySelectorAll('input[name="cartItemIds"]:checked');
        if (checked.length === 0) {
            alert("Please select at least one book!");
            return false;
        }
        return true;
    }
</script>