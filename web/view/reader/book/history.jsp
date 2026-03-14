<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h2>Reading History</h2>

<div class="ebook-grid">

    <c:forEach var="h" items="${history}">

        <div class="ebook-card">

            <img class="book-cover"
                 src="${pageContext.request.contextPath}/img/book/${empty h.coverUrl ? 'no-cover.png' : h.coverUrl}">

            <h3>${h.title}</h3>

            <p>Last page: ${h.lastReadPosition}</p>

            <p>${h.lastReadAt}</p>

            <a href="${pageContext.request.contextPath}/reader/read?bookId=${h.bookId}"
               class="btn-read">
                Continue Reading
            </a>

        </div>

    </c:forEach>

</div>


<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="i">

        <a href="${pageContext.request.contextPath}/reader/history?page=${i}"
           class="${i==page?'active':''}">
            ${i}
        </a>

    </c:forEach>

</div>