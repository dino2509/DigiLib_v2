<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .navbar-orange { background-color: #ff7a18; }
    .navbar-orange .nav-link, .navbar-orange .navbar-brand { color: #fff !important; font-weight: 500; }
    .navbar-orange .nav-link:hover { color: #ffe3cc !important; }

    .navbar-orange .nav-link { white-space: nowrap; }
    .navbar-orange .navbar-nav { flex-wrap: nowrap; }

    .search-input { width: 340px; }
    @media (max-width: 992px) { .search-input { width: 100%; } }
</style>

<nav class="navbar navbar-expand-lg navbar-orange shadow-sm">
    <div class="container">

        <c:choose>
            <c:when test="${sessionScope.user != null 
                           && sessionScope.user.getClass().simpleName eq 'Employee' 
                           && sessionScope.user.roleId == 2}">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/librarian/dashboard">
                    📚 DigiLib
                </a>
            </c:when>
            <c:otherwise>
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    📚 DigiLib
                </a>
            </c:otherwise>
        </c:choose>

        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarCommon">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarCommon">

            <form class="d-flex me-3 order-lg-1 order-2 w-100 w-lg-auto mt-2 mt-lg-0"
                  action="${pageContext.request.contextPath}/search"
                  method="get">
                <input class="form-control form-control-sm search-input"
                       type="search"
                       name="q"
                       value="${param.q}"
                       placeholder="Tìm sách..."
                       aria-label="Search">
                <button class="btn btn-sm btn-light ms-2" type="submit">🔎</button>
            </form>

            <ul class="navbar-nav me-auto order-lg-2 order-1 flex-nowrap">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/books">Sách</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/categories">Thể loại</a>
                </li>

                <c:if test="${sessionScope.user != null 
                             && sessionScope.user.getClass().simpleName eq 'Reader'}">
                    <li class="nav-item">
                        <a class="nav-link"
                           href="${pageContext.request.contextPath}/reader/favorites">
                            Yêu thích
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link"
                           href="${pageContext.request.contextPath}/reader/borrowed">
                            Đang mượn
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link"
                           href="${pageContext.request.contextPath}/reader/borrow-requests">
                            Yêu cầu
                        </a>
                    </li>
                </c:if>
            </ul>

            <div class="d-flex align-items-center gap-2 order-lg-3 order-3 flex-nowrap">

                <c:choose>
                    <c:when test="${sessionScope.user == null}">
                        <a class="btn btn-sm btn-light"
                           href="${pageContext.request.contextPath}/login">
                            Đăng nhập
                        </a>

                        <a class="btn btn-sm btn-outline-light"
                           href="${pageContext.request.contextPath}/register">
                            Đăng ký
                        </a>
                    </c:when>

                    <c:otherwise>

                        <c:choose>

                            <c:when test="${sessionScope.user.getClass().simpleName eq 'Reader'}">
                                <div class="dropdown">
                                    <a class="btn btn-sm btn-light dropdown-toggle"
                                       href="#"
                                       data-bs-toggle="dropdown">
                                        👤 ${sessionScope.user.fullName}
                                    </a>

                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li>
                                            <a class="dropdown-item"
                                               href="${pageContext.request.contextPath}/reader/profile">
                                                Hồ sơ cá nhân
                                            </a>
                                        </li>

                                        <li>
                                            <a class="dropdown-item"
                                               href="${pageContext.request.contextPath}/reader/borrow-requests">
                                                Lịch sử yêu cầu
                                            </a>
                                        </li>

                                        <li><hr class="dropdown-divider"></li>

                                        <li>
                                            <a class="dropdown-item"
                                               href="${pageContext.request.contextPath}/change-password">
                                                Đổi mật khẩu
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
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="dropdown">
                                    <a class="btn btn-sm btn-light dropdown-toggle"
                                       href="#"
                                       data-bs-toggle="dropdown">
                                        👩‍💼 ${sessionScope.user.fullName}
                                    </a>

                                    <ul class="dropdown-menu dropdown-menu-end">

                                        <c:if test="${sessionScope.user.roleId == 2}">
                                            <li>
                                                <a class="dropdown-item"
                                                   href="${pageContext.request.contextPath}/librarian/dashboard">
                                                    Librarian Dashboard
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                        </c:if>

                                        <c:if test="${sessionScope.user.roleId == 1}">
                                            <li>
                                                <a class="dropdown-item"
                                                   href="${pageContext.request.contextPath}/admin/dashboard">
                                                    Admin Dashboard
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                        </c:if>

                                        <li>
                                            <a class="dropdown-item"
                                               href="${pageContext.request.contextPath}/change-password">
                                                Đổi mật khẩu
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
                                </div>
                            </c:otherwise>

                        </c:choose>

                    </c:otherwise>
                </c:choose>

            </div>

        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>