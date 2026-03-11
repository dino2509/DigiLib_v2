<%@page contentType="text/html" pageEncoding="UTF-8"%>

<h2 style="margin-bottom:25px;">Reader Dashboard</h2>

<!-- ===== STATISTICS ===== -->

<div class="stats">

    <div class="card">
        <h3>${borrowCount}</h3>
        <p>Sách đang mượn</p>
    </div>

    <div class="card">
        <h3>${reservationCount}</h3>
        <p>Sách đã đặt</p>
    </div>

    <div class="card">
        <h3>${ebookCount}</h3>
        <p>Ebooks sở hữu</p>
    </div>

    <div class="card">
        <h3>${cartCount}</h3>
        <p>Sách trong giỏ</p>
    </div>

</div>


<!-- ===== RECENT READING ===== -->

<h3 class="section-title">Đọc gần đây</h3>

<div class="book-list">

    <c:forEach var="b" items="${recentBooks}">

        <div class="book-card">

            <img src="${b.coverUrl}" class="book-cover"/>

            <h4>${b.title}</h4>

            <p>${b.authorName}</p>

            <a class="btn-read"
               href="${pageContext.request.contextPath}/reader/read?bookId=${b.bookId}">
                Đọc tiếp
            </a>

        </div>

    </c:forEach>

</div>


<!-- ===== RECOMMENDED BOOKS ===== -->

<h3 class="section-title">Gợi ý cho bạn</h3>

<div class="book-list">

    <c:forEach var="b" items="${recommendedBooks}">

        <div class="book-card">

            <img src="${b.coverUrl}" class="book-cover"/>

            <h4>${b.title}</h4>

            <p>${b.authorName}</p>

            <a class="btn-detail"
               href="${pageContext.request.contextPath}/book-detail?id=${b.bookId}">
                Xem chi tiết
            </a>

        </div>

    </c:forEach>

</div>


<style>

    /* ===== STATS ===== */

    .stats{
        display:grid;
        grid-template-columns:repeat(4,1fr);
        gap:20px;
        margin-bottom:40px;
    }

    .card{
        background:white;
        padding:20px;
        border-radius:10px;
        text-align:center;
        box-shadow:0 4px 12px rgba(0,0,0,0.08);
    }

    .card h3{
        color:#ff7a00;
        font-size:28px;
    }

    /* ===== BOOK LIST ===== */

    .section-title{
        margin:30px 0 15px;
        color:#e56700;
    }

    .book-list{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(180px,1fr));
        gap:20px;
    }

    .book-card{
        background:white;
        border-radius:10px;
        padding:15px;
        text-align:center;
        box-shadow:0 4px 10px rgba(0,0,0,0.08);
    }

    .book-cover{
        width:120px;
        height:160px;
        object-fit:cover;
        margin-bottom:10px;
    }

    .btn-read{
        display:inline-block;
        margin-top:10px;
        background:#ff7a00;
        color:white;
        padding:7px 12px;
        border-radius:6px;
        text-decoration:none;
    }

    .btn-detail{
        display:inline-block;
        margin-top:10px;
        background:#ff7a00;
        color:white;
        padding:7px 12px;
        border-radius:6px;
        text-decoration:none;
    }

</style>