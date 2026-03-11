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

            .submenu{
                display:none;
                background:#ff8a1f;
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

            /* MAIN */

            .main{
                margin-left:260px;
            }

            /* TOPBAR */

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

            /* CONTENT */

            .content{
                padding:30px;
            }

            /* DASHBOARD CARDS */

            .cards{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
                gap:20px;
                margin-bottom:25px;
            }

            .card{
                background:white;
                padding:20px;
                border-radius:8px;
                box-shadow:0 3px 10px rgba(0,0,0,0.05);
            }

            .card-title{
                font-size:14px;
                color:#888;
            }

            .card-value{
                font-size:26px;
                font-weight:600;
                color:#ff7a00;
                margin-top:5px;
            }

            /* TABLE */

            table{
                width:100%;
                border-collapse:collapse;
                background:white;
                border-radius:6px;
                overflow:hidden;
                box-shadow:0 2px 6px rgba(0,0,0,0.05);
            }

            th{
                background:#ff7a00;
                color:white;
                text-align:left;
                padding:12px;
            }

            td{
                padding:12px;
                border-bottom:1px solid #eee;
            }

        </style>

    </head>

    <body>

        <div class="sidebar">

            <div class="logo">
                📚 DigiLib
            </div>


            <!-- BOOK MANAGEMENT -->

            <div class="menu">

                <div class="menu-header" onclick="toggleMenu(this)">
                    <span><i class="fa-solid fa-book"></i> Book Management</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="books" class="${activeMenu=='books'?'active':''}">Books</a>
                    <a href="book-copies" class="${activeMenu=='copies'?'active':''}">Book Copies</a>
                    <a href="authors" class="${activeMenu=='authors'?'active':''}">Authors</a>
                    <a href="categories" class="${activeMenu=='categories'?'active':''}">Categories</a>

                </div>

            </div>


            <!-- BORROW -->

            <div class="menu">

                <div class="menu-header" onclick="toggleMenu(this)">
                    <span><i class="fa-solid fa-right-left"></i> Borrow</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="requests" class="${activeMenu=='borrowRequests'?'active':''}">Borrow Requests</a>
                    <a href="borrows" class="${activeMenu=='borrows'?'active':''}">Borrow Records</a>
                    <a href="borrow-extend" class="${activeMenu=='extend'?'active':''}">Extensions</a>

                </div>

            </div>


            <!-- RESERVATION -->

            <div class="menu">

                <div class="menu-header" onclick="toggleMenu(this)">
                    <span><i class="fa-solid fa-calendar"></i> Reservations</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="reservations" class="${activeMenu=='reservations'?'active':''}">
                        Reservations
                    </a>

                </div>

            </div>


            <!-- STORE -->

            <div class="menu">

                <div class="menu-header" onclick="toggleMenu(this)">
                    <span><i class="fa-solid fa-cart-shopping"></i> Ebook Store</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="orders" class="${activeMenu=='orders'?'active':''}">Orders</a>
                    <a href="payments" class="${activeMenu=='payments'?'active':''}">Payments</a>

                </div>

            </div>


            <!-- READERS -->

            <div class="menu">

                <div class="menu-header" onclick="toggleMenu(this)">
                    <span><i class="fa-solid fa-user"></i> Readers</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="readers" class="${activeMenu=='readers'?'active':''}">Readers</a>
                    <a href="reading-history" class="${activeMenu=='history'?'active':''}">Reading History</a>

                </div>

            </div>


            <!-- FINES -->

            <div class="menu">

                <div class="menu-header" onclick="toggleMenu(this)">
                    <span><i class="fa-solid fa-money-bill"></i> Fines</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="fines" class="${activeMenu=='fines'?'active':''}">Fines</a>
                    <a href="fine-types" class="${activeMenu=='fineTypes'?'active':''}">Fine Types</a>

                </div>

            </div>


            <!-- SYSTEM -->

            <div class="menu">

                <div class="menu-header" onclick="toggleMenu(this)">
                    <span><i class="fa-solid fa-gear"></i> System</span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>

                <div class="submenu">

                    <a href="notifications" class="${activeMenu=='notifications'?'active':''}">Notifications</a>
                    <a href="employees" class="${activeMenu=='employees'?'active':''}">Employees</a>

                </div>

            </div>

        </div>


        <div class="main">

            <div class="topbar">

                <div class="page-title">
                    ${pageTitle}
                </div>

                <div class="user">
                    <i class="fa-solid fa-user"></i>
                    ${sessionScope.user.fullName}
                </div>

            </div>


            <div class="content">

                <jsp:include page="${contentPage}" />

            </div>

        </div>


        <script>

            function toggleMenu(el) {

                let submenu = el.nextElementSibling;

                if (submenu.style.display === "block") {
                    submenu.style.display = "none";
                } else {
                    submenu.style.display = "block";
                }

            }

        </script>

    </body>

</html>