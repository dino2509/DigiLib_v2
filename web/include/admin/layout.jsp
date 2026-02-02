<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>
            <c:choose>
                <c:when test="${not empty pageTitle}">
                    ${pageTitle}
                </c:when>
                <c:otherwise>
                    Admin Dashboard
                </c:otherwise>
            </c:choose>
        </title>

        <!-- CSS reset nhẹ -->
        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                background: #f3f4f6;
                font-family: Arial, sans-serif;
            }

            /* WRAPPER */
            .app-wrapper {
                display: flex;
                min-height: 100vh;
            }

            /* MAIN AREA */
            .main-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            /* CONTENT */
            .content-wrapper {
                padding: 20px;
                background: #f9fafb;
                flex: 1;
            }
        </style>
    </head>

    <body>

        <div class="app-wrapper">

            <!-- SIDEBAR / PANEL -->
            <%@ include file="/include/admin/panel.jsp" %>

            <!-- MAIN -->
            <div class="main-wrapper">

                <!-- NAVBAR / TOPBAR -->
                <%@ include file="/include/admin/navbar.jsp" %>

                <!-- CONTENT (CHỈ PHẦN NÀY THAY ĐỔI) -->
                <div class="content-wrapper">
                    <jsp:include page="${contentPage}" />
                </div>

            </div>
        </div>

    </body>
</html>
