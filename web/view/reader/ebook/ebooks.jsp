<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>.ebook-grid{
        display:grid;
        grid-template-columns:repeat(4,1fr);
        gap:20px;
    }

    .ebook-card{
        border:1px solid #ddd;
        padding:10px;
        text-align:center;
    }

    .ebook-card img{
        width:120px;
        height:160px;
        object-fit:cover;
    }

    .btn-read{
        display:inline-block;
        margin-top:10px;
        padding:6px 12px;
        background:#2c7be5;
        color:white;
        text-decoration:none;
        border-radius:4px;
    }

    .pagination{
        margin-top:20px;
    }

    .pagination a{
        padding:6px 12px;
        background:#eee;
        margin-right:5px;
        text-decoration:none;
    }

    .pagination a.active{
        background:#2c7be5;
        color:white;
    }</style>
<h2>Free Ebooks</h2>

<div class="ebook-grid">

    <c:forEach var="b" items="${ebooks}">

        <div class="ebook-card">

            <img class="book-cover"
                     src="${pageContext.request.contextPath}/img/book/${empty b.coverUrl ? 'no-cover.png' : b.coverUrl}"
                     alt="${b.title}">

            <h3>${b.title}</h3>

            <p>${b.totalPages} pages</p>

            <a href="${pageContext.request.contextPath}/read?id=${b.bookId}" target="_blank" class="btn-read">
                Read
            </a>

        </div>

    </c:forEach>

</div>


<div class="pagination">

    <c:forEach begin="1" end="${totalPages}" var="i">

        <a href="${pageContext.request.contextPath}/reader/ebooks?page=${i}"
           class="${i==page?'active':''}">
            ${i}
        </a>

    </c:forEach>

</div>