<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>

<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");

    String displayName = "Profile";
    if (currentUser != null) {
        if (currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty()) {
            displayName = currentUser.getFullName();
        } else if (currentUser.getUsername() != null) {
            displayName = currentUser.getUsername();
        }
        displayName = displayName.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Navbar</title>

        <style>
            /* ========== RESET ========== */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
            }
            a {
                text-decoration: none;
                color: inherit;
            }

            /* ========== NAVBAR ========== */
            .dl-navbar-bar {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                height: 72px;
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 28px;
                box-shadow: 0 2px 10px rgba(0,0,0,.08);
                z-index: 1000;
            }

            .dl-navbar-spacer {
                height: 72px;
            }

            .logo {
                font-size: 22px;
                font-weight: bold;
                color: #ff6f00;
            }

            /* ========== LEFT ========== */
            .dl-left {
                display: flex;
                align-items: center;
                gap: 28px;
            }

            .search-box {
                display: flex;
                align-items: center;
                background: #f1f1f1;
                border-radius: 20px;
                padding: 6px 14px;
                width: 320px;
            }

            .search-box input {
                border: none;
                outline: none;
                background: none;
                width: 100%;
                margin-left: 8px;
            }

            /* ========== RIGHT ========== */
            .dl-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .nav-link {
                font-size: 15px;
                color: #333;
                cursor: pointer;
            }

            .btn-signup {
                background: #ff6f00;
                color: #fff;
                padding: 8px 16px;
                border-radius: 18px;
            }

            /* ========== BROWSE DROPDOWN ========== */
            .browse-dropdown {
                position: fixed;
                top: 72px;
                left: 0;
                right: 0;
                background: #fff;
                box-shadow: 0 6px 20px rgba(0,0,0,.15);
                display: none;
                z-index: 999;
            }

            .browse-content {
                max-width: 1100px;
                margin: auto;
                padding: 30px;
            }

            .topic-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 24px;
            }

            .topic-grid a {
                display: block;
                padding: 6px 0;
                color: #555;
            }

            /* ========== USER DROPDOWN ========== */
            .user-menu {
                position: relative;
            }

            .user-dropdown {
                position: absolute;
                right: 0;
                top: 130%;
                background: #fff;
                min-width: 180px;
                border-radius: 6px;
                box-shadow: 0 8px 20px rgba(0,0,0,.15);
                display: none;
            }

            .user-dropdown a,
            .user-dropdown button {
                display: block;
                width: 100%;
                padding: 10px 16px;
                border: none;
                background: none;
                text-align: left;
                font-size: 14px;
                cursor: pointer;
            }

            .user-dropdown a:hover,
            .user-dropdown button:hover {
                background: #f5f5f5;
            }
        </style>
    </head>

    <body>

        <div class="dl-navbar-spacer"></div>

        <nav class="dl-navbar-bar">
            <div class="dl-left">
                <a href="<%=ctx%>/home" class="logo">DigiLib</a>

                <form class="search-box" action="<%=ctx%>/search" method="get">
                    🔍 <input type="text" name="q" placeholder="Search books..." />
                </form>
            </div>

            <div class="dl-right">
                <a href="#" class="nav-link" id="browseToggle">Browse</a>
                <a href="<%=ctx%>/pricing" class="nav-link">Pricing</a>

                <% if (currentUser == null) { %>
                <a href="<%=ctx%>/login" class="nav-link">Login</a>
                <a href="<%=ctx%>/register" class="btn-signup">Sign up</a>
                <% } else { %>
                <div class="user-menu">
                    <a href="#" class="nav-link" id="userToggle">
                        <%=displayName%> ▾
                    </a>

                    <div class="user-dropdown" id="userDropdown">
                        <a href="<%=ctx%>/profile">Profile</a>
                        <a href="<%=ctx%>/change-password">Change Password</a>
                        <form action="<%=ctx%>/logout" method="post">
                            <button type="submit">Logout</button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
        </nav>

        <div class="browse-dropdown" id="browseDropdown">
            <div class="browse-content">
                <div class="topic-grid">
                    <a href="<%=ctx%>/browse?topic=cs">Computer Science</a>
                    <a href="<%=ctx%>/browse?topic=business">Business</a>
                    <a href="<%=ctx%>/browse?topic=law">Law</a>
                    <a href="<%=ctx%>/browse?topic=medicine">Medicine</a>
                </div>
            </div>
        </div>

        <script>
            (function () {
                const browseToggle = document.getElementById("browseToggle");
                const browseDropdown = document.getElementById("browseDropdown");
                const userToggle = document.getElementById("userToggle");
                const userDropdown = document.getElementById("userDropdown");

                if (browseToggle) {
                    browseToggle.onclick = function (e) {
                        e.preventDefault();
                        browseDropdown.style.display =
                                browseDropdown.style.display === "block" ? "none" : "block";
                    };
                }

                if (userToggle) {
                    userToggle.onclick = function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        userDropdown.style.display =
                                userDropdown.style.display === "block" ? "none" : "block";
                    };
                }

                document.addEventListener("click", function () {
                    if (browseDropdown)
                        browseDropdown.style.display = "none";
                    if (userDropdown)
                        userDropdown.style.display = "none";
                });
            })();
        </script>

    </body>
</html>
