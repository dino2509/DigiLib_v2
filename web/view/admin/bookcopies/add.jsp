<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Add Book Copy</title>
        <style>
            label {
                font-weight: bold;
            }
            input, select {
                width: 300px;
                padding: 6px;
                margin: 6px 0 12px 0;
            }
            button {
                padding: 6px 12px;
            }
        </style>
    </head>
    <body>

        <h2>➕ Add New Book Copy</h2>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/bookcopies/add">

            <!-- BOOK SELECT -->
            <label>Book</label><br/>
            <select name="book_id" required>
                <option value="">-- Select Book --</option>
                <c:forEach items="${books}" var="b">
                    <option value="${b.bookId}">
                        ${b.title}
                    </option>
                </c:forEach>
            </select>
            <br/>

            <!-- COPY CODE -->
            <label>Copy Code</label><br/>
            <input type="text" name="copy_code" required
                   placeholder="VD: BK-001"/>
            <br/>

            <!-- STATUS -->
            <label>Status</label><br/>
            <select name="status">
                <option value="AVAILABLE">AVAILABLE</option>
                <option value="INACTIVE">INACTIVE</option>
            </select>
            <br/>

            <!-- ACTIONS -->
            <button type="submit">Create</button>
            <a href="${pageContext.request.contextPath}/admin/bookcopies/list">
                Cancel
            </a>
        </form>

    </body>
</html>
