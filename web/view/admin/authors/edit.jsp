<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Author</title>

        <style>
            form {
                width: 500px;
                margin-top: 20px;
            }
            label {
                font-weight: bold;
            }
            input, textarea {
                width: 100%;
                padding: 6px;
                margin: 6px 0 12px 0;
            }
            button {
                padding: 8px 14px;
            }
            a {
                margin-left: 10px;
                text-decoration: none;
            }
        </style>
    </head>
    <body>

        <h2>Edit Author</h2>

        <form action="${pageContext.request.contextPath}/admin/authors/edit"
              method="post">

            <!-- hidden id -->
            <input type="hidden"
                   name="author_id"
                   value="${author.author_id}">

            <label for="author_name">Author Name</label>
            <input type="text"
                   id="author_name"
                   name="author_name"
                   value="${author.author_name}"
                   required>

            <label for="bio">Bio</label>
            <textarea id="bio"
                      name="bio"
                      rows="5">${author.bio}</textarea>

            <button type="submit">Update</button>
            <a href="${pageContext.request.contextPath}/admin/authors">Cancel</a>

        </form>

    </body>
</html>
