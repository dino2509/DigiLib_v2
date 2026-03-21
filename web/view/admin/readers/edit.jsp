<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .edit-wrapper {
        max-width: 700px;
        margin: 0 auto;
    }

    .edit-card {
        background: #ffffff;
        padding: 32px 36px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 16px 36px rgba(0,0,0,0.08);
    }

    .edit-title {
        text-align: center;
        font-size: 24px;
        font-weight: 700;
        color: #c2410c;
        margin-bottom: 26px;
    }

    label {
        font-weight: 600;
        color: #374151;
        margin-bottom: 6px;
        font-size: 14px;
        display: block;
    }

    .form-control,
    .form-select {
        width: 100%;
        border-radius: 10px;
        font-size: 14px;
        padding: 10px 12px;
        margin-bottom: 16px;
        border: 1px solid #e5e7eb;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #f97316;
        box-shadow: 0 0 0 3px rgba(249,115,22,0.2);
        outline: none;
    }

    .avatar-preview {
        margin-top: 8px;
        text-align: center;
    }

    .avatar-preview img {
        max-width: 120px;
        max-height: 120px;
        border-radius: 50%;
        border: 2px solid #fed7aa;
        object-fit: cover;
        box-shadow: 0 6px 18px rgba(0,0,0,0.15);
    }

    .form-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 20px;
        padding-top: 16px;
        border-top: 1px dashed #fed7aa;
    }

    .btn-save {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        padding: 10px 30px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        border: none;
        cursor: pointer;
    }

    .btn-save:hover {
        box-shadow: 0 6px 18px rgba(234,88,12,0.45);
    }

    .btn-back {
        color: #ea580c;
        font-weight: 600;
        text-decoration: none;
        font-size: 14px;
    }

    .btn-back:hover {
        text-decoration: underline;
    }
</style>


<div class="edit-wrapper">
    <div class="edit-card">

        <div class="edit-title">✏ Cập nhật Reader</div>

        <c:if test="${not empty error}">
            <div style="color:red; margin-bottom:10px;">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/readers/edit"
              method="post"
              enctype="multipart/form-data"
              onsubmit="return validateForm()">

            <input type="hidden" name="reader_id" value="${reader.readerId}"/>

            <!-- AVATAR PREVIEW -->
            <div class="avatar-preview">
                <img id="previewAvatar"
                     src="${not empty reader.avatar 
                           ? pageContext.request.contextPath.concat('/img/avatar/').concat(reader.avatar)
                           : pageContext.request.contextPath.concat('/img/book/no-cover.png')}">
            </div>

            <label>Change Avatar</label>
            <input type="file" name="avatar" id="avatar" class="form-control" accept="image/*">

            <!-- FULL NAME -->
            <label>Họ tên</label>
            <input type="text" name="full_name" class="form-control"
                   value="${reader.fullName}" required>

            <!-- EMAIL -->
            <label>Email</label>
            <input type="email" name="email" class="form-control"
                   value="${reader.email}" required>

            <!-- PHONE -->
            <label>Phone</label>
            <input type="text" name="phone" class="form-control"
                   value="${reader.phone}">

            <!-- STATUS -->
            <label>Status</label>
            <select name="status" class="form-select">
                <option value="active" ${reader.status == 'active' ? 'selected' : ''}>Active</option>
                <option value="inactive" ${reader.status == 'inactive' ? 'selected' : ''}>Inactive</option>
            </select>

            <!-- ROLE FIX -->
            <input type="hidden" name="role_id" value="3">

            <div class="form-actions">
                <button type="submit" class="btn-save">💾 Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/readers"
                   class="btn-back">⬅ Quay lại</a>
            </div>

        </form>
    </div>
</div>

<script>
function validateForm() {

    let name = document.querySelector("[name='full_name']").value.trim();
    let phone = document.querySelector("[name='phone']").value.trim();
    let file = document.getElementById("avatar").files[0];

    if (name.length < 3) {
        alert("Tên phải >= 3 ký tự");
        return false;
    }

    if (phone && !/^[0-9]{9,11}$/.test(phone)) {
        alert("SĐT không hợp lệ");
        return false;
    }

    if (file) {
        if (file.size > 20 * 1024 * 1024) {
            alert("Avatar < 20MB");
            return false;
        }

        if (!file.type.startsWith("image/")) {
            alert("Chỉ cho phép ảnh");
            return false;
        }
    }

    return true;
}

// PREVIEW
document.getElementById("avatar").addEventListener("change", function(e){
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function(ev){
        document.getElementById("previewAvatar").src = ev.target.result;
    };
    reader.readAsDataURL(file);
});
</script>