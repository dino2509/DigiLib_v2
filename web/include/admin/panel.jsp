<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    :root {
        --sidebar-bg: #ff8c00;        /* cam chủ đạo */
        --sidebar-dark: #e67600;      /* cam đậm */
        --sidebar-hover: #ffa733;     /* cam sáng hover */
        --sidebar-active: #d65f00;    /* cam active */
        --sidebar-text: #ffffff;
        --sidebar-muted: #ffe0b2;
    }

    .sidebar {
        width: 260px;
        min-height: 100vh;
        background: var(--sidebar-bg);
        color: var(--sidebar-text);
        font-family: Arial, sans-serif;
    }

    /* BRAND */
    .sidebar .brand {
        padding: 18px 20px;
        font-size: 18px;
        font-weight: bold;
        background: var(--sidebar-dark);
        text-align: center;
        letter-spacing: 1px;
    }

    /* SECTION */
    .sidebar .section {
        margin-top: 12px;
    }

    .sidebar .section-title {
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 20px;
        color: var(--sidebar-muted);
        opacity: 0.9;
    }

    /* LINK */
    .sidebar a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 11px 20px;
        margin: 3px 10px;
        border-radius: 6px;
        color: var(--sidebar-text);
        text-decoration: none;
        font-size: 14px;
        transition: background 0.2s ease;
    }

    .sidebar a:hover {
        background: var(--sidebar-hover);
        color: #fff;
    }

    .sidebar a.active {
        background: var(--sidebar-active);
        font-weight: bold;
        box-shadow: inset 3px 0 0 #fff;
    }

    .sidebar hr {
        border: none;
        border-top: 1px solid rgba(255,255,255,0.3);
        margin: 12px 0;
    }
</style>

<div class="sidebar">

    <!-- BRAND -->
    <div class="brand">
        📚 CORE LIBRARY
    </div>

    <!-- DASHBOARD -->
    <div class="section">
        <div class="section-title">Dashboard</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="${activeMenu == 'dashboard' ? 'active' : ''}">
            📊 Dashboard
        </a>
    </div>

    <!-- SYSTEM -->
    <div class="section">
        <div class="section-title">System</div>
        <a href="${pageContext.request.contextPath}/admin/notifications"
           class="${activeMenu == 'notification' ? 'active' : ''}">
            🔔 Notifications
        </a>
    </div>

    <!-- MANAGEMENT -->
    <div class="section">
        <div class="section-title">Management</div>

        <a href="${pageContext.request.contextPath}/admin/books"
           class="${activeMenu == 'book' ? 'active' : ''}">
            📚 Books
        </a>

        <a href="${pageContext.request.contextPath}/admin/bookcopies"
           class="${activeMenu == 'bookcopy' ? 'active' : ''}">
            📖 Book Copies
        </a>

        <a href="${pageContext.request.contextPath}/admin/authors"
           class="${activeMenu == 'author' ? 'active' : ''}">
            ✍️ Authors
        </a>

        <a href="${pageContext.request.contextPath}/admin/categories"
           class="${activeMenu == 'category' ? 'active' : ''}">
            🗂 Categories
        </a>
    </div>

    <!-- USERS -->
    <div class="section">
        <div class="section-title">Users</div>

        <a href="${pageContext.request.contextPath}/admin/readers"
           class="${activeMenu == 'reader' ? 'active' : ''}">
            👤 Readers
        </a>

        <a href="${pageContext.request.contextPath}/admin/employees"
           class="${activeMenu == 'employee' ? 'active' : ''}">
            🧑‍💼 Employees
        </a>

        <a href="${pageContext.request.contextPath}/admin/roles"
           class="${activeMenu == 'role' ? 'active' : ''}">
            🔐 Roles
        </a>
    </div>

    <hr>

    <!-- LOGOUT -->
    <div class="section">
        <a href="${pageContext.request.contextPath}/logout">
            🚪 Logout
        </a>
    </div>

</div>
