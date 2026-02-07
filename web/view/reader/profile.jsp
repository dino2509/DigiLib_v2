<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Reader Profile - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reader.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="profile-wrapper">

    <div class="profile-card">

        <!-- AVATAR + NAME -->
        <div class="profile-header">
            <img
                src="${empty reader.avatar ? 'https://via.placeholder.com/120?text=Avatar' : reader.avatar}"
                class="avatar"
                alt="Avatar"
            >
            <h2>${reader.fullName}</h2>
            <span class="role-badge">Reader</span>
        </div>

        <!-- INFO -->
        <div class="profile-body">
            <c:if test="${param.updated eq '1'}">
                <div class="alert alert-success">Cập nhật thông tin thành công.</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="info-row">
                <span class="label">📧 Email</span>
                <span class="value">${reader.email}</span>
            </div>

            <div class="info-row">
                <span class="label">📞 Phone</span>
                <span class="value">
                    <c:choose>
                        <c:when test="${empty reader.phone}">Not updated</c:when>
                        <c:otherwise>${reader.phone}</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div class="info-row">
                <span class="label">📌 Status</span>
                <span class="value status">${reader.status}</span>
            </div>

            <div class="info-row">
                <span class="label">📅 Member Since</span>
                <span class="value">
                    <c:choose>
                        <c:when test="${not empty reader.createdAt}">
                            ${reader.createdAt}
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <hr/>

            <h5 class="mb-3">Sửa thông tin</h5>
            <form method="post" action="${pageContext.request.contextPath}/reader/profile" class="row g-3">
                <div class="col-12">
                    <label class="form-label">Họ và tên</label>
                    <input class="form-control" name="fullName" value="${reader.fullName}" required />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Số điện thoại</label>
                    <input class="form-control" name="phone" value="${reader.phone}" placeholder="VD: 0987..." />
                </div>

                <div class="col-md-6">
                    <label class="form-label">Avatar URL</label>
                    <input class="form-control" name="avatar" value="${reader.avatar}" placeholder="https://..." />
                </div>

                <div class="col-12 d-flex gap-2">
                    <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/reader/profile">Huỷ</a>
                </div>
            </form>
        </div>

    </div>
</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
