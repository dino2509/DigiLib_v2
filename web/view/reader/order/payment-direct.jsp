<h2>Payment</h2>

<table class="table">

    <tr>
        <th>Book</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Total</th>
    </tr>

    <tr>
        <td>${book.title}</td>
        <td>$${book.price}</td>
        <td>1</td>
        <td>$${book.price}</td>
    </tr>

</table>

<h3>Total: $${totalAmount}</h3>

<form action="${pageContext.request.contextPath}/reader/payment-direct" method="post">

    <input type="hidden" name="bookId" value="${book.bookId}">
    <input type="hidden" name="amount" value="${book.price}">

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