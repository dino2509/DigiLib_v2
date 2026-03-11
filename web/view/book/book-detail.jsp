<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    /* BOOK DETAIL */

    .book-detail{
        margin-top:30px;
    }

    /* CARD */

    .detail-wrapper{
        display:flex;
        gap:40px;
        background:white;
        padding:35px;
        border-radius:14px;
        box-shadow:0 10px 25px rgba(0,0,0,0.08);
    }

    /* COVER */

    .detail-cover img{
        width:240px;
        border-radius:10px;
        box-shadow:0 6px 15px rgba(0,0,0,0.1);
    }

    /* INFO */

    .detail-info{
        flex:1;
    }

    .detail-info h1{
        margin-bottom:12px;
        color:var(--primary-dark);
    }

    .meta{
        color:#666;
        margin-bottom:8px;
    }

    .price{
        font-size:20px;
        font-weight:700;
        margin:15px 0;
    }

    .free{
        color:#2ecc71;
    }

    /* STOCK */

    .stock{
        margin-top:10px;
        font-weight:600;
    }

    .stock.available{
        color:#27ae60;
    }

    .stock.out{
        color:#e74c3c;
    }

    /* RATING */

    .rating{
        margin:10px 0;
        color:#ff7a00;
        font-weight:600;
    }

    /* SUMMARY */

    .summary{
        margin-top:20px;
    }

    /* ACTIONS */

    .actions{
        margin-top:25px;
        display:flex;
        gap:12px;
        flex-wrap:wrap;
    }

    .btn-primary{
        background:var(--primary);
        color:white;
        padding:10px 18px;
        border-radius:8px;
        text-decoration:none;
        font-weight:600;
    }

    .btn-primary:hover{
        background:var(--primary-dark);
    }

    .btn-outline{
        border:2px solid var(--primary);
        color:var(--primary);
        padding:9px 16px;
        border-radius:8px;
        text-decoration:none;
    }

    .btn-outline:hover{
        background:var(--primary);
        color:white;
    }

    /* DESCRIPTION */

    .description{
        margin-top:40px;
        background:white;
        padding:25px;
        border-radius:12px;
        box-shadow:0 8px 20px rgba(0,0,0,0.05);
    }

    /* REVIEWS */

    .reviews{
        margin-top:40px;
        background:white;
        padding:25px;
        border-radius:12px;
    }

    .review-item{
        border-bottom:1px solid #eee;
        padding:10px 0;
    }

    /* ADD REVIEW */

    .add-review{
        margin-top:30px;
        background:white;
        padding:25px;
        border-radius:12px;
    }

    textarea{
        width:100%;
        height:80px;
        margin-top:10px;
        padding:10px;
        border-radius:6px;
        border:1px solid #ddd;
    }

    select{
        padding:6px;
        margin-top:8px;
    }

</style>


<div class="book-detail">

    <div class="detail-wrapper">

        <!-- COVER -->

        <div class="detail-cover">
            <img src="${pageContext.request.contextPath}/img/book/${empty book.coverUrl ? 'no-cover.png' : book.coverUrl}">
        </div>


        <!-- INFO -->

        <div class="detail-info">

            <h1>${book.title}</h1>

            <p class="meta">
                Tác giả: <strong>${book.author.author_name}</strong>
            </p>

            <p class="meta">
                Thể loại: <strong>${book.category.category_name}</strong>
            </p>

            <!-- RATING -->

            <div class="rating">
                ⭐ ${avgRating} / 5
            </div>


            <!-- PRICE -->

            <p class="price">

                <c:choose>

                    <c:when test="${book.price == null || book.price == 0}">
                        <span class="free">Miễn phí</span>
                    </c:when>

                    <c:otherwise>
                        ${book.price} ${book.currency}
                    </c:otherwise>

                </c:choose>

            </p>


            <!-- STOCK -->

            <c:choose>

                <c:when test="${copiesAvailable > 0}">
                    <p class="stock available">
                        📚 Còn ${copiesAvailable} bản 
                    </p>
                </c:when>

                <c:otherwise>
                    <p class="stock out">
                        ❌ Hết sách
                    </p>
                </c:otherwise>

            </c:choose>


            <!-- SUMMARY -->

            <div class="summary">
                <h3>Tóm tắt</h3>
                <p>${book.summary}</p>
            </div>


            <!-- ACTIONS -->

            <div class="actions">

                <!-- READ ONLINE -->

                <c:if test="${book.price == 0 || book.price == null || hasRead}">
                    <a href="${pageContext.request.contextPath}/read?id=${book.bookId}" class="btn-primary">
                        📖 Đọc online
                    </a>
                </c:if>


                <!-- BUY -->

                <c:if test="${book.price > 0}">
                    <a href="${pageContext.request.contextPath}/reader/cart/add?id=${book.bookId}" class="btn-outline">
                        🛒 Thêm vào giỏ
                    </a>

                    <a href="${pageContext.request.contextPath}/reader/buy?id=${book.bookId}" class="btn-primary">
                        💳 Mua ngay
                    </a>
                </c:if>


                <!-- BORROW -->

                <c:if test="${copiesAvailable > 0}">
                    <a href="${pageContext.request.contextPath}/reader/request?id=${book.bookId}" class="btn-outline">
                        📚 Mượn sách
                    </a>
                </c:if>


                <!-- RESERVATION -->

                <c:if test="${copiesAvailable == 0}">
                    <a href="${pageContext.request.contextPath}/reader/reserve?id=${book.bookId}" class="btn-outline">
                        ⏳ Đặt trước
                    </a>
                </c:if>

            </div>

        </div>

    </div>


    <!-- DESCRIPTION -->

    <div class="description">

        <h3>Mô tả chi tiết</h3>
        <p>${book.description}</p>

    </div>


    <!-- REVIEWS -->

    <div class="reviews">

        <h3>Đánh giá từ độc giả</h3>

        <c:forEach var="r" items="${reviews}">

            <div class="review-item">

                <strong>${r.readerName}</strong>

                <div class="rating">
                    ⭐ ${r.rating}/5
                </div>

                <p>${r.comment}</p>

            </div>

        </c:forEach>

    </div>


    <!-- ADD REVIEW (chỉ khi đã đọc hoặc đã trả) -->

    <c:if test="${hasReturned || hasRead}">

        <div class="add-review">

            <h3>Viết đánh giá</h3>

            <form action="${pageContext.request.contextPath}/reader/review" method="post">

                <input type="hidden" name="bookId" value="${book.bookId}">

                <label>Rating</label>

                <select name="rating">
                    <option value="5">⭐⭐⭐⭐⭐</option>
                    <option value="4">⭐⭐⭐⭐</option>
                    <option value="3">⭐⭐⭐</option>
                    <option value="2">⭐⭐</option>
                    <option value="1">⭐</option>
                </select>

                <textarea name="comment" placeholder="Nhận xét của bạn"></textarea>

                <br><br>

                <button class="btn-primary">Gửi đánh giá</button>

            </form>

        </div>

    </c:if>

</div>