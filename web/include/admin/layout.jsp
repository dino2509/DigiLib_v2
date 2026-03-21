<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">

        <title>
            <c:choose>
                <c:when test="${not empty pageTitle}">
                    ${pageTitle}
                </c:when>
                <c:otherwise>
                    Admin Dashboard
                </c:otherwise>
            </c:choose>
        </title>

        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #f3f4f6;
            }

            /* ================= SIDEBAR ================= */
            :root {
                --sidebar-bg: #ff8c00;
                --sidebar-dark: #e67600;
                --sidebar-hover: #ffa733;
                --sidebar-active: #d65f00;
                --sidebar-text: #ffffff;
                --sidebar-muted: #ffe0b2;
            }

            .app-wrapper {
                display: flex;
                min-height: 100vh;
            }

            .sidebar {
                width: 260px;
                min-height: 100vh;
                background: var(--sidebar-bg);
                color: var(--sidebar-text);
            }

            .brand {
                padding: 18px;
                font-weight: bold;
                text-align: center;
                background: var(--sidebar-dark);
            }

            .section-title {
                font-size: 11px;
                padding: 10px 20px;
                color: var(--sidebar-muted);
            }

            .sidebar a {
                display: block;
                padding: 10px 20px;
                margin: 4px 10px;
                border-radius: 6px;
                color: white;
                text-decoration: none;
            }

            .sidebar a:hover {
                background: var(--sidebar-hover);
            }

            .sidebar a.active {
                background: var(--sidebar-active);
                font-weight: bold;
            }

            .sidebar hr {
                border: none;
                border-top: 1px solid rgba(255,255,255,0.3);
            }

            /* ================= MAIN ================= */
            .main-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            /* ================= TOPBAR ================= */
            .topbar {
                height: 60px;
                background: #fff;
                border-bottom: 1px solid #ddd;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 20px;
            }

            .breadcrumb {
                font-size: 14px;
                color: #666;
            }

            .topbar-right {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .user-menu {
                position: relative;
            }

            .user-menu:hover .dropdown {
                display: block;
            }

            .dropdown {
                display: none;
                position: absolute;
                right: 0;
                top: 35px;
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 8px;
                width: 180px;
            }

            .dropdown a {
                display: block;
                padding: 10px;
                text-decoration: none;
                color: #333;
            }

            .dropdown a:hover {
                background: #f3f4f6;
            }

            /* ================= CONTENT ================= */
            .content-wrapper {
                padding: 20px;
                flex: 1;
                background: #f9fafb;
            }

        </style>
    </head>

    <body>

        <div class="app-wrapper">

            <!-- ================= SIDEBAR ================= -->
            <div class="sidebar">

                <div class="brand">📚 DLS SYSTEM</div>

                <div class="section-title">Dashboard</div>
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                   class="${activeMenu == 'dashboard' ? 'active' : ''}">
                    📊 Dashboard
                </a>

                <div class="section-title">Management</div>
                <a href="${pageContext.request.contextPath}/admin/books"
                   class="${activeMenu == 'book' ? 'active' : ''}">📚 Books</a>

                <a href="${pageContext.request.contextPath}/admin/bookcopies"
                   class="${activeMenu == 'bookcopy' ? 'active' : ''}">📖 Book Copies</a>

                <a href="${pageContext.request.contextPath}/admin/authors"
                   class="${activeMenu == 'author' ? 'active' : ''}">✍️ Authors</a>

                <a href="${pageContext.request.contextPath}/admin/categories"
                   class="${activeMenu == 'category' ? 'active' : ''}">🗂 Categories</a>

                <div class="section-title">Users</div>
                <a href="${pageContext.request.contextPath}/admin/readers"
                   class="${activeMenu == 'reader' ? 'active' : ''}">👤 Readers</a>

                <a href="${pageContext.request.contextPath}/admin/employees"
                   class="${activeMenu == 'employee' ? 'active' : ''}">🧑‍💼 Employees</a>

                <a href="${pageContext.request.contextPath}/admin/roles"
                   class="${activeMenu == 'role' ? 'active' : ''}">🔐 Roles</a>

                <hr>

                <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>

            </div>

            <!-- ================= MAIN ================= -->
            <div class="main-wrapper">

                <!-- TOPBAR -->
                <div class="topbar">

                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Home</a>
                        <c:if test="${not empty pageTitle}">
                            / ${pageTitle}
                        </c:if>
                    </div>

                    <div class="topbar-right">

                        🔔
                        ⚙️

                        <c:if test="${not empty sessionScope.user}">
                            <div class="user-menu">
                                ${sessionScope.user.fullName}

                                <div class="dropdown">
                                    <a href="${pageContext.request.contextPath}/admin/profile">Profile</a>
                                    <a href="${pageContext.request.contextPath}/change-password">Change Password</a>
                                    <a href="${pageContext.request.contextPath}/logout"
                                       style="color:red;">Logout</a>
                                </div>
                            </div>
                        </c:if>

                    </div>

                </div>

                <!-- CONTENT -->
                <div class="content-wrapper">
                    <jsp:include page="${contentPage}" />
                </div>

            </div>

        </div>

    </body>
</html>