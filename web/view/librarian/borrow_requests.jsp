<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Librarian - Requests</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .request-card{ border:1px solid rgba(0,0,0,.08); border-radius:16px; padding:16px; background:#fff; }
        .request-card + .request-card{ margin-top:16px; }
        .muted{ color:rgba(0,0,0,.6); }
    </style>
</head>
<body>
<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4 mb-5">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
        <div>
            <h3 class="mb-0">📌 Requests</h3>
            <div class="small text-muted">Gộp yêu cầu mượn sách, trả sách và gia hạn. Bộ lọc chạy trực tiếp trên trang.</div>
        </div>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/borrowed-books">Borrowed books</a>
    </div>

    <c:if test="${not empty param.msg}"><div class="alert alert-success">Thao tác đã được xử lý thành công.</div></c:if>
    <c:if test="${not empty param.error}"><div class="alert alert-danger">Không thể xử lý yêu cầu. Hãy kiểm tra điều kiện hiện tại của dữ liệu.</div></c:if>

    <div class="d-flex flex-wrap gap-2 mb-2" id="typeFilterBar">
        <button class="btn btn-sm btn-outline-dark js-type-filter" type="button" data-type="all">Tất cả</button>
        <button class="btn btn-sm btn-outline-secondary js-type-filter" type="button" data-type="borrow">Mượn sách</button>
        <button class="btn btn-sm btn-outline-info js-type-filter" type="button" data-type="return">Trả sách</button>
        <button class="btn btn-sm btn-outline-primary js-type-filter" type="button" data-type="extend">Gia hạn</button>
    </div>
    <div class="d-flex flex-wrap gap-2 mb-4" id="statusFilterBar">
        <button class="btn btn-sm btn-outline-dark js-status-filter" type="button" data-status="all">Tất cả</button>
        <button class="btn btn-sm btn-outline-warning js-status-filter" type="button" data-status="pending">Đang chờ</button>
        <button class="btn btn-sm btn-outline-success js-status-filter" type="button" data-status="approved">Phê duyệt</button>
        <button class="btn btn-sm btn-outline-danger js-status-filter" type="button" data-status="rejected">Từ chối</button>
    </div>

    <div id="requestList">
        <c:choose>
            <c:when test="${empty rows}"><div class="alert alert-light border">Không có dữ liệu.</div></c:when>
            <c:otherwise>
                <c:forEach items="${rows}" var="r">
                    <div class="request-card request-row"
                         data-type="${r.type.toLowerCase()}"
                         data-status="${r.status eq 'CONFIRMED' ? 'approved' : r.status.toLowerCase()}"
                         data-search="${r.readerName} ${r.titleSummary}">
                        <div class="d-flex justify-content-between gap-3 flex-wrap">
                            <div>
                                <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                                    <span class="badge ${r.type eq 'BORROW' ? 'bg-secondary' : (r.type eq 'RETURN' ? 'bg-info text-dark' : 'bg-primary')}">${r.type}</span>
                                    <span class="badge ${r.status eq 'PENDING' ? 'bg-warning text-dark' : (r.status eq 'APPROVED' or r.status eq 'CONFIRMED' ? 'bg-success' : 'bg-danger')}">${r.status eq 'CONFIRMED' ? 'APPROVED' : r.status}</span>
                                </div>
                                <div class="fw-semibold">
                                    <c:choose>
                                        <c:when test="${r.type eq 'BORROW'}">Borrow Request #${r.id}</c:when>
                                        <c:when test="${r.type eq 'RETURN'}">Return Request #${r.id}</c:when>
                                        <c:otherwise>Extend Request #${r.id}</c:otherwise>
                                    </c:choose>
                                    • ${r.readerName}
                                </div>
                                <div class="small muted">Tạo lúc: <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                            </div>
                            <div class="text-end small muted">
                                <c:if test="${r.borrowItemId != null}">BorrowItem ID: ${r.borrowItemId}</c:if>
                            </div>
                        </div>

                        <div class="mt-3">
                            <div><strong>Nội dung:</strong> ${r.titleSummary}</div>
                            <c:if test="${r.type eq 'EXTEND'}">
                                <div class="small mt-1">
                                    Hạn cũ: <fmt:formatDate value="${r.oldDueDate}" pattern="dd/MM/yyyy"/>
                                    • Reader xin thêm: ${r.requestedDays} ngày
                                    • Hạn reader mong muốn: <fmt:formatDate value="${r.requestedDueDate}" pattern="dd/MM/yyyy"/>
                                </div>
                            </c:if>
                            <c:if test="${r.type eq 'RETURN' and r.oldDueDate != null}"><div class="small mt-1">Hạn trả hiện tại: <fmt:formatDate value="${r.oldDueDate}" pattern="dd/MM/yyyy"/></div></c:if>
                            <c:if test="${r.type eq 'EXTEND' and r.maxAllowedDays != null}"><div class="small text-muted mt-1">Librarian có thể duyệt từ 1 đến ${r.maxAllowedDays} ngày.</div></c:if>
                            <c:if test="${r.type eq 'EXTEND' and r.approvedDueDate != null}"><div class="small text-success mt-1">Hạn mới đã duyệt: <fmt:formatDate value="${r.approvedDueDate}" pattern="dd/MM/yyyy"/></div></c:if>
                        </div>

                        <div class="mt-3">
                            <c:choose>
                                <c:when test="${r.type eq 'BORROW' and r.status eq 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/librarian/requests" class="row g-2 align-items-end">
                                        <input type="hidden" name="requestId" value="${r.id}"/>
                                        <input type="hidden" name="typeFilter" value="${typeFilter}"/>
                                        <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                        <div class="col-md-3">
                                            <label class="form-label small fw-semibold">Hạn trả (ngày)</label>
                                            <input class="form-control form-control-sm" type="number" name="dueDays" min="1" max="14" value="14"/>
                                            <div class="form-text">Cho phép chỉnh từ 1-14 ngày.</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold">Decision note</label>
                                            <input class="form-control form-control-sm" type="text" name="decisionNote"/>
                                        </div>
                                        <div class="col-md-3 d-flex gap-2">
                                            <button class="btn btn-sm btn-success" name="action" value="approve_borrow" type="submit">Duyệt</button>
                                            <button class="btn btn-sm btn-outline-danger" name="action" value="reject_borrow" type="submit">Từ chối</button>
                                        </div>
                                    </form>
                                </c:when>
                                <c:when test="${r.type eq 'RETURN' and r.status eq 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/librarian/requests" class="row g-2 align-items-end">
                                        <input type="hidden" name="returnRequestId" value="${r.id}"/>
                                        <input type="hidden" name="typeFilter" value="${typeFilter}"/>
                                        <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                        <div class="col-md-8">
                                            <label class="form-label small fw-semibold">Decision note</label>
                                            <input class="form-control form-control-sm" type="text" name="decisionNote" placeholder="Lý do từ chối (nếu có)"/>
                                        </div>
                                        <div class="col-md-4 d-flex gap-2">
                                            <button class="btn btn-sm btn-success" name="action" value="approve_return" type="submit">Duyệt trả</button>
                                            <button class="btn btn-sm btn-outline-danger" name="action" value="reject_return" type="submit">Từ chối</button>
                                        </div>
                                    </form>
                                </c:when>
                                <c:when test="${r.type eq 'EXTEND' and r.status eq 'PENDING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/librarian/requests" class="row g-2 align-items-end">
                                        <input type="hidden" name="extendId" value="${r.id}"/>
                                        <input type="hidden" name="typeFilter" value="${typeFilter}"/>
                                        <input type="hidden" name="statusFilter" value="${statusFilter}"/>
                                        <div class="col-md-3">
                                            <label class="form-label small fw-semibold">Số ngày duyệt</label>
                                            <input class="form-control form-control-sm" type="number" name="approvedDays" min="1" max="${r.maxAllowedDays}" value="1"/>
                                            <div class="form-text">Từ 1 đến ${r.maxAllowedDays} ngày.</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold">Decision note</label>
                                            <input class="form-control form-control-sm" type="text" name="decisionNote" placeholder="Ghi chú xử lý gia hạn"/>
                                        </div>
                                        <div class="col-md-3 d-flex gap-2">
                                            <button class="btn btn-sm btn-success" name="action" value="approve_extend" type="submit">Duyệt gia hạn</button>
                                            <button class="btn btn-sm btn-outline-danger" name="action" value="reject_extend" type="submit">Từ chối</button>
                                        </div>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="small muted">Yêu cầu này đã được xử lý.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
(function(){
    const typeButtons = Array.from(document.querySelectorAll('.js-type-filter'));
    const statusButtons = Array.from(document.querySelectorAll('.js-status-filter'));
    const rows = Array.from(document.querySelectorAll('.request-row'));
    let activeType = ('${typeFilter}' || 'all').toLowerCase();
    let activeStatus = ('${statusFilter}' || 'all').toLowerCase();

    function syncButtons(buttons, active, attr){
        buttons.forEach(btn => {
            btn.classList.remove('active');
            if(btn.dataset[attr] === active) btn.classList.add('active');
        });
    }

    function apply(){
        rows.forEach(row => {
            const matchType = activeType === 'all' || row.dataset.type === activeType;
            const matchStatus = activeStatus === 'all' || row.dataset.status === activeStatus;
            row.style.display = (matchType && matchStatus) ? '' : 'none';
        });
        syncButtons(typeButtons, activeType, 'type');
        syncButtons(statusButtons, activeStatus, 'status');
    }

    typeButtons.forEach(btn => btn.addEventListener('click', () => {
        activeType = btn.dataset.type;
        apply();
    }));
    statusButtons.forEach(btn => btn.addEventListener('click', () => {
        activeStatus = btn.dataset.status;
        apply();
    }));

    if(!['all','borrow','return','extend'].includes(activeType)) activeType = 'all';
    if(!['all','pending','approved','rejected'].includes(activeStatus)) activeStatus = 'all';
    apply();
})();
</script>
</body>
</html>