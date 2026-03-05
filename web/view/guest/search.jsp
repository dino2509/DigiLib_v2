<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    /* SEARCH BAR */

    .home-search{
        display:flex;
        justify-content:center;
        margin:30px 0;
    }

    .home-search form{
        display:flex;
        width:650px;
        border-radius:6px;
        overflow:hidden;
        box-shadow:0 2px 10px rgba(0,0,0,0.1);
    }

    .home-search select{
        width:140px;
        padding:12px;
        border:none;
        background:#eee;
    }

    .home-search input{
        flex:1;
        padding:12px;
        border:none;
        outline:none;
    }

    .home-search button{
        width:120px;
        border:none;
        background:#f97316;
        color:white;
        font-weight:bold;
        cursor:pointer;
    }

    /* SEARCH INFO */

    .search-info{
        margin:20px 0;
        font-size:18px;
    }

    /* BOOK GRID */

    .book-list{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
        gap:25px;
    }

    /* BOOK CARD */

    .book-card{
        background:white;
        border-radius:10px;
        padding:15px;
        border:1px solid #e5e7eb;
        transition:0.2s;
    }

    .book-card:hover{
        transform:translateY(-5px);
        box-shadow:0 10px 20px rgba(0,0,0,0.1);
    }

    .book-cover{
        width:100%;
        height:240px;
        object-fit:cover;
        border-radius:6px;
        margin-bottom:10px;
    }

    .book-title{
        font-size:16px;
        font-weight:600;
        margin-bottom:8px;
    }

    .book-meta{
        font-size:13px;
        color:#555;
        margin-bottom:10px;
    }

    .price{
        color:#ef4444;
        font-weight:600;
    }

    .free{
        color:#16a34a;
        font-weight:600;
    }

    .btn-detail{
        display:block;
        text-align:center;
        padding:8px;
        background:#f97316;
        color:white;
        border-radius:6px;
        text-decoration:none;
        font-size:14px;
    }

    .no-result{
        text-align:center;
        margin-top:40px;
        font-size:18px;
        color:#777;
    }

    .pagination{
        margin-top:40px;
        display:flex;
        justify-content:center;
        gap:10px;
    }

    .pagination a{
        padding:8px 14px;
        border:1px solid #ddd;
        text-decoration:none;
        color:#333;
        border-radius:6px;
    }

    .pagination a:hover{
        background:#f97316;
        color:white;
    }

    .active-page{
        background:#f97316;
        color:white !important;
        border:none;
    }
    .pagination a.active{
        background:#f97316;
        color:white;
        border-color:none;
    }
</style>


<!-- SEARCH BAR -->

<div class="home-search">

    <form action="${pageContext.request.contextPath}/home/search" method="get">

        <select name="type">

            <option value="all"
                    ${param.type == 'all' || param.type == null ? 'selected' : ''}>
                All
            </option>

            <option value="title"
                    ${param.type == 'title' ? 'selected' : ''}>
                Title
            </option>

            <option value="author"
                    ${param.type == 'author' ? 'selected' : ''}>
                Author
            </option>

            <option value="category"
                    ${param.type == 'category' ? 'selected' : ''}>
                Category
            </option>

        </select>

        <input type="text"
               name="keyword"
               placeholder="Everything"
               value="${param.keyword}">

        <button type="submit">Search</button>

    </form>

</div>


<!-- SEARCH RESULT INFO -->

<div class="search-info">

    <c:if test="${not empty keyword}">
        Kết quả tìm kiếm cho: <strong>${keyword}</strong>
    </c:if>

</div>


<!-- NO RESULT -->

<c:if test="${empty books}">
    <div class="no-result">
        Không tìm thấy sách phù hợp
    </div>
</c:if>


<!-- RESULT LIST -->

<div class="book-list">

    <c:forEach items="${books}" var="b">

        <div class="book-card">

            <img class="book-cover"
                 src="${pageContext.request.contextPath}/img/book/${empty b.coverUrl ? 'no-cover.png' : b.coverUrl}"
                 alt="${b.title}">

            <h3 class="book-title">${b.title}</h3>

            <div class="book-meta">

                <p>
                    <strong>Author:</strong>
                    <c:out value="${b.author.author_name}" default="Unknown"/>
                </p>

                <p>
                    <strong>Category:</strong>
                    <c:out value="${b.category.category_name}" default="Other"/>
                </p>

            </div>

            <div>

                <c:choose>

                    <c:when test="${b.price == null || b.price == 0}">
                        <span class="free">Miễn phí</span>
                    </c:when>

                    <c:otherwise>
                        <span class="price">${b.price} VND</span>
                    </c:otherwise>

                </c:choose>

            </div>

            <br>

            <a href="${pageContext.request.contextPath}/book-detail?id=${b.bookId}"
               class="btn-detail">
                Xem chi tiết
            </a>

        </div>

    </c:forEach>

</div>
<div class="pagination">

    <c:if test="${currentPage > 1}">
        <a href="${pageContext.request.contextPath}/home/search?page=${currentPage-1}&keyword=${keyword}&type=${type}">
            Previous
        </a>
    </c:if>

    <c:forEach begin="1" end="${totalPages}" var="i">
        <a class="${i==currentPage?'active':''}"
           href="${pageContext.request.contextPath}/home/search?page=${i}&keyword=${keyword}&type=${type}">
            ${i}
        </a>
    </c:forEach>

    <c:if test="${currentPage < totalPages}">
        <a href="${pageContext.request.contextPath}/home/search?page=${currentPage+1}&keyword=${keyword}&type=${type}">
            Next
        </a>
    </c:if>

</div>