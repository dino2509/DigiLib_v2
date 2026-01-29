<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Add Book</title>
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
            background: #ffffff;
            max-width: 800px;
            margin: auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        h2 {
            color: #ff6f00;
            margin-bottom: 25px;
            text-align: center;
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

        .actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
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

    <!-- ===== SIDEBAR ADMIN ===== -->
    <jsp:include page="/include/admin/panel.jsp" />

    <!-- ===== MAIN CONTENT ===== -->
    <div class="main">

        <div class="card">
            <h2>➕ Thêm sách mới</h2>

            <form action="books?action=add" method="post">

                <label>Tiêu đề</label>
                <input type="text" name="title" required>

                <label>Tóm tắt</label>
                <textarea name="summary" rows="3"></textarea>

                <label>Mô tả</label>
                <textarea name="description" rows="4"></textarea>

                <label>Giá</label>
                <input type="number" step="0.01" name="price">

                <label>Đơn vị tiền</label>
                <input type="text" name="currency" value="VND">

                <label>Danh mục</label>
                <select name="category_id" required>
                    <c:forEach items="${categories}" var="c">
                        <option value="${c.category_id}">
                            ${c.category_name}
                        </option>
                    </c:forEach>
                </select>

                <label>Tác giả</label>
                <select name="author_id" required>
                    <c:forEach items="${authors}" var="a">
                        <option value="${a.author_id}">
                            ${a.author_name}
                        </option>
                    </c:forEach>
                </select>

                <label>Trạng thái</label>
                <select name="status">
                    <option value="ACTIVE">ACTIVE</option>
                    <option value="INACTIVE">INACTIVE</option>
                </select>

                <label>Cover URL</label>
                <input type="text" name="cover_url">

                <label>Content Path</label>
                <input type="text" name="content_path">

                <div class="actions">
                    <button type="submit" class="btn btn-save">💾 Lưu</button>
                    <a href="books" class="btn-back">⬅ Quay lại</a>
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
