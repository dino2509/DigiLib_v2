<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>.btn.return{
        background:#28a745;
        color:white;
        padding:6px 10px;
        border:none;
        border-radius:4px;
        cursor:pointer;
    }</style>
<h2>Borrow Detail #${borrow.borrowId}</h2>

<p>
    Reader: <b>${borrow.readerName}</b><br>
    Borrow Date:
    <fmt:formatDate value="${borrow.borrowDate}" pattern="yyyy-MM-dd HH:mm"/>
</p>

<table class="borrow-table">

    <thead>
        <tr>
            <th>Book</th>
            <th>Copy Code</th>
            <th>Due Date</th>
            <th>Returned</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>

    <tbody>

        <c:forEach var="i" items="${items}">

            <tr>

                <td>${i.bookTitle}</td>

                <td>${i.copyCode}</td>

                <td>
                    <fmt:formatDate value="${i.dueDate}" pattern="yyyy-MM-dd"/>
                </td>

                <td>

                    <c:choose>
                        <c:when test="${i.returnedAt != null}">
                            <fmt:formatDate value="${i.returnedAt}" pattern="yyyy-MM-dd"/>
                        </c:when>
                        <c:otherwise>
                            -
                        </c:otherwise>
                    </c:choose>

                </td>

                <td>${i.status}</td>

                <td>

                    <c:if test="${i.status == 'BORROWING'}">

                        <form method="post"
                              action="${pageContext.request.contextPath}/librarian/return">

                            <input type="hidden" name="borrowItemId"
                                   value="${i.borrowItemId}">

                            <input type="hidden" name="borrowId"
                                   value="${borrow.borrowId}">

                            <button type="submit" class="btn return">
                                Return
                            </button>

                        </form>

                    </c:if>

                </td>

            </tr>

        </c:forEach>

    </tbody>

</table>

<a class="back-btn"
   href="${pageContext.request.contextPath}/librarian/borrows">
    ← Back
</a>
