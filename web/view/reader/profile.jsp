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

<jsp:include page="/include/reader/header.jsp"/>

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
        </div>

    </div>
</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
