<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    .topbar {
        height: 60px;
        background: #ffffff;
        border-bottom: 1px solid #e5e7eb;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
        font-family: Arial, sans-serif;
    }

    /* LEFT */
    .topbar-left {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .toggle-btn {
        font-size: 20px;
        cursor: pointer;
        color: #374151;
    }

    .breadcrumb {
        font-size: 14px;
        color: #6b7280;
    }

    .breadcrumb a {
        text-decoration: none;
        color: #2563eb;
    }

    /* RIGHT */
    .topbar-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .topbar-icon {
        font-size: 18px;
        cursor: pointer;
        color: #374151;
        position: relative;
    }

    .topbar-icon .badge {
        position: absolute;
        top: -4px;
        right: -6px;
        background: #ef4444;
        color: #fff;
        font-size: 10px;
        padding: 2px 5px;
        border-radius: 50%;
    }

    /* USER */
    .user-menu {
        position: relative;
    }

    .user-name {
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        color: #111827;
    }

    .user-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
    }

    .dropdown {
        position: absolute;
        right: 0;
        top: 45px;
        background: #fff;
        border: 1px solid #e5e7eb;
        border-radius: 6px;
        min-width: 180px;
        display: none;
        box-shadow: 0 10px 20px rgba(0,0,0,0.08);
        z-index: 1000;
    }

    .dropdown a {
        display: block;
        padding: 10px 15px;
        text-decoration: none;
        color: #374151;
        font-size: 14px;
    }

    .dropdown a:hover {
        background: #f3f4f6;
    }

    .user-menu:hover .dropdown {
        display: block;
    }
</style>

<div class="topbar">

    <!-- LEFT -->
    <div class="topbar-left">
        <div class="toggle-btn">☰</div>

        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Home</a>
            <c:if test="${not empty pageTitle}">
                / ${pageTitle}
            </c:if>
        </div>
    </div>

    <!-- RIGHT -->
    <div class="topbar-right">

        <!-- NOTIFICATION -->
        <div class="topbar-icon">
            🔔
            <span class="badge">3</span>
        </div>

        <!-- SETTINGS -->
        <div class="topbar-icon">⚙️</div>

        <!-- USER -->
        <c:if test="${not empty sessionScope.user}">
            <div class="user-menu">
                <div class="user-name">
                    <img src="${pageContext.request.contextPath}/assets/avatar.png"
                         class="user-avatar" alt="avatar">
                    ${sessionScope.user.fullName}
                </div>

                <div class="dropdown">
                    <a href="${pageContext.request.contextPath}/admin/profile">👤 Profile</a>
                    <a href="${pageContext.request.contextPath}/change-password">🔑 Change Password</a>
                    <hr>
                    <a href="${pageContext.request.contextPath}/logout"
                       style="color:#dc2626;">🚪 Logout</a>
                </div>
            </div>
        </c:if>

    </div>
</div>
