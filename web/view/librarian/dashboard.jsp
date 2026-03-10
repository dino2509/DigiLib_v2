<h1>Dashboard</h1>

<div class="cards">

    <div class="card">
        <h3>Total Books</h3>
        <p>${totalBooks}</p>
    </div>

    <div class="card">
        <h3>Total Users</h3>
        <p>${totalUsers}</p>
    </div>

    <div class="card">
        <h3>Total Authors</h3>
        <p>${totalAuthors}</p>
    </div>

    <div class="card">
        <h3>Total Orders</h3>
        <p>${totalOrders}</p>
    </div>

</div>

<br><br>

<h2>Recent Books</h2>

<table>

    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Price</th>
        <th>Status</th>
    </tr>

    <c:forEach items="${recentBooks}" var="b">

        <tr>
            <td>${b.bookId}</td>
            <td>${b.title}</td>
            <td>${b.author.name}</td>
            <td>${b.price}</td>
            <td>${b.status}</td>
        </tr>

    </c:forEach>

</table>