<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h2>Danh sách Role</h2>

<table border="1" cellpadding="8">
    <thead>
        <tr>
            <th>ID</th>
            <th>Role Name</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${roles}" var="r">
            <tr>
                <td>${r.roleId}</td>
                <td>${r.roleName}</td>
                <td>${r.description}</td>
            </tr>
        </c:forEach>
    </tbody>
   

</table>
