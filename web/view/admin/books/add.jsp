<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    body {
        background: linear-gradient(135deg, #fff7ed, #ffedd5);
    }

    .add-wrapper {
        max-width: 1100px;
        margin: 50px auto;
        padding: 0 20px;
    }

    .add-card {
        background: rgba(255,255,255,0.95);
        backdrop-filter: blur(6px);
        padding: 42px 48px;
        border-radius: 22px;
        border: 1px solid #fed7aa;
        box-shadow:
            0 30px 60px rgba(0,0,0,0.12),
            inset 0 1px 0 rgba(255,255,255,0.6);
    }

    .add-title {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 14px;
        font-size: 28px;
        font-weight: 800;
        color: #ea580c;
        margin-bottom: 38px;
        position: relative;
    }

    .add-title::after {
        content: "";
        position: absolute;
        bottom: -14px;
        width: 90px;
        height: 4px;
        border-radius: 999px;
        background: linear-gradient(90deg, #fb923c, #ea580c);
    }

    label {
        font-weight: 600;
        color: #374151;
        margin-bottom: 8px;
        font-size: 14px;
    }

    .form-control,
    .form-select {
        height: 48px;
        border-radius: 14px;
        font-size: 14px;
        border: 1px solid #e5e7eb;
        padding: 0 14px;
        transition: all 0.25s ease;
    }

    textarea.form-control {
        height: auto;
        padding: 12px 14px;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #fb923c;
        box-shadow: 0 0 0 4px rgba(251,146,60,0.25);
    }

    .row.g-4 > [class^="col"] {
        display: flex;
        flex-direction: column;
    }

    /* ===== COVER PREVIEW ===== */
    .cover-preview {
        display: flex;
        justify-content: center;
        margin-top: 10px;
    }

    .cover-preview img {
        max-height: 220px;
        border-radius: 14px;
        border: 1px solid #fed7aa;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        display: none;
    }

    .form-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 38px;
        padding-top: 26px;
        border-top: 1px dashed #fed7aa;
    }

    .btn-save {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        padding: 14px 42px;
        font-size: 15px;
        font-weight: 700;
        border-radius: 999px;
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .btn-save:hover {
        transform: translateY(-2px);
        box-shadow: 0 14px 30px rgba(249,115,22,0.45);
    }

    .btn-back {
        color: #ea580c;
        font-weight: 600;
        text-decoration: none;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .btn-back:hover {
        text-decoration: underline;
    }

    .select2-container .select2-selection--single {
        height: 48px;
        border-radius: 14px;
        border: 1px solid #e5e7eb;
        display: flex;
        align-items: center;
        padding: 0 10px;
    }

    .select2-container--default
    .select2-selection--single
    .select2-selection__arrow {
        height: 48px;
    }
</style>

<div class="add-wrapper">
    <div class="add-card">

        <div class="add-title">
            ➕ Thêm sách mới
        </div>

        <!-- ❗ multipart/form-data -->
        <form action="${pageContext.request.contextPath}/admin/books/add"
              method="post"
              enctype="multipart/form-data">

            <div class="row g-4">

                <div class="col-md-6">
                    <label>Tiêu đề</label>
                    <input type="text" name="title" class="form-control" required>
                </div>

                <div class="col-md-3">
                    <label>Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label>Đơn vị tiền</label>
                    <input type="text" name="currency" value="VND" class="form-control">
                </div>

                <div class="col-md-6">
                    <label>Danh mục</label>
                    <select class="form-select select2" name="category_id" required>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.category_id}">
                                ${c.category_name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6">
                    <label>Tác giả</label>
                    <select class="form-select select2" name="author_id" required>
                        <c:forEach items="${authors}" var="a">
                            <option value="${a.author_id}">
                                ${a.author_name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-6">
                    <label>Giá</label>
                    <input type="number" step="1000" name="price" class="form-control">
                </div>

                <!-- ===== UPLOAD COVER IMAGE ===== -->
                <div class="col-md-6">
                    <label>Ảnh bìa (Cover Image)</label>
                    <input type="file"
                           name="cover_url"
                           class="form-control"
                           accept="image/*"
                           onchange="previewCover(this)">
                    <div class="cover-preview">
                        <img id="coverPreview">
                    </div>
                </div>

                <div class="col-md-12">
                    <label>Tóm tắt</label>
                    <textarea name="summary" rows="3" class="form-control"></textarea>
                </div>

                <div class="col-md-12">
                    <label>Mô tả</label>
                    <textarea name="description" rows="4" class="form-control"></textarea>
                </div>

                <div class="col-md-12">
                    <label>Content Path</label>
                    <input type="text" name="content_path" class="form-control">
                </div>

            </div>

            <div class="form-footer">
                <button type="submit" class="btn-save">
                    💾 Lưu sách
                </button>

                <a href="${pageContext.request.contextPath}/admin/books"
                   class="btn-back">
                    ⬅ Quay lại
                </a>
            </div>

        </form>
    </div>
</div>

<script>
    $('.select2').select2({width: '100%'});

    function previewCover(input) {
        const file = input.files[0];
        if (!file)
            return;

        const reader = new FileReader();
        reader.onload = function (e) {
            const img = document.getElementById('coverPreview');
            img.src = e.target.result;
            img.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }
</script>
