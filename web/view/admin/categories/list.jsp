<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Category Management</title>
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
                background-color: #f2f2f2;
            }
            a {
                margin-right: 8px;
            }
        </style>
    </head>
    <body>

        <h2>Category Management</h2>

        <a href="${pageContext.request.contextPath}/admin/categories?action=add">
            ➕ Add New Category
        </a>

        <br><br>

        <table>
            <tr>
                <th>ID</th>
                <th>Category Name</th>
                <th>Description</th>
                <th>Action</th>
            </tr>

            <c:forEach items="${categories}" var="c">
                <tr>
                    <td>${c.category_id}</td>
                    <td>${c.category_name}</td>
                    <td>${c.description}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${c.category_id}">
                            ✏ Edit
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/categories?action=delete&id=${c.category_id}"
                           onclick="return confirm('Are you sure you want to delete this category?')">
                            🗑 Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </table>

    </body>
</html>
