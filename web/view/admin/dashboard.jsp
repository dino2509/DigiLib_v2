<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            }
        </style>
    </head>

    <body>

        <%@ include file="/include/admin/panel.jsp" %>

        <!-- ===== DASHBOARD CONTENT ===== -->

        <h2 class="fw-bold mb-4" style="color:#c2410c;">Admin Dashboard</h2>

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
                <a href="${pageContext.request.contextPath}/admin/books?action=add"
                   class="btn btn-orange">Add New Book</a>

                <a href="${pageContext.request.contextPath}/admin/categories"
                   class="btn btn-outline-warning">Manage Categories</a>

                <a href="${pageContext.request.contextPath}/admin/readers"
                   class="btn btn-outline-warning">Manage Users</a>

                <a href="${pageContext.request.contextPath}/admin/borrow"
                   class="btn btn-outline-warning">Borrow Requests</a>
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

        <!-- ===== ĐÓNG LAYOUT (panel.jsp mở) ===== -->
    </div> <!-- content -->
</div> <!-- main -->
</div> <!-- admin-container -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
