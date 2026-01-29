<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    :root {
        --orange: #ff8c00;
        --orange-dark: #e67600;
        --bg-light: #f9f9f9;
        --text-dark: #333;
    }

    .admin-container {
        display: flex;
        min-height: 100vh;
        background: var(--bg-light);
        font-family: Arial, sans-serif;
    }

    .sidebar {
        width: 240px;
        background: var(--orange);
        color: #fff;
    }

    .sidebar h2 {
        text-align: center;
        padding: 20px;
        margin: 0;
        background: var(--orange-dark);
        font-size: 20px;
    }

    .sidebar a {
        display: block;
        padding: 12px 20px;
        color: #fff;
        text-decoration: none;
        font-size: 15px;
    }

    .sidebar a:hover {
        background: rgba(255,255,255,0.2);
    }

    .main {
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    .topbar {
        background: #fff;
        padding: 12px 20px;
        border-bottom: 1px solid #ddd;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .topbar .title {
        font-size: 18px;
        color: var(--text-dark);
        font-weight: bold;
    }

    .content {
        padding: 20px;
    }
</style>

<div class="admin-container">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <h2>ADMIN PANEL</h2>

        <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Admin Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/notifications">🔔 System Notifications</a>

        <hr>

        <a href="${pageContext.request.contextPath}/admin/books">📚 Book Management</a>
        <a href="${pageContext.request.contextPath}/admin/book-copies">📖 Book Copy Management</a>
        <a href="${pageContext.request.contextPath}/admin/authors">✍️ Author Management</a>
        <a href="${pageContext.request.contextPath}/admin/categories">🗂 Category Management</a>

        <hr>

        <a href="${pageContext.request.contextPath}/admin/readers">👤 Reader Management</a>
        <a href="${pageContext.request.contextPath}/admin/employees">🧑‍💼 Employee Management</a>
        <a href="${pageContext.request.contextPath}/admin/roles">🔐 Role Management</a>

        <hr>

        <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
    </div>

    <!-- MAIN -->
    <div class="main">

        <div class="topbar">
            <div class="title">
                ${pageTitle != null ? pageTitle : "Admin Dashboard"}
            </div>

            <!-- USER DROPDOWN -->
            <ul class="navbar-nav ms-auto">
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="#" role="button"
                           data-bs-toggle="dropdown">
                            👤 ${sessionScope.user.fullName}
                        </a>

                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/admin/profile">
                                    Hồ sơ cá nhân
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/change-password">
                                    Change Password
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item text-danger"
                                   href="${pageContext.request.contextPath}/logout">
                                    Đăng xuất
                                </a>
                            </li>
                        </ul>
                    </li>
                </c:if>
            </ul>
        </div>

        <div class="content">
