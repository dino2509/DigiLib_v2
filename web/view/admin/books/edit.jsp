<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Cập nhật sách</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #fff7f0;
            }

            .layout {
                display: flex;
            }

            .main {
                flex: 1;
                padding: 30px;
            }

            .card {
                background: #fff;
                max-width: 850px;
                margin: auto;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            h2 {
                color: #ff6f00;
                text-align: center;
                margin-bottom: 25px;
            }

            label {
                font-weight: bold;
                color: #444;
            }

            input, textarea, select {
                width: 100%;
                padding: 10px;
                margin-top: 6px;
                margin-bottom: 16px;
                border-radius: 6px;
                border: 1px solid #ddd;
                font-size: 14px;
            }

            textarea {
                resize: vertical;
            }

            .cover-preview {
                text-align: center;
                margin-bottom: 20px;
            }

            .cover-preview img {
                max-height: 220px;
                border-radius: 6px;
                border: 1px solid #eee;
            }

            .actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 20px;
            }

            .btn {
                padding: 10px 18px;
                border-radius: 6px;
                border: none;
                cursor: pointer;
                font-size: 14px;
                text-decoration: none;
            }

            .btn-save {
                background: #ff6f00;
                color: #fff;
            }

            .btn-save:hover {
                background: #e65c00;
            }

            .btn-back {
                color: #ff6f00;
                font-weight: bold;
            }

            .btn-back:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>

        <div class="layout">

            <!-- ===== ADMIN PANEL ===== -->
            <jsp:include page="/include/admin/panel.jsp" />

            <!-- ===== MAIN CONTENT ===== -->
            <div class="main">

                <div class="card">
                    <h2>✏️ Cập nhật sách</h2>

                    <!-- PREVIEW COVER -->
                    <c:if test="${not empty book.coverUrl}">
                        <div class="cover-preview">
                            <img src="${book.coverUrl}" alt="Cover">
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/books/edit" method="post">

                        <input type="hidden" name="book_id" value="${book.bookId}">

                        <label>Tiêu đề</label>
                        <input type="text" name="title" value="${book.title}" required>

                        <label>Tóm tắt</label>
                        <textarea name="summary">${book.summary}</textarea>

                        <label>Mô tả</label>
                        <textarea name="description">${book.description}</textarea>

                        <label>Giá</label>
                        <input type="number" step="0.01" name="price" value="${book.price}">

                        <label>Đơn vị tiền</label>
                        <input type="text" name="currency" value="${book.currency}">

                        <label>Danh mục</label>
                        <select name="category_id">
                            <c:forEach items="${categories}" var="c">
                                <option value="${c.category_id}"
                                        ${c.category_id == book.category.category_id ? "selected" : ""}>
                                    ${c.category_name}
                                </option>
                            </c:forEach>
                        </select>

                        <label>Tác giả</label>
                        <select name="author_id">
                            <c:forEach items="${authors}" var="a">
                                <option value="${a.author_id}"
                                        ${a.author_id == book.author.author_id ? "selected" : ""}>
                                    ${a.author_name}
                                </option>
                            </c:forEach>
                        </select>

                        <label>Trạng thái</label>
                        <select name="status">
                            <option value="ACTIVE" ${book.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                            <option value="INACTIVE" ${book.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        </select>

                        <!-- NEW: COVER URL -->
                        <label>Cover URL</label>
                        <input type="text" name="cover_url" value="${book.coverUrl}">

                        <div class="actions">
                            <button type="submit" class="btn btn-save">💾 Cập nhật</button>
                            <a href="${pageContext.request.contextPath}/admin/books" class="btn-back">
                                ⬅ Quay lại
                            </a>
                        </div>

                    </form>
                </div>

            </div>
        </div>
    </div> <!-- content -->
</div> <!-- main -->
</div> <!-- admin-container -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
