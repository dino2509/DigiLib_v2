<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h2>Checkout</h2>

<table class="table">

    <tr>
        <th>Book</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Total</th>
    </tr>

    <c:forEach items="${items}" var="i">

        <tr>

            <td>${i.bookTitle}</td>

            <td>$${i.price}</td>

            <td>${i.quantity}</td>

            <td>$${i.price * i.quantity}</td>

        </tr>

    </c:forEach>

</table>

<h3>Total: $${total}</h3>

<form action="${pageContext.request.contextPath}/reader/payment" method="post">

    <h4>Payment Method</h4>

    <select name="paymentMethod">

        <option value="CARD">Credit Card</option>
        <option value="PAYPAL">PayPal</option>
        <option value="BANK">Bank Transfer</option>

    </select>

    <br><br>

    <button class="btn btn-success">
        Confirm Payment
    </button>

</form>