<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
  rel="stylesheet">

<style>
    .navbar-orange {
        background-color: #ff7a18;
    }
    .navbar-orange .nav-link,
    .navbar-orange .navbar-brand {
        color: #fff !important;
        font-weight: 500;
    }
    .navbar-orange .nav-link:hover {
        color: #ffe3cc !important;
    }
    .dropdown-menu a:hover {
        background-color: #fff0e5;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-orange shadow-sm">
    <div class="container">

        <a class="navbar-brand" href="${pageContext.request.contextPath}/reader/home">
            📚 Digital Library
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto">

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/reader/home">
                        Trang chủ
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/reader/books">
                        Danh sách sách
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/reader/categories">
                        Thể loại
                    </a>
                </li>

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

            </ul>

            <ul class="navbar-nav ms-auto">
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="#" data-bs-toggle="dropdown">
                            👤 ${sessionScope.user.fullName}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/reader/profile">
                                    Hồ sơ cá nhân
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
    </div>
</nav>
