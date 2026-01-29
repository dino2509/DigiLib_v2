<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Book Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

        <style>
            .page-container {
                background: #fff7f0;
                padding: 20px;
                border-radius: 12px;
            }

            h1 {
                color: #ff6f00;
            }

            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .btn {
                padding: 8px 14px;
                border-radius: 6px;
                border: none;
                cursor: pointer;
                text-decoration: none;
                font-size: 14px;
            }

            .btn-add {
                background: #ff6f00;
                color: #fff;
            }

            .btn-edit {
                background: #ff9800;
                color: #fff;
            }

            .btn-delete {
                background: #e53935;
                color: #fff;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 10px;
                overflow: hidden;
            }

            th {
                background: #ff6f00;
                color: #fff;
                padding: 10px;
                text-align: left;
            }

            td {
                padding: 10px;
                border-bottom: 1px solid #eee;
            }

            tr:hover {
                background: #fff3e0;
            }

            .status {
                padding: 4px 8px;
                border-radius: 4px;
                font-weight: bold;
                font-size: 15px;
                color: green;
            }

            .ACTIVE {
                background: #4caf50;
            }

            .INACTIVE {
                background: #9e9e9e;
            }
        </style>
    </head>

    <body>

        <%@ include file="/include/admin/panel.jsp" %>

        <!-- ===== CONTENT ===== -->
        <div class="page-container">

            <div class="top-bar">
                <h1>📚 Quản lý sách</h1>
                <a class="btn btn-add"
                   href="${pageContext.request.contextPath}/admin/books?action=add">
                    + Thêm sách
                </a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>Giá</th>
                        <th>Danh mục</th>
                        <th>Tác giả</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="b" items="${books}">
                        <tr>
                            <td>${b.bookId}</td>
                            <td>${b.title}</td>

                            <td>
                                <c:if test="${b.price != null}">
                                    ${b.price} ${b.currency}
                                </c:if>
                            </td>

                            <td>${b.category.category_name}</td>
                            <td>${b.author.author_name}</td>

                            <td>
                                <span class="status ${b.status}">
                                    ${b.status}
                                </span>
                            </td>

                            <td>${b.createdAt}</td>

                            <td>
                                <a class="btn btn-edit"
                                   href="${pageContext.request.contextPath}/admin/books?action=edit&id=${b.bookId}">
                                    Sửa
                                </a>

                                <a class="btn btn-delete"
                                   href="${pageContext.request.contextPath}/admin/books?action=delete&id=${b.bookId}"
                                   onclick="return confirm('Bạn có chắc muốn xóa sách này?');">
                                    Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty books}">
                        <tr>
                            <td colspan="8" style="text-align:center; padding:20px;">
                                Không có sách nào
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

        </div>

        <!-- ===== ĐÓNG LAYOUT (panel.jsp mở) ===== -->
    </div> <!-- content -->
</div> <!-- main -->
</div> <!-- admin-container -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
