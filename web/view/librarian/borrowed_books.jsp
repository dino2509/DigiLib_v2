<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Librarian - Borrowed Books</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <h3>📚 Quản lý sách đang cho mượn</h3>

    <div class="d-flex gap-2 mb-3">
        <a class="btn btn-sm ${filter=='borrowing'?'btn-primary':'btn-outline-primary'}"
           href="?filter=borrowing">Đang mượn</a>
        <a class="btn btn-sm ${filter=='overdue'?'btn-danger':'btn-outline-danger'}"
           href="?filter=overdue">Quá hạn</a>
        <a class="btn btn-sm ${filter=='returned'?'btn-success':'btn-outline-success'}"
           href="?filter=returned">Đã trả</a>
    </div>

    <c:if test="${param.returned eq '1'}">
        <div class="alert alert-success">Đã xác nhận trả sách (đã cập nhật Borrow_Item / BookCopy).</div>
    </c:if>
    <c:if test="${param.returnError eq '1'}">
        <div class="alert alert-danger">Không thể xác nhận trả sách (có thể sách đã trả hoặc DB chưa cập nhật bảng Return_Request).</div>
    </c:if>
    <c:if test="${param.rejected eq '1'}">
        <div class="alert alert-warning">Đã từ chối yêu cầu trả sách.</div>
    </c:if>
    <c:if test="${param.rejectError eq '1'}">
        <div class="alert alert-danger">Không thể từ chối yêu cầu trả sách (có thể request đã được xử lý).</div>
    </c:if>

    <table class="table table-bordered align-middle">
        <thead>
            <tr>
                <th>Sách</th>
                <th>Reader</th>
                <th>Copy</th>
                <th>Ngày mượn</th>
                <th>Hạn trả</th>
                <th>Trạng thái</th>
                <th>Phạt quá hạn</th>
                <th style="width: 160px;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${items}" var="it">
                <tr>
                    <td>${it.book.title}</td>
                    <td>${it.readerName}</td>
                    <td>${it.copyCode}</td>
                    <td><fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy"/></td>
                    <td><fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <span class="badge bg-${it.status=='OVERDUE'?'danger':
                                              it.status=='RETURNED'?'success':'warning'}">
                            ${it.status}
                        </span>

                        <c:if test="${it.pendingReturnRequestId != null}">
                            <span class="badge bg-info ms-1">RETURN_REQUEST</span>
                        </c:if>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${it.overdueDays > 0}">
                                <div>
                                    <span class="text-danger fw-semibold">${it.overdueDays} ngày</span>
                                </div>
                                <c:if test="${it.overdueFineAmount != null}">
                                    <div class="small text-muted">Đang ghi nhận: <fmt:formatNumber value="${it.overdueFineAmount}" type="number"/> đ</div>
                                </c:if>
                                <c:if test="${it.overdueFineAmount == null}">
                                    <div class="small text-muted">(sẽ tự tạo/ cập nhật khi vào dashboard / khi xác nhận trả)</div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">-</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${it.status=='RETURNED'}">
                                <button class="btn btn-sm btn-outline-secondary" disabled>Đã trả</button>
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex flex-column gap-2">
                                    <!-- Confirm return (will also auto-create overdue fine + optional damage fine) -->
                                    <form method="post" action="${pageContext.request.contextPath}/librarian/borrowed-books" class="m-0">
                                        <input type="hidden" name="action" value="return"/>
                                        <input type="hidden" name="filter" value="${filter}"/>
                                        <input type="hidden" name="borrowItemId" value="${it.borrowItemId}"/>
                                        <c:if test="${it.pendingReturnRequestId != null}">
                                            <input type="hidden" name="returnRequestId" value="${it.pendingReturnRequestId}"/>
                                        </c:if>

                                        <div class="input-group input-group-sm mb-1">
                                            <span class="input-group-text">Phạt hư hỏng</span>
                                            <input type="number" min="0" step="1000" class="form-control" name="damageAmount" placeholder="0"/>
                                        </div>
                                        <input type="text" class="form-control form-control-sm mb-1" name="damageReason" placeholder="Lý do (tuỳ chọn)"/>

                                        <button class="btn btn-sm btn-danger w-100" type="submit">
                                            <c:choose>
                                                <c:when test="${it.pendingReturnRequestId != null}">Duyệt trả</c:when>
                                                <c:otherwise>Trả sách</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </form>

                                    <!-- Reject pending return request -->
                                    <c:if test="${it.pendingReturnRequestId != null}">
                                        <form method="post" action="${pageContext.request.contextPath}/librarian/borrowed-books" class="m-0">
                                            <input type="hidden" name="action" value="reject"/>
                                            <input type="hidden" name="filter" value="${filter}"/>
                                            <input type="hidden" name="returnRequestId" value="${it.pendingReturnRequestId}"/>
                                            <input type="text" class="form-control form-control-sm mb-1" name="decisionNote" placeholder="Lý do từ chối (tuỳ chọn)"/>
                                            <button class="btn btn-sm btn-outline-secondary w-100" type="submit">Từ chối</button>
                                        </form>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="mt-3 small text-muted">
        <div>• Phạt quá hạn: 5000đ / 1 ngày (tính theo <b>ngày</b>, không tính theo giờ).</div>
        <div>• Khi thủ thư bấm <b>Duyệt trả / Trả sách</b>: hệ thống sẽ tự tạo/cập nhật phạt quá hạn (nếu có) và tạo phạt hư hỏng (nếu nhập số tiền).</div>
    </div>
</div>

</body>
</html>