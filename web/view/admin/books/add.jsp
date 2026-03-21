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

    .field-error {
        margin-top: 6px;
        font-size: 13px;
        color: #dc2626;
        font-weight: 600;
    }

    .input-error {
        border-color: #dc2626 !important;
        box-shadow: 0 0 0 2px rgba(220,38,38,.15);
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
</style>
<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
<div class="add-wrapper">
    <div class="add-card">

        <div class="add-title">
            ➕ Thêm sách mới
        </div>

        <form id="addForm"
              action="${pageContext.request.contextPath}/admin/books/add"
              method="post"
              enctype="multipart/form-data">

            <div class="row g-4">

                <div class="col-md-6">
                    <label>Tiêu đề</label>
                    <input type="text" name="title" class="form-control" required>
                </div>

                <div class="col-md-3">
                    <label>ISBN</label>
                    <input type="text"
                           name="isbn"
                           id="isbnInput"
                           class="form-control"
                           placeholder="ISBN">
                    <div id="isbnError" class="field-error"></div>
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



                <div class="col-md-12">
                    <label>Tóm tắt</label>
                    <textarea id="summaryEditor"
                              name="summary"
                              rows="3"
                              class="form-control"></textarea>
                </div>

                <div class="col-md-12">
                    <label>Mô tả</label>
                    <textarea id="descriptionEditor"
                              name="description"
                              rows="4"
                              class="form-control"></textarea>
                </div>

                <!-- COVER -->
                <div class="col-md-6">
                    <label>Ảnh bìa (Cover Image)</label>
                    <input type="file"
                           id="coverUpload"
                           name="cover_url"
                           class="form-control"
                           accept=".jpg,.jpeg,.png,.gif,.webp">
                    <div id="coverError" class="field-error"></div>

                    <div class="cover-preview">
                        <img id="coverPreview">
                    </div>
                </div>

                <!-- PDF -->
                <div class="col-md-12">
                    <label>Upload file PDF</label>
                    <input type="file"
                           id="pdfUpload"
                           name="content_path"
                           class="form-control"
                           accept=".pdf">
                    <div id="pdfError" class="field-error"></div>
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

<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>

<script>
    $(document).ready(function () {

        let coverValid = true;
        let pdfValid = true;
        let isbnValid = true;

        // =========================
        // ISBN VALIDATE
        // =========================
        $('#isbnInput').on('input', function () {

            isbnValid = true;
            const val = $(this).val().trim();
            const error = $('#isbnError');

            error.text('');
            $(this).removeClass('input-error');

            if (!val)
                return;

            if (!/^\d+$/.test(val)) {
                error.text('❌ ISBN chỉ được chứa số');
                $(this).addClass('input-error');
                isbnValid = false;
                return;
            }

            if (val.length < 6 || val.length > 13) {
                error.text('❌ ISBN phải từ 6 - 13 chữ số');
                $(this).addClass('input-error');
                isbnValid = false;
                return;
            }
        });


        // =========================
        // COVER VALIDATE (20MB)
        // =========================
        $('#coverUpload').on('change', function () {

            coverValid = true;
            const file = this.files[0];
            const error = $('#coverError');

            error.text('');
            $(this).removeClass('input-error');

            if (!file)
                return;

            const allowed = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
            const maxSize = 20 * 1024 * 1024; // ✅ 20MB

            if (!allowed.includes(file.type)) {
                error.text('❌ Chỉ cho phép JPG, PNG, GIF, WEBP');
                $(this).addClass('input-error');
                coverValid = false;
                this.value = '';
                return;
            }

            if (file.size > maxSize) {
                error.text('❌ Ảnh tối đa 20MB');
                $(this).addClass('input-error');
                coverValid = false;
                this.value = '';
                return;
            }

            // preview
            const reader = new FileReader();
            reader.onload = e => {
                $('#coverPreview').attr('src', e.target.result).show();
            };
            reader.readAsDataURL(file);
        });


        // =========================
        // PDF VALIDATE (50MB)
        // =========================
        $('#pdfUpload').on('change', function () {

            pdfValid = true;
            const file = this.files[0];
            const error = $('#pdfError');

            error.text('');
            $(this).removeClass('input-error');

            if (!file)
                return;

            const maxSize = 50 * 1024 * 1024; // ✅ 50MB

            if (file.type !== 'application/pdf') {
                error.text('❌ Chỉ được upload file PDF');
                $(this).addClass('input-error');
                pdfValid = false;
                this.value = '';
                return;
            }

            if (file.size > maxSize) {
                error.text('❌ PDF tối đa 50MB');
                $(this).addClass('input-error');
                pdfValid = false;
                this.value = '';
                return;
            }

            // check signature PDF
            const reader = new FileReader();
            reader.onload = function (e) {
                const arr = new Uint8Array(e.target.result).subarray(0, 4);
                const header = String.fromCharCode(...arr);

                if (header !== "%PDF") {
                    error.text('❌ File không phải PDF hợp lệ');
                    $('#pdfUpload').addClass('input-error');
                    pdfValid = false;
                    $('#pdfUpload').val('');
                }
            };
            reader.readAsArrayBuffer(file);
        });


        // =========================
        // FORM SUBMIT
        // =========================
        $('#addForm').on('submit', function (e) {

            

            if (!coverValid) {
                alert("Ảnh bìa không hợp lệ!");
                e.preventDefault();
                return;
            }

            if (!pdfValid) {
                alert("File PDF không hợp lệ!");
                e.preventDefault();
                return;
            }
        });

    });
</script>
<!-- CKEditor 5 Classic -->

<script>
    // CKEditor Summary
    ClassicEditor
            .create(document.querySelector('#summaryEditor'), {
                toolbar: [
                    'heading', '|',
                    'bold', 'italic', 'underline', '|',
                    'link', 'bulletedList', 'numberedList', '|',
                    'undo', 'redo'
                ]
            })
            .catch(error => {
                console.error(error);
            });

    // CKEditor Description
    ClassicEditor
            .create(document.querySelector('#descriptionEditor'), {
                toolbar: [
                    'heading', '|',
                    'bold', 'italic', 'underline', '|',
                    'link', 'bulletedList', 'numberedList', '|',
                    'blockQuote', 'insertTable', '|',
                    'undo', 'redo'
                ]
            })
            .catch(error => {
                console.error(error);
            });

    let isbnValid = true;

    $('#isbnInput').on('input', function () {

        isbnValid = true;
        const val = $(this).val().trim();
        const error = $('#isbnError');

        error.text('');
        $(this).removeClass('input-error');

        if (!val)
            return;

        // chỉ cho số
        if (!/^\d+$/.test(val)) {
            error.text('❌ ISBN chỉ được chứa số');
            $(this).addClass('input-error');
            isbnValid = false;
            return;
        }

        // độ dài hợp lý
        if (val.length < 6 || val.length > 13) {
            error.text('❌ ISBN phải từ 6-13 chữ số');
            $(this).addClass('input-error');
            isbnValid = false;
            return;
        }
    });
</script>

