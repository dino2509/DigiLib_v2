<h2>Order Detail</h2>

<table class="table">

    <tr>
        <th>Book</th>
        <th>Price</th>
        <th>Quantity</th>
    </tr>

    <c:forEach items="${items}" var="i">

        <tr>

            <td>${i.bookTitle}</td>
            <td>${i.price}</td>
            <td>${i.quantity}</td>

        </tr>

    </c:forEach>

</table>