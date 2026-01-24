<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">

<nav class="navbar">
    <div class="navbar-left">
        <a href="${pageContext.request.contextPath}/home.jsp" class="logo">
            📚 DigiLibrary
        </a>
    </div>

    <ul class="navbar-center">
        <li><a href="${pageContext.request.contextPath}/home.jsp">Trang chủ</a></li>
        <li><a href="${pageContext.request.contextPath}/book-list.jsp">Sách</a></li>
        <li><a href="${pageContext.request.contextPath}/borrow.jsp">Mượn sách</a></li>
        <li><a href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a></li>
    </ul>

    <div class="navbar-right">
        <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
    </div>
</nav>
