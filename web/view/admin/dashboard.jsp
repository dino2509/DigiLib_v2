<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<<<<<<< HEAD
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #fff7ed;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            width: 250px;
            min-height: 100vh;
            background: linear-gradient(180deg, #fb923c, #f97316);
            color: #fff;
        }
        .sidebar a {
            color: #fff;
            text-decoration: none;
            padding: 12px 20px;
            display: block;
        }
        .sidebar a:hover {
            background-color: rgba(255,255,255,0.15);
        }
        .card-stat {
            border: 1px solid #fed7aa;
            border-radius: 16px;
        }
        .card-stat i {
            font-size: 28px;
            color: #f97316;
        }
        .btn-orange {
            background-color: #f97316;
            color: #fff;
        }
        .btn-orange:hover {
            background-color: #ea580c;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="d-flex">

    <!-- Sidebar -->
    <div class="sidebar">
        <h4 class="text-center py-4 fw-bold">📚 Admin Panel</h4>
        <a href="#"><i class="fa-solid fa-chart-line me-2"></i> Dashboard</a>
        <a href="#"><i class="fa-solid fa-book me-2"></i> Books</a>
        <a href="#"><i class="fa-solid fa-layer-group me-2"></i> Categories</a>
        <a href="#"><i class="fa-solid fa-users me-2"></i> Users</a>
        <a href="#"><i class="fa-solid fa-repeat me-2"></i> Borrow Requests</a>
        <a href="#"><i class="fa-solid fa-cart-shopping me-2"></i> Orders</a>
        <a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket me-2"></i> Logout</a>
    </div>

    <!-- Main content -->
    <div class="flex-grow-1 p-4">
        <h2 class="fw-bold text-orange-700 mb-4" style="color:#c2410c;">Admin Dashboard</h2>

        <!-- Statistics -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card card-stat p-3">
                    <div class="d-flex align-items-center gap-3">
                        <i class="fa-solid fa-book"></i>
                        <div>
                            <small class="text-muted">Total Books</small>
                            <h4 class="fw-bold">1,250</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stat p-3">
                    <div class="d-flex align-items-center gap-3">
                        <i class="fa-solid fa-users"></i>
                        <div>
                            <small class="text-muted">Users</small>
                            <h4 class="fw-bold">540</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stat p-3">
                    <div class="d-flex align-items-center gap-3">
                        <i class="fa-solid fa-repeat"></i>
                        <div>
                            <small class="text-muted">Borrowed</small>
                            <h4 class="fw-bold">87</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card card-stat p-3">
                    <div class="d-flex align-items-center gap-3">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <div>
                            <small class="text-muted">Orders</small>
                            <h4 class="fw-bold">23</h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick actions -->
        <div class="card p-4 mb-4" style="border:1px solid #fed7aa; border-radius:16px;">
            <h5 class="fw-semibold mb-3" style="color:#c2410c;">Quick Actions</h5>
            <div class="d-flex gap-3 flex-wrap">
                <a href="#" class="btn btn-orange">Add New Book</a>
                <a href="#" class="btn btn-outline-warning">Manage Categories</a>
                <a href="#" class="btn btn-outline-warning">Manage Users</a>
                <a href="#" class="btn btn-outline-warning">Borrow Requests</a>
            </div>
        </div>

        <!-- Recent activities -->
        <div class="card p-4" style="border:1px solid #fed7aa; border-radius:16px;">
            <h5 class="fw-semibold mb-3" style="color:#c2410c;">Recent Activities</h5>
            <ul class="list-unstyled mb-0">
                <li>📚 User A borrowed <b>Clean Code</b></li>
                <li>👤 New user registered</li>
                <li>🛒 Order #1021 completed</li>
                <li>🔁 Book <b>Design Patterns</b> returned</li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
=======

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
>>>>>>> master
