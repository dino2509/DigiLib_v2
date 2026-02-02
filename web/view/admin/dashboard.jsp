<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    /* ===== DASHBOARD WRAP ===== */
    .dashboard-wrap {
        max-width: 1200px;
        margin: 0 auto;
    }

    /* ===== PAGE TITLE ===== */
    .dashboard-title {
        font-size: 26px;
        font-weight: 800;
        color: #c2410c;
        margin-bottom: 28px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* ===== STAT GRID ===== */
    .stat-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 28px;
    }

    .stat-card {
        background: #ffffff;
        border: 1px solid #fed7aa;
        border-radius: 18px;
        padding: 20px 22px;
        display: flex;
        align-items: center;
        gap: 16px;
        min-height: 110px;
        transition: all 0.2s ease;
    }

    .stat-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 28px rgba(0,0,0,0.12);
    }

    .stat-icon {
        width: 52px;
        height: 52px;
        border-radius: 14px;
        background: #fff7ed;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        color: #f97316;
        flex-shrink: 0;
    }

    .stat-info small {
        font-size: 13px;
        color: #6b7280;
    }

    .stat-info h4 {
        margin: 2px 0 0;
        font-weight: 800;
        font-size: 22px;
        color: #111827;
    }

    /* ===== SECTION CARD ===== */
    .dashboard-card {
        background: #ffffff;
        border: 1px solid #fed7aa;
        border-radius: 18px;
        padding: 22px 24px;
        margin-bottom: 24px;
    }

    .dashboard-card h5 {
        font-weight: 700;
        color: #c2410c;
        margin-bottom: 16px;
    }

    /* ===== BUTTON ===== */
    .btn-orange {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        border-radius: 999px;
        padding: 10px 22px;
        font-weight: 600;
        font-size: 14px;
        text-decoration: none;
    }

    .btn-orange:hover {
        box-shadow: 0 8px 20px rgba(234,88,12,0.45);
        color: #fff;
    }

    /* ===== ACTIVITY LIST ===== */
    .activity-list li {
        padding: 10px 0;
        border-bottom: 1px dashed #fed7aa;
        font-size: 14px;
    }

    .activity-list li:last-child {
        border-bottom: none;
    }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 992px) {
        .stat-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 576px) {
        .stat-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="dashboard-wrap">

    <!-- TITLE -->
    <div class="dashboard-title">
        📊 Admin Dashboard
    </div>

    <!-- STATISTICS -->
    <div class="stat-grid">

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-book"></i>
            </div>
            <div class="stat-info">
                <small>Total Books</small>
                <h4>1,250</h4>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-users"></i>
            </div>
            <div class="stat-info">
                <small>Users</small>
                <h4>540</h4>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-repeat"></i>
            </div>
            <div class="stat-info">
                <small>Borrowed</small>
                <h4>87</h4>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fa-solid fa-cart-shopping"></i>
            </div>
            <div class="stat-info">
                <small>Orders</small>
                <h4>23</h4>
            </div>
        </div>

    </div>

    <!-- QUICK ACTIONS -->
    <div class="dashboard-card">
        <h5>⚡ Quick Actions</h5>

        <div class="d-flex gap-3 flex-wrap">
            <a href="${pageContext.request.contextPath}/admin/books?action=add"
               class="btn-orange">
                ➕ Add New Book
            </a>

            <a href="${pageContext.request.contextPath}/admin/categories"
               class="btn btn-outline-warning rounded-pill px-4">
                📂 Categories
            </a>

            <a href="${pageContext.request.contextPath}/admin/readers"
               class="btn btn-outline-warning rounded-pill px-4">
                👤 Readers
            </a>

            <a href="${pageContext.request.contextPath}/admin/borrow"
               class="btn btn-outline-warning rounded-pill px-4">
                🔁 Borrow Requests
            </a>
        </div>
    </div>

    <!-- RECENT ACTIVITIES -->
    <div class="dashboard-card">
        <h5>🕒 Recent Activities</h5>

        <ul class="list-unstyled mb-0 activity-list">
            <li>📚 User A borrowed <b>Clean Code</b></li>
            <li>👤 New user registered</li>
            <li>🛒 Order #1021 completed</li>
            <li>🔁 Book <b>Design Patterns</b> returned</li>
        </ul>
    </div>

</div>
