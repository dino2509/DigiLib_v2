<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Danh Sách Đang Mượn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <a href="dashboard" class="btn btn-secondary mb-3">
        &larr; Quay lại Dashboard
    </a>

    <div class="card shadow">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0">Danh Sách Sách Đang Được Mượn</h4>
            <span class="badge bg-light text-dark">Tổng: ${borrowList.size()}</span>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Mã Bản Sao</th>
                        <th>Tên Sách</th>
                        <th>Người Mượn</th>
                        <th>Ngày Mượn</th>
                        <th>Hạn Trả</th>
                        <th>Trạng Thái</th>                    
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${borrowList}" var="b">
                        <tr>
                            <td><strong>${b.copyCode}</strong></td>
                            <td>${b.bookTitle}</td>
                            <td>${b.readerName}</td>
                            <td>${b.borrowedDate}</td>
                            
                            <td style="${b.status == 'overdue' ? 'color:red; font-weight:bold' : ''}">
                                ${b.dueDate}
                            </td>
                            
                            <td>
                                <span class="badge ${b.status == 'overdue' ? 'bg-danger' : 'bg-success'}">
                                    ${b.status == 'overdue' ? 'Quá Hạn' : 'Đang Mượn'}
                                </span>
                            </td>                         
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty borrowList}">
                <div class="alert alert-info text-center">
                    Hiện không có cuốn sách nào đang được mượn.
                </div>
            </c:if>
        </div>
    </div>
</div>

</body>
</html>
