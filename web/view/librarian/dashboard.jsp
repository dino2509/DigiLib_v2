<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Librarian Dashboard - DigiLib</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>
    <body>
        <jsp:include page="/include/common/navbar.jsp"/>

        <div class="container mt-4">
            <h3 class="mb-3">📚 Librarian Dashboard</h3>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Duyệt đơn mượn sách</h5>
                            <p class="card-text text-muted">Xem và duyệt/từ chối các Borrow_Request (PENDING).</p>
                            <a class="btn btn-danger" href="${pageContext.request.contextPath}/librarian/borrow-requests">Mở</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Trả lời hỏi đáp</h5>
                            <p class="card-text text-muted">Trả lời câu hỏi Reader gửi từ /books/detail?id=...</p>
                            <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/librarian/qna">Mở</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
