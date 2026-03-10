<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Reader Profile - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
    <style>
        .info-input { max-width: 360px; }
        .value-readonly { display: inline-block; padding: 6px 0; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="profile-wrapper">
    <div class="profile-card">

        <div class="profile-header">
            <img
                id="avatarPreview"
                src="${empty reader.avatar ? 'https://via.placeholder.com/120?text=Avatar' : reader.avatar}"
                class="avatar"
                alt="Avatar"
            >
            <h2 id="namePreview">${reader.fullName}</h2>
            <span class="role-badge">Reader</span>
        </div>

        <div class="profile-body">
            <c:if test="${param.updated eq '1'}">
                <div class="alert alert-success">Cập nhật thông tin thành công.</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form id="profileForm" method="post" action="${pageContext.request.contextPath}/reader/profile">

                <div class="info-row">
                    <span class="label">📧 Email</span>
                    <span class="value value-readonly">${reader.email}</span>
                </div>

                <div class="info-row">
                    <span class="label">👤 Họ và tên</span>
                    <div class="value">
                        <input id="fullName" class="form-control info-input" name="fullName" value="${reader.fullName}" required disabled />
                    </div>
                </div>

                <div class="info-row">
                    <span class="label">📞 Phone</span>
                    <div class="value">
                        <input id="phone" class="form-control info-input" name="phone" value="${reader.phone}" placeholder="VD: 0987..." disabled />
                    </div>
                </div>

                <div class="info-row">
                    <span class="label">🖼️ Avatar URL</span>
                    <div class="value">
                        <input id="avatar" class="form-control info-input" name="avatar" value="${reader.avatar}" placeholder="https://..." disabled />
                        <div class="small text-muted mt-1">Có thể để trống.</div>
                    </div>
                </div>

                <div class="info-row">
                    <span class="label">📌 Status</span>
                    <span class="value status value-readonly">${reader.status}</span>
                </div>

                <div class="info-row">
                    <span class="label">📅 Member Since</span>
                    <span class="value value-readonly">
                        <c:choose>
                            <c:when test="${not empty reader.createdAt}">${reader.createdAt}</c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <hr/>

                <div class="d-flex gap-2 flex-wrap">
                    <button id="btnEdit" type="button" class="btn btn-outline-primary">Sửa</button>
                    <button id="btnSave" type="submit" class="btn btn-primary d-none">Lưu thay đổi</button>
                    <button id="btnCancel" type="button" class="btn btn-outline-secondary d-none">Hủy</button>
                </div>

                <input type="hidden" id="origFullName" value="${reader.fullName}" />
                <input type="hidden" id="origPhone" value="${reader.phone}" />
                <input type="hidden" id="origAvatar" value="${reader.avatar}" />
            </form>
        </div>

    </div>
</div>

<jsp:include page="/include/reader/footer.jsp"/>

<script>
    (function () {
        const btnEdit = document.getElementById('btnEdit');
        const btnSave = document.getElementById('btnSave');
        const btnCancel = document.getElementById('btnCancel');

        const fullName = document.getElementById('fullName');
        const phone = document.getElementById('phone');
        const avatar = document.getElementById('avatar');
        const namePreview = document.getElementById('namePreview');
        const avatarPreview = document.getElementById('avatarPreview');

        const origFullName = document.getElementById('origFullName');
        const origPhone = document.getElementById('origPhone');
        const origAvatar = document.getElementById('origAvatar');

        function setEditMode(on) {
            fullName.disabled = !on;
            phone.disabled = !on;
            avatar.disabled = !on;

            btnEdit.classList.toggle('d-none', on);
            btnSave.classList.toggle('d-none', !on);
            btnCancel.classList.toggle('d-none', !on);

            if (on) {
                fullName.focus();
                fullName.select();
            }
        }

        btnEdit?.addEventListener('click', function () {
            setEditMode(true);
        });

        btnCancel?.addEventListener('click', function () {
            fullName.value = origFullName.value || '';
            phone.value = origPhone.value || '';
            avatar.value = origAvatar.value || '';

            namePreview.textContent = fullName.value || 'Reader';
            avatarPreview.src = (avatar.value && avatar.value.trim()) ? avatar.value.trim() : 'https://via.placeholder.com/120?text=Avatar';

            setEditMode(false);
        });

        fullName?.addEventListener('input', function () {
            namePreview.textContent = fullName.value || 'Reader';
        });
        avatar?.addEventListener('input', function () {
            const v = avatar.value ? avatar.value.trim() : '';
            avatarPreview.src = v ? v : 'https://via.placeholder.com/120?text=Avatar';
        });
    })();
</script>

</body>
</html>
