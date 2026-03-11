<%@page contentType="text/html" pageEncoding="UTF-8"%>

<h2>Borrow Request</h2>
<style>.borrow-form{
        background:white;
        padding:25px;
        border-radius:10px;
        max-width:500px;
        box-shadow:0 6px 15px rgba(0,0,0,0.1);
    }

    .book-info{
        display:flex;
        gap:20px;
        margin-bottom:20px;
    }

    .form-group{
        margin-bottom:15px;
    }

    textarea{
        width:100%;
        height:80px;
        padding:8px;
    }

    input[type=number]{
        width:100%;
        padding:6px;
    } </style>
<div class="borrow-form">

    <form method="post">

        <input type="hidden" name="bookId" value="${book.bookId}">

        <div class="book-info">

            <img src="${pageContext.request.contextPath}/img/book/${book.coverUrl}" width="120">

            <div>

                <h3>${book.title}</h3>

                <p>Tác giả: ${book.author.author_name}</p>

            </div>

        </div>

        <div class="form-group">

            <label>Số lượng</label>

            <input type="number" name="quantity" value="1" min="1" required>

        </div>

        <div class="form-group">

            <label>Ghi chú</label>

            <textarea name="note" placeholder="Ví dụ: cần cho nghiên cứu..."></textarea>

        </div>

        <button class="btn-primary">
            Gửi yêu cầu mượn
        </button>

    </form>

</div>