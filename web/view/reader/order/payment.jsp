<h2>Payment</h2>

<h3>Total: $${total}</h3>

<form action="${pageContext.request.contextPath}/reader/payment" method="post">

    <input type="hidden" name="orderId" value="${orderId}">
    <input type="hidden" name="amount" value="${total}">

    Payment Method

    <select name="method">

        <option value="CARD">Credit Card</option>
        <option value="PAYPAL">PayPal</option>
        <option value="BANK">Bank Transfer</option>

    </select>

    <br><br>

    <button class="btn btn-success">
        Confirm Payment
    </button>

</form>