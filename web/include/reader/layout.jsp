<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

    <head>

        <meta charset="UTF-8">
        <title>${pageTitle != null ? pageTitle : "Digital Library"}</title>

        <style>

            :root{
                --primary:#ff7a00;
                --primary-dark:#e56700;
                --primary-light:#fff4ec;
                --gray:#f8fafc;
                --dark:#1e293b;
            }

            /* ===== RESET ===== */

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
            }

            body{
                font-family:'Segoe UI',sans-serif;
                background:var(--gray);
            }

            /* ===== NAVBAR ===== */

            .header{
                background:linear-gradient(90deg,#ff7a00,#ff9f43);
                color:white;
                padding:16px 40px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                box-shadow:0 4px 12px rgba(0,0,0,0.1);
            }

            .logo a{
                font-size:22px;
                font-weight:700;
                text-decoration:none;
                color:white;
            }

            .nav-links{
                display:flex;
                gap:28px;
            }

            .nav-links a{
                text-decoration:none;
                color:white;
                font-weight:500;
                opacity:0.95;
                padding-bottom:4px;
            }

            .nav-links a:hover{
                opacity:1;
                border-bottom:2px solid white;
            }

            /* NAVBAR ACTIVE */

            .nav-links a.active{
                border-bottom:2px solid white;
                opacity:1;
                font-weight:600;
            }

            /* USER */

            .user-box{
                font-weight:600;
            }

            .user-box a{
                color:white;
                text-decoration:none;
                margin-left:10px;
            }

            /* ===== MAIN LAYOUT ===== */

            .main-layout{
                display:flex;
                min-height:calc(100vh - 70px);
            }

            /* ===== SIDEBAR ===== */

            .sidebar{
                width:240px;
                background:var(--primary-light);
                border-right:2px solid #ffe0c7;
                padding:20px;
            }

            .sidebar-title{
                font-weight:700;
                margin-bottom:20px;
                color:var(--primary-dark);
                font-size:18px;
            }

            .sidebar a{
                display:block;
                padding:10px 12px;
                margin-bottom:10px;
                text-decoration:none;
                color:#333;
                border-radius:6px;
                transition:0.2s;
            }

            /* SIDEBAR HOVER */

            .sidebar a:hover{
                background:var(--primary);
                color:white;
            }

            /* SIDEBAR ACTIVE */

            .sidebar a.active{
                background:var(--primary);
                color:white;
                font-weight:600;
            }

            /* ===== CONTENT ===== */

            .content{
                flex:1;
                padding:30px;
                background:#fff;
            }

            /* ===== FOOTER ===== */

            .footer{
                background:var(--primary);
                color:white;
                text-align:center;
                padding:16px;
                font-size:14px;
            }
            .menu-group{
                margin-top:20px;
            }

            .menu-title{
                font-size:13px;
                font-weight:700;
                color:#e56700;
                margin-bottom:8px;
                text-transform:uppercase;
            }

            .menu-group a{
                padding-left:16px;
                font-size:14px;
            }

            /* menu group */

            .menu-group{
                margin-top:15px;
            }

            /* title */

            .menu-title{
                padding:10px 12px;
                font-weight:600;
                color:#e56700;
                cursor:pointer;
            }

            /* submenu hidden */

            .submenu{
                display:none;
                padding-left:10px;
            }

            /* hover show */

            .menu-group:hover .submenu{
                display:block;
            }

            /* submenu link */

            .submenu a{
                display:block;
                padding:8px 10px;
                text-decoration:none;
                color:#333;
                border-radius:5px;
                font-size:14px;
            }

            .submenu a:hover{
                background:#ff7a00;
                color:white;
            }

            /* active */

            .submenu a.active{
                background:#ff7a00;
                color:white;
            }
            /* menu group */

            .menu-group{
                margin-top:15px;
            }

            /* title */

            .menu-title{
                padding:10px 12px;
                font-weight:600;
                color:#e56700;
                cursor:pointer;
            }

            /* submenu hidden */

            .submenu{
                display:none;
                padding-left:10px;
            }

            /* hover open */

            .menu-group:hover .submenu{
                display:block;
            }

            /* active group open */

            .menu-group.open .submenu{
                display:block;
            }

            /* submenu link */

            .submenu a{
                display:block;
                padding:8px 10px;
                text-decoration:none;
                color:#333;
                border-radius:5px;
            }

            .submenu a:hover{
                background:#ff7a00;
                color:white;
            }

            /* active menu */

            .submenu a.active,
            .menu-item.active{
                background:#ff7a00;
                color:white;
            }
        </style>

    </head>

    <body>

        <!-- ===== NAVBAR ===== -->

        <div class="header">

            <div class="logo">
                <a href="${pageContext.request.contextPath}/reader/dashboard">
                    📚 Digital Library
                </a>
            </div>

            <div class="nav-links">

                <a class="${activeMenu=='home'?'active':''}"
                   href="${pageContext.request.contextPath}/reader/dashboard">
                    Trang chủ
                </a>

                <a class="${activeMenu=='books'?'active':''}"
                   href="${pageContext.request.contextPath}/reader/books">
                    Sách
                </a>

                <a class="${activeMenu=='search'?'active':''}"
                   href="${pageContext.request.contextPath}/reader/advanced-search">
                    Tìm kiếm nâng cao
                </a>

                <a class="${activeMenu=='categories'?'active':''}"
                   href="${pageContext.request.contextPath}/reader/categories">
                    Thể loại
                </a>

                <a class="${activeMenu=='about'?'active':''}"
                   href="${pageContext.request.contextPath}/reader/about">
                    Giới thiệu
                </a>

            </div>

            <div class="user-box">

                👤 ${sessionScope.user.fullName}

                <a href="${pageContext.request.contextPath}/logout">
                    Đăng xuất
                </a>

            </div>

        </div>

        <!-- ===== MAIN ===== -->

        <div class="main-layout">

            <!-- ===== SIDEBAR ===== -->

            <div class="sidebar">

                <div class="sidebar-title">
                    Reader Panel
                </div>

                <!-- Dashboard -->

                <a class="menu-item ${activeMenu=='dashboard'?'active':''}"
                   href="${pageContext.request.contextPath}/reader/dashboard">
                    🏠 Dashboard
                </a>


                <!-- Library -->

                <div class="menu-group
                     ${activeMenu=='books' || activeMenu=='categories' || activeMenu=='search' ? 'open' : ''}">

                    <div class="menu-title">
                        📚 Library
                    </div>

                    <div class="submenu">

                        <a class="${activeMenu=='books'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/books">
                            Browse Books
                        </a>

                        <a class="${activeMenu=='categories'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/categories">
                            Categories
                        </a>

                        <a class="${activeMenu=='search'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/advanced-search">
                            Advanced Search
                        </a>

                    </div>

                </div>


                <!-- Borrowing -->

                <div class="menu-group
                     ${activeMenu=='borrowed' || activeMenu=='reservations' || activeMenu=='borrow-requests'  ? 'open' : ''}">

                    <div class="menu-title">
                        📖 Borrowing
                    </div>

                    <div class="submenu">
                        <a class="${activeMenu=='borrow-requests'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/borrow-requests">
                            Borrow Request List
                        </a>

                        <a class="${activeMenu=='borrowed'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/borrowed">
                            Borrowed Books
                        </a>

                        <a class="${activeMenu=='reservations'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/reservations">
                            Reservations
                        </a>

                    </div>

                </div>


                <!-- Ebook -->

                <div class="menu-group
                     ${activeMenu=='ebooks' || activeMenu=='history' || activeMenu=='bookmarks' ? 'open' : ''}">

                    <div class="menu-title">
                        📱 Ebook
                    </div>

                    <div class="submenu">

                        <a class="${activeMenu=='ebooks'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/ebooks">
                            My Ebooks
                        </a>

                        <a class="${activeMenu=='history'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/history">
                            Reading History
                        </a>

                        <a class="${activeMenu=='bookmarks'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/bookmarks">
                            Bookmarks
                        </a>

                    </div>

                </div>


                <!-- Shopping -->

                <div class="menu-group
                     ${activeMenu=='cart' || activeMenu=='orders' ? 'open' : ''}">

                    <div class="menu-title">
                        🛒 Shopping
                    </div>

                    <div class="submenu">

                        <a class="${activeMenu=='cart'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/cart">
                            Cart
                        </a>

                        <a class="${activeMenu=='orders'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/orders">
                            Orders
                        </a>

                    </div>

                </div>


                <!-- Community -->

                <div class="menu-group
                     ${activeMenu=='reviews' ? 'open' : ''}">

                    <div class="menu-title">
                        ⭐ Community
                    </div>

                    <div class="submenu">

                        <a class="${activeMenu=='reviews'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/reviews">
                            My Reviews
                        </a>

                    </div>

                </div>


                <!-- Account -->

                <div class="menu-group
                     ${activeMenu=='profile' ? 'open' : ''}">

                    <div class="menu-title">
                        👤 Account
                    </div>

                    <div class="submenu">

                        <a class="${activeMenu=='profile'?'active':''}"
                           href="${pageContext.request.contextPath}/reader/profile">
                            Profile
                        </a>

                        <a href="${pageContext.request.contextPath}/logout">
                            Logout
                        </a>

                    </div>

                </div>

            </div>

            <!-- ===== CONTENT ===== -->

            <div class="content">

                <jsp:include page="${contentPage}" />

            </div>

        </div>

        <!-- ===== FOOTER ===== -->

        <div class="footer">
            © 2026 <b>Digital Library</b>. All rights reserved.
        </div>

    </body>
</html>