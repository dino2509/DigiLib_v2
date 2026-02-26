<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .navbar-orange { background-color: #ff7a18; }
    .navbar-orange .nav-link, .navbar-orange .navbar-brand { color: #fff !important; font-weight: 500; }
    .navbar-orange .nav-link:hover { color: #ffe3cc !important; }

    /* Fix: tránh chữ ở menu bị xuống dòng ("Thể loại", "Đang mượn"...) */
    .navbar-orange .nav-link { white-space: nowrap; }
    .navbar-orange .navbar-nav { flex-wrap: nowrap; }

    .search-input { width: 340px; }
    @media (max-width: 992px) { .search-input { width: 100%; } }
</style>

<nav class="navbar navbar-expand-lg navbar-orange shadow-sm">
    <div class="container">
        <!-- DigiLib (/home) -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 DigiLib</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCommon">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarCommon">
            <!-- Thứ tự từ trái sang phải: Search -> Books -> Categories -> (Guest: Login/Register) OR (Reader: Favorites/Borrowed/Profile) -->

            <!-- Search -->
            <form class="d-flex me-3 order-lg-1 order-2 w-100 w-lg-auto mt-2 mt-lg-0"
                  action="${pageContext.request.contextPath}/search" method="get">
                <input class="form-control form-control-sm search-input" type="search" name="q"
                       value="${param.q}" placeholder="Tìm sách..." aria-label="Search">
                <button class="btn btn-sm btn-light ms-2" type="submit">🔎</button>
            </form>

            <!-- Menu -->
            <ul class="navbar-nav me-auto order-lg-2 order-1 flex-nowrap">
                <!-- /books -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/books">Sách</a>
                </li>

                <!-- /categories -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/categories">Thể loại</a>
                </li>

                <!-- Reader-only -->
                <c:if test="${sessionScope.user != null && sessionScope.user.getClass().simpleName eq 'Reader'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/reader/favorites">Yêu thích</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/reader/borrowed">Đang mượn</a>
                    </li>
                </c:if>
            </ul>

            <!-- Right side: Guest Login/Register OR Reader Profile dropdown -->
            <div class="d-flex align-items-center gap-2 order-lg-3 order-3 flex-nowrap">
                <c:choose>
                    <c:when test="${sessionScope.user == null}">
                        <!-- Guest: /login, /register -->
                        <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                        <a class="btn btn-sm btn-outline-light" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                    </c:when>
                    <c:otherwise>
                        <!-- Reader: Profile dropdown -->
                        <div class="dropdown">
                            <a class="btn btn-sm btn-light dropdown-toggle" href="#" data-bs-toggle="dropdown">
                                👤 ${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/reader/profile">
                                        Hồ sơ cá nhân
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/change-password">
                                        Đổi mật khẩu
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</nav>

<!-- Bootstrap JS (required for dropdown / collapse) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>