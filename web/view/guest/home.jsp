<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    :root{
        --primary:#f97316;
        --primary-soft:#fff7ed;
        --border:#e5e7eb;
        --text:#374151;
    }

    /* ===== BANNER ===== */

    .banner{
        background:linear-gradient(135deg,#f97316,#fb923c);
        color:white;
        text-align:center;
        padding:70px 20px;
        border-radius:14px;
        margin-bottom:35px;
    }

    .banner h1{
        font-size:36px;
        margin-bottom:10px;
    }

    .banner p{
        font-size:18px;
    }

    /* ===== SEARCH ===== */

    .home-search{
        display:flex;
        justify-content:center;
        margin:35px 0;
    }

    .home-search form{
        display:flex;
        width:500px;
        border:1px solid var(--border);
        border-radius:8px;
        overflow:hidden;
    }

    .home-search input{
        flex:1;
        padding:12px;
        border:none;
        outline:none;
    }

    .home-search button{
        padding:0 20px;
        border:none;
        background:var(--primary);
        color:white;
        cursor:pointer;
    }

    /* ===== SECTION ===== */

    .section-title{
        margin:40px 0 20px;
        font-size:24px;
        font-weight:600;
    }

    /* ===== BOOK LIST ===== */

    .book-list{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(180px,1fr));
        gap:22px;
    }

    /* ===== BOOK CARD ===== */

    .book-card{
        border:1px solid var(--border);
        border-radius:10px;
        padding:14px;
        background:white;
        transition:0.2s;
        text-align:center;
    }

    .book-card:hover{
        transform:translateY(-5px);
        box-shadow:0 8px 20px rgba(0,0,0,0.1);
    }

    .book-cover{
        width:100%;
        height:220px;
        object-fit:cover;
        border-radius:6px;
        margin-bottom:10px;
    }

    .book-card h3{
        font-size:16px;
        height:40px;
        overflow:hidden;
    }

    .book-card p{
        color:#ef4444;
        margin:8px 0;
    }

    .btn-detail{
        display:inline-block;
        padding:7px 12px;
        background:var(--primary);
        color:white;
        text-decoration:none;
        border-radius:6px;
        font-size:14px;
    }

    /* ===== STATS ===== */

    .stats{
        margin-top:60px;
        display:grid;
        grid-template-columns:repeat(3,1fr);
        gap:20px;
        text-align:center;
    }

    .stat-card{
        background:var(--primary-soft);
        padding:25px;
        border-radius:10px;
    }

    .stat-card h2{
        color:var(--primary);
    }

    /* ===== CTA ===== */

    .cta{
        margin-top:60px;
        padding:40px;
        background:#f9fafb;
        text-align:center;
        border-radius:12px;
    }

    .cta a{
        margin-top:15px;
        display:inline-block;
        padding:10px 20px;
        background:var(--primary);
        color:white;
        text-decoration:none;
        border-radius:8px;
    }
    .home-search{
        display:flex;
        justify-content:center;
        margin:40px 0;
    }

    .home-search form{
        display:flex;
        width:700px;
        border-radius:6px;
        overflow:hidden;
        box-shadow:0 2px 10px rgba(0,0,0,0.1);
    }

    .home-search select{
        width:150px;
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
    .book-list{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(220px,1fr));
        gap:25px;
    }

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
        margin-bottom:10px;
        height:40px;
        overflow:hidden;
    }

    .book-meta{
        font-size:13px;
        color:#555;
        line-height:1.5;
        margin-bottom:10px;
    }

    .book-price{
        margin-bottom:10px;
        font-weight:600;
    }

    .free{
        color:#16a34a;
    }

    .price{
        color:#ef4444;
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

</style>

<!-- ===== BANNER ===== -->

<section class="banner">
    <h1>📚 Thư viện số</h1>
    <p>Khám phá hàng nghìn tài liệu học tập miễn phí</p>
</section>

<!-- ===== SEARCH ===== -->

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

<!-- ===== BOOKS ===== -->

<h2 class="section-title">🔥 Sách nổi bật</h2>

<div class="book-list">

    <c:forEach items="${books}" var="b">

        <div class="book-card">

            <img class="book-cover"
                 src="${pageContext.request.contextPath}/img/book/${empty b.coverUrl 
                        ? 'no-cover.png' 
                        : b.coverUrl}"
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

            <div class="book-price">

                <c:choose>
                    <c:when test="${b.price == null || b.price == 0}">
                        <span class="free">Miễn phí</span>
                    </c:when>

                    <c:otherwise>
                        <span class="price">${b.price} ${b.currency}</span>
                    </c:otherwise>
                </c:choose>

            </div>

            <a href="${pageContext.request.contextPath}/book-detail?id=${b.bookId}"
               class="btn-detail">
                Xem chi tiết
            </a>

        </div>

    </c:forEach>

</div>

<!-- ===== STATS ===== -->

<div class="stats">

    <div class="stat-card">
        <h2>10.000+</h2>
        <p>Tài liệu</p>
    </div>

    <div class="stat-card">
        <h2>5.000+</h2>
        <p>Người dùng</p>
    </div>

    <div class="stat-card">
        <h2>50.000+</h2>
        <p>Lượt đọc</p>
    </div>

</div>

<!-- ===== CTA ===== -->

<div class="cta">
    <h2>Đăng ký để đọc sách miễn phí</h2>
    <p>Tham gia cộng đồng đọc sách của chúng tôi</p>

    <a href="${pageContext.request.contextPath}/register">
        Đăng ký ngay
    </a>
</div>