<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Reader" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    ArrayList<Reader> readers =
        (ArrayList<Reader>) request.getAttribute("readers");
%>

<h2>Promote Reader to Employee</h2>

<form action="${pageContext.request.contextPath}/admin/employees/add" method="post">

    <!-- CHỌN READER -->
    <label>Reader</label>
    <select id="readerSelect" name="reader_id" required onchange="fillReaderInfo()">
        <option value="">-- Select Reader --</option>
        <% for (Reader r : readers) { %>
        <option value="<%= r.getReaderId() %>"
                data-name="<%= r.getFullName() %>"
                data-email="<%= r.getEmail() %>"
                data-phone="<%= r.getPhone() %>"

                data-status="<%= r.getStatus() %>">
            <%= r.getFullName() %> - <%= r.getEmail() %>
        </option>
        <% } %>
    </select>

    <hr>

    <!-- FULL NAME (EDITABLE) -->
    <label>Full Name</label>
    <input type="text" id="fullName" name="full_name" required>

    <!-- EMAIL -->
    <label>Email</label>
    <input type="text" id="email" readonly>

    <!-- PHONE -->
    <label>Phone</label>
    <input type="text" id="phone" readonly>

    <!--     AVATAR 
        <label>Avatar URL</label>
        <input type="text" id="avatar" readonly>-->

    <!-- STATUS -->
    <label>Status</label>
    <input type="text" id="status" readonly>

    <!-- ROLE (EDITABLE) -->
    <label>Role</label>
    <select name="role_id" required>

        <c:forEach items="${roles}" var="r">
            <c:if test="${r.roleId ne 3}">
                <option value="${r.roleId}">
                    ${r.roleName}
                </option>
            </c:if>
        </c:forEach>


        <!--        <option value="1">Admin</option>
                <option value="2">Librarian</option>
                <option value="3">Staff</option>-->

    </select>

    <br><br>

    <button type="submit">Promote</button>
    <a href="${pageContext.request.contextPath}/admin/employees">Cancel</a>
</form>

<!-- JS -->
<script>
    function fillReaderInfo() {
        const select = document.getElementById("readerSelect");
        const opt = select.options[select.selectedIndex];

        if (!opt.value)
            return;

        document.getElementById("fullName").value = opt.dataset.name;
        document.getElementById("email").value = opt.dataset.email;
        document.getElementById("phone").value = opt.dataset.phone;
//        document.getElementById("avatar").value = opt.dataset.avatar;
        document.getElementById("status").value = opt.dataset.status;

    }
</script>
