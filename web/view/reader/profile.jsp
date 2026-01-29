<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Reader" %>

<%
    Reader reader = (Reader) session.getAttribute("user");
    if (reader == null) {
        response.sendRedirect("../login");
        return;
    }
%>


<jsp:include page="/include/reader/header.jsp"/>
<link rel="stylesheet" 
      href="${pageContext.request.contextPath}/css/reader.css">
<div class="profile-wrapper">

    <div class="profile-card">

        <!-- AVATAR + NAME -->
        <div class="profile-header">
            <img 
                src="<%= reader.getAvatar() != null ? reader.getAvatar() : "../images/default-avatar.png" %>"
                class="avatar"
                alt="Avatar"
            >
            <h2><%= reader.getFullName() %></h2>
            <span class="role-badge">Reader</span>
        </div>

        <!-- INFO -->
        <div class="profile-body">

            <div class="info-row">
                <span class="label">📧 Email</span>
                <span class="value"><%= reader.getEmail() %></span>
            </div>

            <div class="info-row">
                <span class="label">📞 Phone</span>
                <span class="value">
                    <%= reader.getPhone() != null ? reader.getPhone() : "Not updated" %>
                </span>
            </div>

            <div class="info-row">
                <span class="label">📌 Status</span>
                <span class="value status"><%= reader.getStatus() %></span>
            </div>

            <div class="info-row">
                <span class="label">📅 Member Since</span>
                <span class="value"><%= reader.getCreatedAt() %></span>
            </div>

        </div>

    </div>
</div>

<jsp:include page="/include/reader/footer.jsp"/>
