<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Add Category</title>
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

        <h2>Add New Category</h2>

        <form action="${pageContext.request.contextPath}/admin/categories/add"
              method="post">

            <label>Category Name</label>
            <input type="text"
                   name="category_name"
                   required>

            <label>Description</label>
            <textarea name="description" rows="4"></textarea>

            <button type="submit">Create</button>
            <a href="${pageContext.request.contextPath}/admin/categories/list">
                Cancel
            </a>
        </form>

    </body>
</html>
