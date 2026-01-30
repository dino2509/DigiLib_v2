<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Employee" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    ArrayList<Employee> employees =
            (ArrayList<Employee>) request.getAttribute("employees");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Employee Management</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
            }
            th {
                background-color: #f5f5f5;
            }
            .action a {
                margin-right: 8px;
                text-decoration: none;
            }
        </style>
    </head>
    <body>

        <h2>Employee List</h2>

        <a href="${pageContext.request.contextPath}/admin/employees?action=add">
            ➕ Add Employee
        </a>

        <br><br>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Role ID</th>
                    <th>Created At</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${employees}" var="e" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td>${e.fullName}</td>
                        <td>${e.email}</td>
                        <td>${e.status}</td>

                        <td>
                            <c:forEach items="${roles}" var="r">
                                <c:if test="${r.roleId == e.roleId}">
                                    ${r.roleName}
                                </c:if>
                            </c:forEach>
                        </td>

                        <td>${e.createdAt}</td>

                        <td class="action">
                            <a href="${pageContext.request.contextPath}/admin/employees?action=edit&id=${e.employeeId}">
                                ✏ Edit
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/employees?action=delete&id=${e.employeeId}"
                               onclick="return confirm('Are you sure?');">
                                🗑 Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>

            </tbody>
        </table>

    </body>
</html>
