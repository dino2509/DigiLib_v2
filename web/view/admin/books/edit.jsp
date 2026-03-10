<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ================= THEME ================= -->
<style>
    :root {
        --primary: #f97316;
        --primary-soft: #ffedd5;
        --border: #e5e7eb;
        --text: #374151;
        --radius: 12px;
    }

    body {
        background: #fff;
        font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        color: var(--text);
    }

    .main {
        padding: 32px 20px;
    }

    .edit-card {
        max-width: 720px;
        margin: auto;
        border-radius: 16px;
        padding: 32px;
        border: 1px solid var(--border);
    }

    /* ===== HEADER ===== */
    .edit-title {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        color: var(--primary);
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 28px;
        position: relative;
    }

    .edit-title::after {
        content: "";
        position: absolute;
        bottom: -10px;
        width: 120px;
        height: 2px;
        background: var(--primary);
        border-radius: 999px;
    }

    /* ===== FORM ===== */
    .form-group {
        margin-bottom: 14px;
    }

    .form-group label {
        font-size: 13px;
        font-weight: 600;
        margin-bottom: 6px;
        display: block;
    }

    .form-control,
    .form-select {
        width: 100%;
        height: 42px;
        padding: 0 14px;
        border-radius: var(--radius);
        border: 1px solid var(--border);
        font-size: 14px;
    }

    textarea.form-control {
        height: auto;
        padding: 10px 14px;
    }

    .form-control:focus,
    .form-select:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 2px rgba(249,115,22,.15);
    }

    /* ===== ACTIONS ===== */
    .actions {
        margin-top: 28px;
        padding-top: 18px;
        border-top: 1px dashed #fed7aa;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .btn-save {
        background: var(--primary);
        color: #fff;
        border: none;
        padding: 10px 26px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .btn-save:hover {
        opacity: .9;
    }

    .btn-back {
        font-size: 13px;
        font-weight: 600;
        color: var(--primary);
        text-decoration: none;
    }

    .btn-back:hover {
        text-decoration: underline;
    }

    /* ===== SELECT2 ===== */
    .select2-container .select2-selection--single {
        height: 42px;
        border-radius: var(--radius);
        border: 1px solid var(--border);
        display: flex;
        align-items: center;
        padding: 0 10px;
    }
    .cover-preview {
        margin-top: 16px;
        text-align: center;
    }

    .cover-preview img {
        max-width: 160px;
        max-height: 220px;
        width: auto;
        height: auto;
        object-fit: cover;
        border-radius: 10px;
        border: 1px solid #fed7aa;
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        background: #fff;
    }

    /* ===== ALERT ===== */
    .alert-error {
        background: #fff1f2;
        border: 1px solid #fecdd3;
        color: #9f1239;
        padding: 14px 18px;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .alert-error i {
        color: #e11d48;
        font-size: 16px;
    }

</style>


<!-- ================= SCRIPTS ================= -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    $('.select2').select2({
        width: '100%'
    });
</script>

<!-- ================= CONTENT ================= -->
<div class="main">
    <div class="edit-card">

        <div class="edit-title">✏️ Cập nhật sách</div>




        <c:if test="${not empty book.coverUrl}">
            <div class="cover-preview">
                <img src="${pageContext.request.contextPath}/img/book/${book.coverUrl}" alt="Book Cover">
            </div>
        </c:if>
        <c:if test="${not empty errors}">
            <div class="alert-error">
                <i class="fa-solid fa-circle-exclamation"></i>
                <div>
                    <c:forEach items="${errors}" var="e">
                        <div>• ${e}</div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        <form action="${pageContext.request.contextPath}/admin/books/edit" method="post">
            <input type="hidden" name="book_id" value="${book.bookId}">

            <div class="row g-4">

                <div class="col-md-6 form-group">
                    <label>Tiêu đề</label>
                    <input name="title" value="${book.title}" class="form-control" required>
                </div>

                <div class="col-md-6 form-group">
                    <label>Giá</label>
                    <input type="number" step="0.01" name="price" value="${book.price}" class="form-control">
                </div>

                <div class="col-md-4 form-group">
                    <label>Đơn vị tiền</label>
                    <input name="currency" value="${book.currency}" class="form-control">
                </div>

                <div class="col-12 form-group">
                    <label>Tóm tắt</label>
                    <textarea name="summary" rows="3" class="form-control">${book.summary}</textarea>
                </div>

                <div class="col-12 form-group">
                    <label>Mô tả</label>
                    <textarea name="description" rows="4" class="form-control">${book.description}</textarea>
                </div>



                <div class="col-md-4 form-group">
                    <label>Danh mục</label>
                    <select name="category_id" class="form-select select2">
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.category_id}"
                                    ${book.category != null && c.category_id == book.category.category_id ? 'selected' : ''}>
                                ${c.category_name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-4 form-group">
                    <label>Tác giả</label>
                    <select name="author_id" class="form-select select2">
                        <c:forEach items="${authors}" var="a">
                            <option value="${a.author_id}"
                                    ${book.author != null && a.author_id == book.author.author_id ? 'selected' : ''}>
                                ${a.author_name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6 form-group">
                    <label>Trạng thái</label>
                    <select name="status" class="form-select">
                        <option ${book.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option ${book.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="col-md-6 form-group">
                    <label>Cover URL</label>
                    <input name="cover_url" value="${book.coverUrl}" class="form-control">
                </div>

                <div class="col-12 form-group">
                    <label>Content Path</label>
                    <input name="content_path" value="${book.contentPath}" class="form-control">
                </div>

            </div>

            <div class="actions">
                <button class="btn-save">💾 Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/books" class="btn-back">⬅ Quay lại</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
