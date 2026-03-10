<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .detail-wrap {
        max-width: 1100px;
        margin: 0 auto;
        background: #fff;
        padding: 36px;
        border-radius: 20px;
        border: 1px solid #fed7aa;
        box-shadow: 0 20px 45px rgba(0,0,0,0.08);
    }

    /* HEADER */
    .book-header {
        display: flex;
        gap: 32px;
        margin-bottom: 32px;
    }

    .book-cover img {
        width: 220px;
        border-radius: 14px;
        border: 1px solid #fed7aa;
        box-shadow: 0 10px 28px rgba(0,0,0,0.12);
        object-fit: cover;
        background: #fff;
    }

    .book-info h2 {
        margin: 0;
        font-size: 26px;
        font-weight: 800;
        color: #c2410c;
    }

    .badge-status {
        display: inline-block;
        padding: 6px 18px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        margin: 12px 0 18px;
    }

    .ACTIVE {
        background: #22c55e;
    }
    .INACTIVE {
        background: #9ca3af;
    }

    .book-meta p {
        margin-bottom: 6px;
        font-size: 14px;
    }

    /* SECTION */
    .section {
        margin-top: 28px;
    }

    .section-title {
        font-size: 15px;
        font-weight: 700;
        color: #ea580c;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .section-content {
        font-size: 14px;
        color: #374151;
        line-height: 1.6;
        background: #fff7ed;
        padding: 16px 18px;
        border-radius: 14px;
        border: 1px dashed #fed7aa;
    }

    /* FOOTER */
    .footer-actions {
        margin-top: 36px;
        padding-top: 24px;
        border-top: 1px solid #fed7aa;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .btn-back {
        font-size: 14px;
        font-weight: 600;
        color: #ea580c;
        text-decoration: none;
    }

    .btn-back:hover {
        text-decoration: underline;
    }

    .btn-edit {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        padding: 10px 22px;
        border-radius: 999px;
        font-weight: 600;
        text-decoration: none;
        transition: .2s;
    }

    .btn-edit:hover {
        transform: translateY(-1px);
        box-shadow: 0 8px 20px rgba(234,88,12,.45);
        color: #fff;
    }

    .footer-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 25px;
    }

    .btn-edit {
        background: #ff9800;
        color: #fff;
        padding: 8px 14px;
        border-radius: 6px;
        text-decoration: none;
    }

    .btn-delete {
        background: #e53935;
        color: #fff;
        padding: 8px 14px;
        border-radius: 6px;
        text-decoration: none;
    }

    .btn-delete:hover {
        background: #c62828;
    }

</style>

<div class="detail-wrap">

    <!-- HEADER -->
    <div class="book-header">

        <div class="book-cover">
            <c:choose>
                <c:when test="${not empty book.coverUrl}">
                    <img src="${pageContext.request.contextPath}/img/book/${book.coverUrl}">
<!--                    <img src="${pageContext.request.contextPath}${book.coverUrl}">-->
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/img/no-cover.png">
                </c:otherwise>
            </c:choose>
        </div>

        <div class="book-info">
            <h2>${book.title}</h2>

            <span class="badge-status ${book.status}">
                ${book.status}
            </span>

            <div class="book-meta">
                <p><b>Tác giả:</b> ${book.author.author_name}</p>
                <p><b>Danh mục:</b> ${book.category.category_name}</p>
                <p>
                    <b>Giá:</b>
                    <c:choose>
                        <c:when test="${book.price != null}">
                            ${book.price} ${book.currency}
                        </c:when>
                        <c:otherwise>Miễn phí</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>
    </div>

    <!-- SUMMARY -->
    <div class="section">
        <div class="section-title">📌 Tóm tắt</div>
        <div class="section-content">${book.summary}</div>
    </div>

    <!-- DESCRIPTION -->
    <div class="section">
        <div class="section-title">📝 Mô tả</div>
        <div class="section-content">${book.description}</div>
    </div>

    <!-- CONTENT -->
    <div class="section">
        <div class="section-title">📂 Nội dung</div>
        <div class="section-content">${book.contentPath}</div>
    </div>

    <!-- META -->
    <div class="section">
        <div class="section-title">⚙️ Thông tin hệ thống</div>
        <div class="section-content">
            <p><b>Ngày tạo:</b> ${book.createdAt}</p>
            <p><b>Tạo bởi:</b> ${book.create_by.fullName}</p>

            <c:if test="${not empty book.update_by}">
                <p><b>Cập nhật:</b> ${book.updatedAt}</p>
                <p><b>Cập nhật bởi:</b> ${book.update_by.fullName}</p>
            </c:if>
        </div>
    </div>

    <!-- ACTIONS -->
    <div class="footer-actions">

        <!-- BACK -->
        <a href="javascript:history.back()" class="btn-back">
            ⬅ Quay lại
        </a>

        <!-- EDIT -->
        <a href="${pageContext.request.contextPath}/admin/books/edit?id=${book.bookId}"
           class="btn-edit">
            ✏️ Chỉnh sửa
        </a>

        <!-- DELETE -->
        <a href="${pageContext.request.contextPath}/admin/books/delete?id=${book.bookId}"
           class="btn-delete"
           onclick="return confirm('Bạn có chắc chắn muốn xóa sách này không?');">
            🗑 Xóa
        </a>

    </div>


</div>
