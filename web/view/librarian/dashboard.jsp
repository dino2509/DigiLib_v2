<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Librarian Dashboard</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>
    <body>
        <jsp:include page="/include/common/navbar.jsp"/>
        <div class="container mt-4">
            <h3>👩‍🏫 Librarian Dashboard</h3>
            <p class="text-muted">Các chức năng dành cho thủ thư.</p>

            <div class="row g-3">

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Quản lý yêu cầu mượn sách</h5>
                            <p class="card-text text-muted">Duyệt / từ chối các yêu cầu mượn sách từ độc giả.</p>
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/librarian/requests">Mở</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Quản lý sách đang cho mượn / trả sách</h5>
                            <p class="card-text text-muted">Danh sách các sách đang mượn/quá hạn/đã trả. Có thể xác nhận trả sách trực tiếp tại đây.</p>
                            <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/librarian/borrowed-books">Mở</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card border-warning">
                        <div class="card-body">
                            <h5 class="card-title">Quản lý quỹ phạt</h5>
                            <p class="card-text text-muted mb-2">
                                Theo dõi khoản phạt <b>chưa nộp</b> / <b>đã nộp</b> và tổng tiền.
                            </p>

                            <div class="d-flex flex-wrap gap-2 mb-2">
                                <span class="badge bg-danger">UNPAID: ${unpaidCount}</span>
                                <span class="badge bg-success">PAID: ${paidCount}</span>
                            </div>
                            <div class="small text-muted">
                                Tổng chưa nộp: <b><fmt:formatNumber value="${unpaidTotal}" type="number"/></b> đ
                                &nbsp;|&nbsp;
                                Tổng đã nộp: <b><fmt:formatNumber value="${paidTotal}" type="number"/></b> đ
                            </div>

                            <a class="btn btn-warning mt-3" href="${pageContext.request.contextPath}/librarian/fines">Mở</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </body>
</html>
