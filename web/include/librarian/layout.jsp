<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

    <head>

        <title>${pageTitle} | DigiLib</title>

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

        <style>

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:Segoe UI, Arial;
            }

            body{
                background:#f4f6f9;
            }

            /* SIDEBAR */

            .sidebar{
                width:260px;
                height:100vh;
                background:#ff7a00;
                position:fixed;
                color:white;
                overflow:auto;
            }

            .logo{
                text-align:center;
                padding:20px;
                font-size:22px;
                font-weight:bold;
                border-bottom:1px solid rgba(255,255,255,0.2);
            }

            .menu{
                position:relative;
            }

            /* submenu */

            .submenu{
                display:none;
                background:#ff8a1f;
                animation:fadeIn 0.2s ease;
            }

            /* hover mở menu */

            .menu:hover .submenu{
                display:block;
            }

            /* active menu luôn mở */

            .menu.open .submenu{
                display:block;
            }

            .menu-header{
                padding:14px 20px;
                font-size:14px;
                font-weight:600;
                cursor:pointer;
                display:flex;
                align-items:center;
                justify-content:space-between;
            }

            .menu-header:hover{
                background:#ff9433;
            }

            .menu-header i{
                margin-right:8px;
            }

            .submenu a{
                display:block;
                padding:10px 40px;
                text-decoration:none;
                color:white;
                font-size:14px;
                transition:0.2s;
            }

            .submenu a:hover{
                background:#ff9f45;
            }

            .submenu a.active{
                background:white;
                color:#ff7a00;
                font-weight:600;
            }

            /* animation */

            @keyframes fadeIn{
                from{
                    opacity:0;
                    transform:translateY(-4px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }

            /* MAIN */

            .main{
                margin-left:260px;
            }

            .topbar{
                height:60px;
                background:white;
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:0 30px;
                box-shadow:0 2px 8px rgba(0,0,0,0.08);
            }

            .page-title{
                font-size:20px;
                font-weight:600;
                color:#444;
            }

            .user{
                font-size:14px;
                color:#666;
            }

            .content{
                padding:30px;
            }

            /* USER */

            .user-box{
                display:flex;
                align-items:center;
                gap:20px;
            }

            .logout-btn{
                text-decoration:none;
                background:#ff7a00;
                color:white;
                padding:6px 12px;
                border-radius:4px;
                font-size:14px;
                transition:0.2s;
            }

            .logout-btn:hover{
                background:#e56700;
            }

            .logo-link{
                text-decoration:none;
                color:white;
                display:block;
            }

            .logo-link:hover{
                opacity:0.9;
            }
        </style>

    </head>

    <body>

        <div class="sidebar">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/librarian/dashboard" class="logo-link">
                    📚 DigiLib
                </a>
            </div>

            <!-- BOOK MANAGEMENT -->

            <div class="menu ${activeMenu=='books' || activeMenu=='copies' || activeMenu=='authors' || activeMenu=='categories' ? 'open' : ''}">

                <div class="menu-header">
                    <span><i class="fa-solid fa-book"></i> Book Management</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="${pageContext.request.contextPath}/librarian/books"
                       class="${activeMenu=='books'?'active':''}">Books</a>

                    <a href="${pageContext.request.contextPath}/librarian/book-copies"
                       class="${activeMenu=='copies'?'active':''}">Book Copies</a>

                    <a href="${pageContext.request.contextPath}/librarian/authors"
                       class="${activeMenu=='authors'?'active':''}">Authors</a>

                    <a href="${pageContext.request.contextPath}/librarian/categories"
                       class="${activeMenu=='categories'?'active':''}">Categories</a>

                </div>

            </div>

            <!-- BORROW -->

            <div class="menu ${activeMenu=='borrowRequests' || activeMenu=='borrows' || activeMenu=='extensions' ? 'open' : ''}">

                <div class="menu-header">
                    <span><i class="fa-solid fa-right-left"></i> Borrow</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="${pageContext.request.contextPath}/librarian/requests"
                       class="${activeMenu=='borrowRequests'?'active':''}">
                        Borrow Requests
                    </a>

                    <a href="${pageContext.request.contextPath}/librarian/borrows"
                       class="${activeMenu=='borrows'?'active':''}">
                        Borrow Records
                    </a>

                    <a href="${pageContext.request.contextPath}/librarian/borrow-extend"
                       class="${activeMenu=='extensions'?'active':''}">
                        Extensions
                    </a>

                </div>

            </div>

            <!-- RESERVATIONS -->

            <div class="menu ${activeMenu=='reservations' ? 'open' : ''}">

                <div class="menu-header">
                    <span><i class="fa-solid fa-calendar"></i> Reservations</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="${pageContext.request.contextPath}/librarian/reservations"
                       class="${activeMenu=='reservations'?'active':''}">
                        Reservations
                    </a>

                </div>

            </div>

            <!-- STORE -->

            <div class="menu ${activeMenu=='orders' || activeMenu=='payments' ? 'open' : ''}">

                <div class="menu-header">
                    <span><i class="fa-solid fa-cart-shopping"></i> Ebook Store</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="${pageContext.request.contextPath}/librarian/orders"
                       class="${activeMenu=='orders'?'active':''}">
                        Orders
                    </a>

                    <a href="${pageContext.request.contextPath}/librarian/payments"
                       class="${activeMenu=='payments'?'active':''}">
                        Payments
                    </a>

                </div>

            </div>

            <!-- READERS -->

            <div class="menu ${activeMenu=='readers' || activeMenu=='history' ? 'open' : ''}">

                <div class="menu-header">
                    <span><i class="fa-solid fa-user"></i> Readers</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="${pageContext.request.contextPath}/librarian/readers"
                       class="${activeMenu=='readers'?'active':''}">
                        Readers
                    </a>

                    <a href="${pageContext.request.contextPath}/librarian/reading-history"
                       class="${activeMenu=='history'?'active':''}">
                        Reading History
                    </a>

                </div>

            </div>

            <!-- FINES -->

            <div class="menu ${activeMenu=='fines' || activeMenu=='fineTypes' ? 'open' : ''}">

                <div class="menu-header">
                    <span><i class="fa-solid fa-money-bill"></i> Fines</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="${pageContext.request.contextPath}/librarian/fines"
                       class="${activeMenu=='fines'?'active':''}">
                        Fines
                    </a>

                    <a href="${pageContext.request.contextPath}/librarian/fine-types"
                       class="${activeMenu=='fineTypes'?'active':''}">
                        Fine Types
                    </a>

                </div>

            </div>

            <!-- SYSTEM -->

            <div class="menu ${activeMenu=='notifications' || activeMenu=='employees' ? 'open' : ''}">

                <div class="menu-header">
                    <span><i class="fa-solid fa-gear"></i> System</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="${pageContext.request.contextPath}/librarian/notifications"
                       class="${activeMenu=='notifications'?'active':''}">
                        Notifications
                    </a>

                    <a href="${pageContext.request.contextPath}/librarian/employees"
                       class="${activeMenu=='employees'?'active':''}">
                        Employees
                    </a>

                </div>

            </div>

        </div>


        <div class="main">

            <div class="topbar">

                <div class="page-title">
                    ${pageTitle}
                </div>

                <div class="user-box">

                    <div class="user">
                        <i class="fa-solid fa-user"></i>
                        ${sessionScope.user.fullName}
                    </div>

                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>

                </div>

            </div>

            <div class="content">

                <jsp:include page="${contentPage}" />

            </div>

        </div>

    </body>

</html>