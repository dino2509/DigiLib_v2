<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    .adv-container{
        max-width:1100px;
        margin:auto;
        margin-top:40px;
    }

    .adv-title{
        text-align:center;
        font-size:32px;
        font-weight:600;
        margin-bottom:20px;
    }

    /* SEARCH BOX */

    .search-box{
        border:2px solid #f59e0b;
        padding:25px;
        background:white;
        margin-bottom:40px;
    }

    /* FILTER */

    .filter-row{
        display:grid;
        grid-template-columns:1fr 1fr 1fr 1fr;
        gap:20px;
        margin-bottom:20px;
    }

    .filter-row select{
        padding:10px;
    }

    /* KEYWORD ROW */

    .keyword-row{
        display:grid;
        grid-template-columns:150px 1fr 120px;
        gap:15px;
        margin-bottom:15px;
    }

    .keyword-row select,
    .keyword-row input{
        padding:10px;
    }

    /* BUTTON */

    .search-btns{
        text-align:center;
        margin-top:20px;
    }

    .btn-search{
        background:#3b82f6;
        color:white;
        padding:10px 25px;
        border:none;
        border-radius:5px;
        cursor:pointer;
    }

    .btn-reset{
        background:#f97316;
        color:white;
        padding:10px 25px;
        border:none;
        border-radius:5px;
        cursor:pointer;
        margin-left:10px;
    }

    /* BOOK GRID */

    .book-list{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
        gap:25px;
    }

    /* CARD */

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
        font-size:18px;
        color:#777;
        margin-top:20px;
    }

</style>


<div class="adv-container">

    <div class="adv-title">Tìm kiếm nâng cao</div>

    <!-- FORM ADVANCED SEARCH -->

    <div class="search-box">

        <form action="${pageContext.request.contextPath}/advanced-search" method="get">

            <div class="keyword-row">

                <select name="field1">
                    <option value="">---Tất cả---</option>
                    <option value="title" ${param.field1=='title'?'selected':''}>Title</option>
                    <option value="author" ${param.field1=='author'?'selected':''}>Author</option>
                    <option value="category" ${param.field1=='category'?'selected':''}>Category</option>
                </select>

                <input type="text" name="keyword1" value="${param.keyword1}" placeholder="Từ khóa tìm kiếm">

                <select name="logic1">
                    <option value="AND" ${param.logic1=='AND'?'selected':''}>Và</option>
                    <option value="OR" ${param.logic1=='OR'?'selected':''}>Hoặc</option>
                </select>

            </div>


            <div class="keyword-row">

                <select name="field2">
                    <option value="">---Tất cả---</option>
                    <option value="title" ${param.field2=='title'?'selected':''}>Title</option>
                    <option value="author" ${param.field2=='author'?'selected':''}>Author</option>
                    <option value="category" ${param.field2=='category'?'selected':''}>Category</option>
                </select>

                <input type="text" name="keyword2" value="${param.keyword2}" placeholder="Từ khóa tìm kiếm">

                <select name="logic2">
                    <option value="AND" ${param.logic2=='AND'?'selected':''}>Và</option>
                    <option value="OR" ${param.logic2=='OR'?'selected':''}>Hoặc</option>
                </select>

            </div>


            <div class="keyword-row">

                <select name="field3">
                    <option value="">---Tất cả---</option>
                    <option value="title" ${param.field3=='title'?'selected':''}>Title</option>
                    <option value="author" ${param.field3=='author'?'selected':''}>Author</option>
                    <option value="category" ${param.field3=='category'?'selected':''}>Category</option>
                </select>

                <input type="text" name="keyword3" value="${param.keyword3}" placeholder="Từ khóa tìm kiếm">

                <select name="logic3">
                    <option value="AND" ${param.logic3=='AND'?'selected':''}>Và</option>
                    <option value="OR" ${param.logic3=='OR'?'selected':''}>Hoặc</option>
                </select>

            </div>


            <!--            <div class="keyword-row">
            
                            <select name="field4">
                                <option value="">---Tất cả---</option>
                                <option value="title" ${param.field4=='title'?'selected':''}>Title</option>
                                <option value="author" ${param.field4=='author'?'selected':''}>Author</option>
                                <option value="category" ${param.field4=='category'?'selected':''}>Category</option>
                            </select>
            
                            <input type="text" name="keyword4" value="${param.keyword4}" placeholder="Từ khóa tìm kiếm">
            
                            <select name="logic4">
                                <option value="AND" ${param.logic4=='AND'?'selected':''}>Và</option>
                                <option value="OR" ${param.logic4=='OR'?'selected':''}>Hoặc</option>
                            </select>
            
                        </div>-->

            <div class="search-btns">

                <button class="btn-reset" type="submit">
                    Tìm kiếm
                </button>

                <!--                <button class="btn-reset" type="reset">
                                    Tìm lại
                                </button>-->

            </div>

        </form>

    </div>


    <!-- SEARCH RESULT -->

    <c:if test="${empty books}">
        <div class="no-result">
            Không tìm thấy tài liệu phù hợp
        </div>
    </c:if>


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

</div>