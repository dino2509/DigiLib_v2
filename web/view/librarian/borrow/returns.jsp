<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h2>Return Books</h2>

<table border="1" width="100%">

    <tr>
        <th>Borrow ID</th>
        <th>Copy Code</th>
        <th>Book</th>
        <th>Due Date</th>
        <th>Action</th>
    </tr>

    <c:forEach var="i" items="${items}">

        <tr>

            <td>${i.borrowId}</td>

            <td>${i.copyCode}</td>

            <td>${i.bookTitle}</td>

            <td>${i.dueDate}</td>

            <td>

                <form method="post"
                      action="${pageContext.request.contextPath}/librarian/return">

                    <input type="hidden" name="borrowItemId"
                           value="${i.borrowItemId}">

                    <input type="hidden" name="copyId"
                           value="${i.copyId}">

                    <button type="submit">
                        Return
                    </button>

                </form>

            </td>

        </tr>

    </c:forEach>

</table>