<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Employee</title>
        <style>
            label {
                display: block;
                margin-top: 10px;
                font-weight: bold;
            }
            input, select {
                width: 300px;
                padding: 6px;
            }
            input[readonly] {
                background-color: #f3f3f3;
            }
            button {
                margin-top: 15px;
            }
        </style>
    </head>
    <body>

        <h2>Edit Employee</h2>

        <form action="${pageContext.request.contextPath}/admin/employees/edit" method="post"
              action="${pageContext.request.contextPath}/admin/employees/update">

            <!-- ID -->
            <input type="hidden" name="employee_id"
                   value="${employee.employeeId}"/>

            <!-- FULL NAME (EDITABLE) -->
            <label>Full Name</label>
            <input type="text" name="full_name"
                   value="${employee.fullName}" required/>

            <!-- EMAIL (READONLY) -->
            <label>Email</label>
            <input type="text"
                   value="${employee.email}" readonly/>

            <!-- ROLE (EDITABLE) -->
            <label>Role</label>
            <select name="role_id" required>
                <c:forEach items="${roles}" var="r">
                    <c:if test="${r.roleId ne 3}">
                        
                        <option <c:if test="${employee.roleId eq r.roleId}"> selected="" </c:if> value="${r.roleId}">
                            ${r.roleName}
                        </option>
                    </c:if>
                </c:forEach>
            </select>

            <!-- STATUS (EDITABLE) -->
            <label>Status</label>
            <select name="status">
                <option value="active"
                        ${employee.status == 'active' ? 'selected' : ''}>
                    Active
                </option>
                <option value="inactive"
                        ${employee.status == 'inactive' ? 'selected' : ''}>
                    Inactive
                </option>
            </select>

            <br>

            <button type="submit">Update</button>
            <a href="${pageContext.request.contextPath}/admin/employees">
                Cancel
            </a>

        </form>

    </body>
</html>
