<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Book Copy Management</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: center;
            }
            th {
                background-color: #f2f2f2;
            }
            .btn {
                padding: 4px 8px;
                text-decoration: none;
                border: 1px solid #333;
                border-radius: 4px;
                margin: 0 2px;
            }
            .btn-edit {
                background: #e3f2fd;
            }
            .btn-delete {
                background: #ffebee;
            }
            .status-AVAILABLE {
                color: green;
                font-weight: bold;
            }
            .status-BORROWED {
                color: orange;
                font-weight: bold;
            }
            .status-LOST {
                color: red;
                font-weight: bold;
            }
            .status-DAMAGED {
                color: brown;
                font-weight: bold;
            }
            .status-INACTIVE {
                color: gray;
            }
        </style>
    </head>
    <body>

        <h2>📚 Book Copy List</h2>

        <!-- Filter theo book_id -->
        <form method="get" action="${pageContext.request.contextPath}/admin/bookcopies/list">
            Filter by Book ID:
            <input type="number" name="book_id" value="${bookId}" />
            <button type="submit">Filter</button>
            <a href="${pageContext.request.contextPath}/admin/bookcopies/list">Clear</a>
        </form>

        <br/>

        <a class="btn" href="${pageContext.request.contextPath}/admin/bookcopies?action=add">
            ➕ Add New Book Copy
        </a>

        <br/><br/>

        <table>
            <tr>
                <th>ID</th>
                <th>Book ID</th>
                <th>Copy Code</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>

            <c:forEach items="${bookCopies}" var="c">
                <tr>
                    <td>${c.copyId}</td>
                    <td>${c.bookId}</td>
                    <td>${c.copyCode}</td>
                    <td class="status-${c.status}">
                        ${c.status}
                    </td>
                    <td>${c.createdAt}</td>
                    <td>
                        <!-- Edit -->
                        <a class="btn btn-edit"
                           href="${pageContext.request.contextPath}/admin/bookcopies?action=edit&id=${c.copyId}">
                            ✏ Edit
                        </a>

                        <!-- Soft delete -->
                <c:if test="${c.status ne 'BORROWED'}">
                    <a class="btn btn-delete"
                       href="${pageContext.request.contextPath}/admin/bookcopies?action=delete&id=${c.copyId}"
                       onclick="return confirm('Deactivate this book copy?');">
                        ❌ Deactivate
                    </a>
                </c:if>

                <c:if test="${c.status eq 'BORROWED'}">
                    <span style="color: gray;">(Borrowed)</span>
                </c:if>
                </td>
                </tr>
            </c:forEach>

            <c:if test="${empty bookCopies}">
                <tr>
                    <td colspan="6">No book copies found.</td>
                </tr>
            </c:if>
        </table>

    </body>
</html>
