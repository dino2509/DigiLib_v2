<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Book Copy</title>
        <style>
            label {
                font-weight: bold;
            }
            input, select {
                width: 320px;
                padding: 6px;
                margin: 6px 0 14px 0;
            }
            input[readonly] {
                background-color: #f2f2f2;
            }
            button {
                padding: 6px 12px;
            }
            .note {
                font-size: 13px;
                color: #666;
            }
        </style>
    </head>
    <body>

        <h2>✏ Edit Book Copy</h2>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/bookcopies/edit">

            <!-- hidden id -->
            <input type="hidden" name="copy_id" value="${bookCopy.copyId}" />

            <!-- Book ID (readonly) -->
            <label>Book ID</label><br/>
            <input type="text" value="${bookCopy.bookId}" readonly />
            <div class="note">Book không thể thay đổi</div>

            <!-- Copy Code -->
            <label>Copy Code</label><br/>
            <input type="text"
                   name="copy_code"
                   value="${bookCopy.copyCode}"
                   required />

            <!-- Status -->
            <label>Status</label><br/>
            <select name="status"
                    <c:if test="${bookCopy.status eq 'BORROWED'}">disabled</c:if>>

                <option value="AVAILABLE"
                        <c:if test="${bookCopy.status eq 'AVAILABLE'}">selected</c:if>>
                    AVAILABLE
                </option>

                <option value="BORROWED"
                        <c:if test="${bookCopy.status eq 'BORROWED'}">selected</c:if>>
                    BORROWED
                </option>

                <option value="DAMAGED"
                        <c:if test="${bookCopy.status eq 'DAMAGED'}">selected</c:if>>
                    DAMAGED
                </option>

                <option value="LOST"
                        <c:if test="${bookCopy.status eq 'LOST'}">selected</c:if>>
                    LOST
                </option>

                <option value="INACTIVE"
                        <c:if test="${bookCopy.status eq 'INACTIVE'}">selected</c:if>>
                    INACTIVE
                </option>
            </select>

            <c:if test="${bookCopy.status eq 'BORROWED'}">
                <div class="note">
                    Không thể thay đổi trạng thái khi sách đang được mượn
                </div>
            </c:if>

            <br/>

            <!-- Actions -->
            <button type="submit">Update</button>
            <a href="${pageContext.request.contextPath}/admin/bookcopies/list">
                Cancel
            </a>

        </form>

    </body>
</html>
