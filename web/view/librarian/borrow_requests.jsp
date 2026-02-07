<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Librarian - Borrow Requests</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div>
            <h3 class="mb-0">📥 Duyệt đơn mượn sách</h3>
            <div class="text-muted">Borrow_Request trạng thái PENDING.</div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/qna">Q&A</a>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">Dashboard</a>
        </div>
    </div>

    <hr/>

    <c:if test="${param.error eq 'not_enough_copies'}">
        <div class="alert alert-danger">Không đủ bản sao (BookCopy) AVAILABLE để duyệt đơn này.</div>
    </c:if>

    <div class="row g-3">
        <!-- LEFT: list -->
        <div class="col-lg-5">
            <div class="card">
                <div class="card-header fw-semibold">Danh sách đơn chờ</div>
                <div class="list-group list-group-flush">
                    <c:choose>
                        <c:when test="${empty requests}">
                            <div class="p-3 text-muted">Không có đơn nào.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${requests}" var="r">
                                <a class="list-group-item list-group-item-action"
                                   href="${pageContext.request.contextPath}/librarian/borrow-requests?requestId=${r.requestId}">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <div class="fw-semibold">#${r.requestId} • ${r.readerName}</div>
                                            <div class="small text-muted">${r.requestedAt}</div>
                                        </div>
                                        <span class="badge bg-secondary">${r.status}</span>
                                    </div>
                                    <c:if test="${not empty r.note}">
                                        <div class="small mt-2">Ghi chú: ${r.note}</div>
                                    </c:if>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- RIGHT: detail -->
        <div class="col-lg-7">
            <c:choose>
                <c:when test="${empty detail}">
                    <div class="alert alert-light border">Chọn một đơn để xem chi tiết.</div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="card-header fw-semibold">Chi tiết đơn #${detail.requestId}</div>
                        <div class="card-body">
                            <div class="mb-2"><strong>Reader:</strong> ${detail.readerName}</div>
                            <div class="mb-2"><strong>Requested:</strong> ${detail.requestedAt}</div>
                            <div class="mb-3"><strong>Ghi chú:</strong> <c:out value="${detail.note}"/></div>

                            <div class="table-responsive">
                                <table class="table table-sm align-middle">
                                    <thead>
                                    <tr>
                                        <th>Sách</th>
                                        <th style="width:120px">Số lượng</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${detail.items}" var="it">
                                        <tr>
                                            <td>${it.bookTitle}</td>
                                            <td>${it.quantity}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/librarian/borrow-requests" class="mt-3">
                                <input type="hidden" name="requestId" value="${detail.requestId}"/>
                                <label class="form-label fw-semibold">Decision note (tuỳ chọn)</label>
                                <textarea class="form-control" name="decisionNote" rows="2" placeholder="..." ></textarea>

                                <div class="d-flex gap-2 mt-3">
                                    <button class="btn btn-danger" name="action" value="approve" type="submit">Duyệt</button>
                                    <button class="btn btn-outline-danger" name="action" value="reject" type="submit">Từ chối</button>
                                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/borrow-requests">Đóng</a>
                                </div>
                            </form>

                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>
