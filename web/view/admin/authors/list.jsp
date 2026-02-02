<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Author Management</title>

        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 16px;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
            }
            th {
                background-color: #f2f2f2;
            }
            a.button {
                padding: 6px 10px;
                background: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 4px;
            }
            a.button.delete {
                background: #dc3545;
            }
        </style>
    </head>
    <body>

        <h2>Author Management</h2>

        <a class="button"
           href="${pageContext.request.contextPath}/admin/authors?action=add">
            + Add New Author
        </a>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Author Name</th>
                    <th>Bio</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${authors}" var="a">
                    <tr>
                        <td>${a.author_id}</td>
                        <td>${a.author_name}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty a.bio}">
                                    ${a.bio}
                                </c:when>
                                <c:otherwise>
                                    <i>No bio</i>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a class="button"
                               href="${pageContext.request.contextPath}/admin/authors?action=edit&id=${a.author_id}">
                                Edit
                            </a>

                            <a class="button delete"
                               href="${pageContext.request.contextPath}/admin/authors?action=delete&id=${a.author_id}"
                               onclick="return confirm('Are you sure you want to delete this author?')">
                                Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty authors}">
                    <tr>
                        <td colspan="4" style="text-align:center">
                            No authors found.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

    </body>
</html>
