<table border="1">

    <tr>
        <th>ID</th>
        <th>Reader</th>
        <th>Status</th>
        <th>Requested At</th>
        <th>Action</th>
    </tr>

    <c:forEach items="${requests}" var="r">

        <tr>

            <td>${r.requestId}</td>
            <td>${r.reader.fullName}</td>
            <td>${r.status}</td>
            <td>${r.requestedAt}</td>

            <td>

                <form action="process-borrow-request" method="post">

                    <input type="hidden" name="requestId" value="${r.requestId}"/>

                    <button name="action" value="approve">Approve</button>

                    <button name="action" value="reject">Reject</button>

                </form>

            </td>

        </tr>

    </c:forEach>

</table>