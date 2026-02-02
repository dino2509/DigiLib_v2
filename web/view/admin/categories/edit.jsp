<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Category</title>
        <style>
            form {
                width: 400px;
            }
            label {
                font-weight: bold;
            }
            input, textarea {
                width: 100%;
                padding: 6px;
                margin-top: 4px;
            }
            button {
                margin-top: 10px;
                padding: 6px 12px;
            }
        </style>
    </head>
    <body>

        <h2>Edit Category</h2>

    <c:if test="${category == null}">
        <p style="color:red;">Category not found!</p>
    </c:if>

    <c:if test="${category != null}">
        <form action="${pageContext.request.contextPath}/admin/categories/edit"
              method="post">

            <!-- Hidden ID -->
            <input type="hidden"
                   name="category_id"
                   value="${category.category_id}">

            <label>Category Name</label>
            <input type="text"
                   name="category_name"
                   value="${category.category_name}"
                   required>

            <label>Description</label>
            <textarea name="description"
                      rows="4">${category.description}</textarea>

            <button type="submit">Update</button>
            <a href="${pageContext.request.contextPath}/admin/categories/list">
                Cancel
            </a>
        </form>
    </c:if>

</body>
</html>
