<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>

    .cart-container{
        background:white;
        padding:25px;
        border-radius:8px;
        box-shadow:0 2px 8px rgba(0,0,0,0.1);
    }

    .cart-title{
        font-size:24px;
        font-weight:600;
        margin-bottom:20px;
    }

    .cart-table{
        width:100%;
        border-collapse:collapse;
    }

    .cart-table th{
        background:#f5f6fa;
        padding:12px;
        border-bottom:2px solid #ddd;
    }

    .cart-table td{
        padding:12px;
        border-bottom:1px solid #eee;
    }

    .cart-table tr:hover{
        background:#fafafa;
    }

    .btn{
        padding:6px 14px;
        border:none;
        border-radius:4px;
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

    .checkout-box{
        margin-top:20px;
        text-align:right;
    }

    .empty-cart{
        text-align:center;
        padding:40px;
        color:#777;
    }

</style>


<div class="cart-container">

    <div class="cart-title">
        My Shopping Cart
    </div>

    <c:if test="${empty cartItems}">

        <div class="empty-cart">
            <p>Your cart is empty.</p>
        </div>

    </c:if>


    <c:if test="${not empty cartItems}">

        <form action="${pageContext.request.contextPath}/reader/checkout" method="post">

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

                    <c:forEach var="item" items="${cartItems}">

                        <tr>

                            <td>
                                <input type="checkbox" name="cartItemIds" value="${item.cartItemId}">
                            </td>

                            <td>
                                <strong>${item.bookTitle}</strong>
                            </td>

                            <td>
                                $${item.price}
                            </td>

                            <td>
                                ${item.quantity}
                            </td>

                            <td>
                                $${item.price * item.quantity}
                            </td>

                            <td>

                                <form action="${pageContext.request.contextPath}/reader/cart-remove" method="post">

                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">

                                    <button class="btn btn-danger">
                                        Remove
                                    </button>

                                </form>

                            </td>

                        </tr>

                    </c:forEach>

                </tbody>

            </table>


            <div class="checkout-box">

                <button class="btn btn-primary">
                    Checkout Selected Books
                </button>

            </div>

        </form>

    </c:if>

</div>