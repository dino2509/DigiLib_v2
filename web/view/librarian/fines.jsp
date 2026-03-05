<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Librarian - Quỹ phạt</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
        <h3 class="mb-0">💰 Quản lý quỹ phạt</h3>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">← Dashboard</a>
    </div>

    <c:if test="${param.paid eq '1'}">
        <div class="alert alert-success mt-3">Đã cập nhật: khoản phạt đã nộp.</div>
    </c:if>
    <c:if test="${param.payError eq '1'}">
        <div class="alert alert-danger mt-3">Không thể cập nhật (có thể khoản phạt đã được nộp trước đó).</div>
    </c:if>

    <div class="row mt-3 g-3">
        <div class="col-md-6">
            <div class="card border-danger">
                <div class="card-body">
                    <div class="fw-semibold">UNPAID</div>
                    <div class="display-6"><fmt:formatNumber value="${unpaidTotal}" type="number"/> đ</div>
                    <div class="text-muted">Số khoản: ${unpaidCount}</div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-success">
                <div class="card-body">
                    <div class="fw-semibold">PAID</div>
                    <div class="display-6"><fmt:formatNumber value="${paidTotal}" type="number"/> đ</div>
                    <div class="text-muted">Số khoản: ${paidCount}</div>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-4 mb-3">
        <a class="btn btn-sm ${tab=='UNPAID'?'btn-danger':'btn-outline-danger'}" href="?tab=UNPAID">Chưa nộp</a>
        <a class="btn btn-sm ${tab=='PAID'?'btn-success':'btn-outline-success'}" href="?tab=PAID">Đã nộp</a>
        <a class="btn btn-sm ${tab=='ALL'?'btn-dark':'btn-outline-dark'}" href="?tab=ALL">Tất cả</a>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th>#</th>
                <th>Reader</th>
                <th>Sách</th>
                <th>Copy</th>
                <th>Loại phạt</th>
                <th>Số tiền</th>
                <th>Lý do</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th>Ngày nộp</th>
                <th style="width: 120px;">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${fines}" var="f">
                <tr>
                    <td>${f.fineId}</td>
                    <td>${f.readerName}</td>
                    <td>${f.bookTitle}</td>
                    <td>${f.copyCode}</td>
                    <td>
                        <span class="badge bg-${f.fineTypeName=='OVERDUE'?'danger':'warning'}">${f.fineTypeName}</span>
                    </td>
                    <td class="text-end"><fmt:formatNumber value="${f.amount}" type="number"/> đ</td>
                    <td style="max-width: 320px;">
                        <div class="small">${f.reason}</div>
                    </td>
                    <td>
                        <span class="badge bg-${f.status=='PAID'?'success':'danger'}">${f.status}</span>
                    </td>
                    <td><fmt:formatDate value="${f.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td>
                        <c:if test="${f.paidAt != null}">
                            <fmt:formatDate value="${f.paidAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </c:if>
                        <c:if test="${f.paidAt == null}">-</c:if>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${f.status=='UNPAID'}">
                                <form method="post" action="${pageContext.request.contextPath}/librarian/fines" class="m-0">
                                    <input type="hidden" name="action" value="paid"/>
                                    <input type="hidden" name="fineId" value="${f.fineId}"/>
                                    <input type="hidden" name="tab" value="${tab}"/>
                                    <button class="btn btn-sm btn-success" type="submit">Đã nộp</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-sm btn-outline-secondary" disabled>OK</button>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty fines}">
                <tr>
                    <td colspan="11" class="text-center text-muted">Không có dữ liệu.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <div class="mt-3 small text-muted">
        <div>• Phạt quá hạn: 5000đ / 1 ngày (hệ thống tự cập nhật khi vào dashboard / trang quỹ phạt).</div>
        <div>• Phạt hư hỏng: thủ thư nhập số tiền lúc duyệt trả / trả sách.</div>
    </div>
</div>

</body>
</html>