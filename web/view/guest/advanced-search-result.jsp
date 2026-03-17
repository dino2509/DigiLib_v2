<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    .container{
        max-width:1200px;
        margin:auto;
        margin-top:40px;
    }

    .search-card{
        background:white;
        padding:30px;
        border-radius:12px;
        box-shadow:0 8px 20px rgba(0,0,0,0.08);
        margin-bottom:40px;
    }

    .search-title{
        font-size:26px;
        font-weight:600;
        margin-bottom:20px;
    }

    .row{
        display:grid;
        grid-template-columns:200px 1fr 120px;
        gap:15px;
        margin-bottom:15px;
    }

    .row input,
    .row select{
        padding:10px;
        border:1px solid #ddd;
        border-radius:6px;
    }

    .price-row{
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:20px;
        margin-top:10px;
    }

    .price-row input{
        padding:10px;
        border:1px solid #ddd;
        border-radius:6px;
    }

    .extra-filter{
        margin-top:15px;
    }

    .btn-group{
        margin-top:20px;
    }

    .btn{
        padding:10px 22px;
        border:none;
        border-radius:6px;
        cursor:pointer;
    }

    .btn-search{
        background:#2563eb;
        color:white;
    }

    .btn-reset{
        background:#ef4444;
        color:white;
        margin-left:10px;
    }

    .book-grid{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
        gap:25px;
    }

    .book-card{
        background:white;
        border-radius:10px;
        padding:15px;
        border:1px solid #eee;
        transition:0.2s;
    }

    .book-card:hover{
        transform:translateY(-4px);
        box-shadow:0 8px 20px rgba(0,0,0,0.1);
    }

    .book-cover{
        width:100%;
        height:240px;
        object-fit:cover;
        border-radius:6px;
    }

    .book-title{
        font-weight:600;
        margin-top:10px;
    }

    .book-meta{
        font-size:13px;
        color:#666;
        margin-top:5px;
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
        margin-top:10px;
        background:#f97316;
        color:white;
        padding:8px;
        border-radius:6px;
        text-decoration:none;
    }

    .pagination{
        margin-top:40px;
        display:flex;
        justify-content:center;
        gap:10px;
        flex-wrap:wrap;
    }

    .pagination a{
        padding:8px 14px;
        border:1px solid #ddd;
        border-radius:6px;
        text-decoration:none;
    }

    .pagination a.active{
        background:#f97316;
        color:white;
        border:none;
    }

</style>

<script>

    function validateSearch() {

        let min = document.querySelector("[name=priceMin]").value;
        let max = document.querySelector("[name=priceMax]").value;

        if (min && min < 0) {
            alert("Minimum price must be >= 0");
            return false;
        }

        if (max && max < 0) {
            alert("Maximum price must be >= 0");
            return false;
        }

        if (min && max && Number(min) > Number(max)) {
            alert("Min price cannot be greater than Max price");
            return false;
        }

        return true;
    }

</script>


<div class="container">

    <div class="search-card">

        <div class="search-title">Advanced Search</div>

        <form method="get"
              onsubmit="return validateSearch()"
              action="${pageContext.request.contextPath}/advanced-search">

            <!-- ROW 1 -->

            <div class="row">

                <select name="field1">
                    <option value="">All Fields</option>
                    <option value="title" ${field1=='title'?'selected':''}>Title</option>
                    <option value="author" ${field1=='author'?'selected':''}>Author</option>
                    <option value="category" ${field1=='category'?'selected':''}>Category</option>
                    <option value="isbn" ${field1=='isbn'?'selected':''}>ISBN</option>
                </select>

                <input type="text"
                       name="keyword1"
                       value="${keyword1}"
                       placeholder="Keyword">

                <select name="logic1">
                    <option value="AND" ${logic1=='AND'?'selected':''}>AND</option>
                    <option value="OR" ${logic1=='OR'?'selected':''}>OR</option>
                </select>

            </div>


            <!-- ROW 2 -->

            <div class="row">

                <select name="field2">
                    <option value="">All Fields</option>
                    <option value="title" ${field2=='title'?'selected':''}>Title</option>
                    <option value="author" ${field2=='author'?'selected':''}>Author</option>
                    <option value="category" ${field2=='category'?'selected':''}>Category</option>
                    <option value="isbn" ${field2=='isbn'?'selected':''}>ISBN</option>
                </select>

                <input type="text"
                       name="keyword2"
                       value="${keyword2}"
                       placeholder="Keyword">

                <select name="logic2">
                    <option value="AND" ${logic2=='AND'?'selected':''}>AND</option>
                    <option value="OR" ${logic2=='OR'?'selected':''}>OR</option>
                </select>

            </div>


            <!-- ROW 3 -->

            <div class="row">

                <select name="field3">
                    <option value="">All Fields</option>
                    <option value="title" ${field3=='title'?'selected':''}>Title</option>
                    <option value="author" ${field3=='author'?'selected':''}>Author</option>
                    <option value="category" ${field3=='category'?'selected':''}>Category</option>
                    <option value="isbn" ${field3=='isbn'?'selected':''}>ISBN</option>
                </select>

                <input type="text"
                       name="keyword3"
                       value="${keyword3}"
                       placeholder="Keyword">

                <div></div>

            </div>


            <!-- PRICE -->

            <div class="price-row">

                <input type="number"
                       name="priceMin"
                       value="${priceMin}"
                       placeholder="Min Price">

                <input type="number"
                       name="priceMax"
                       value="${priceMax}"
                       placeholder="Max Price">

            </div>


            <!-- EXTRA -->

            <div class="extra-filter">

                <label>
                    <input type="checkbox"
                           name="freeOnly"
                           value="1"
                           ${freeOnly ? 'checked' : ''}>
                    Free books only
                </label>

            </div>


            <div class="btn-group">

                <button class="btn btn-search">Search</button>

                <a href="${pageContext.request.contextPath}/advanced-search"
                   class="btn btn-reset">
                    Reset
                </a>

            </div>

        </form>

    </div>


    <!-- RESULT -->

    <div class="book-grid">

        <c:forEach items="${books}" var="b">

            <div class="book-card">

                <img class="book-cover"
                     src="${pageContext.request.contextPath}/img/book/${empty b.coverUrl ? 'no-cover.png' : b.coverUrl}">

                <div class="book-title">${b.title}</div>

                <div class="book-meta">

                    <p><b>Author:</b> ${b.author.author_name}</p>
                    <p><b>Category:</b> ${b.category.category_name}</p>
                    <p><b>ISBN:</b> ${b.isbn}</p>

                </div>

                <c:choose>

                    <c:when test="${b.price == null || b.price == 0}">
                        <div class="free">Free</div>
                    </c:when>

                    <c:otherwise>
                        <div class="price">${b.price} VND</div>
                    </c:otherwise>

                </c:choose>

                <a class="btn-detail"
                   href="${pageContext.request.contextPath}/book-detail?id=${b.bookId}">
                    View Detail
                </a>

            </div>

        </c:forEach>

    </div>


    <!-- PAGINATION -->

    <div class="pagination">

        <c:set var="query"
               value="&field1=${field1}&keyword1=${keyword1}&logic1=${logic1}
               &field2=${field2}&keyword2=${keyword2}&logic2=${logic2}
               &field3=${field3}&keyword3=${keyword3}
               &priceMin=${priceMin}&priceMax=${priceMax}
               &freeOnly=${freeOnly ? 1 : ''}" />

        <c:if test="${currentPage > 1}">
            <a href="${pageContext.request.contextPath}/advanced-search?page=${currentPage-1}${query}">
                Previous
            </a>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="i">

            <a class="${i==currentPage?'active':''}"
               href="${pageContext.request.contextPath}/advanced-search?page=${i}${query}">
                ${i}
            </a>

        </c:forEach>

        <c:if test="${currentPage < totalPages}">
            <a href="${pageContext.request.contextPath}/advanced-search?page=${currentPage+1}${query}">
                Next
            </a>
        </c:if>

    </div>

</div>