<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Librarian - Return Requests</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .mini-cover { width: 56px; height: 72px; object-fit: cover; border-radius: 6px; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div>
            <h3 class="mb-0">📤 Quản lý request trả sách</h3>
            <div class="text-muted">Return_Request: xác nhận đã nhận được sách hoặc từ chối khi chưa nhận.</div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/borrowed-books">Borrowed books</a>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/borrow-requests">Borrow requests</a>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">Dashboard</a>
        </div>
    </div>

    <hr/>

    <c:if test="${param.created eq '1'}">
        <div class="alert alert-success">Đã tạo request trả sách và tự động xác nhận (librarian tạo).</div>
    </c:if>
    <c:if test="${param.createError eq '1'}">
        <div class="alert alert-danger">Không thể tạo request trả sách (BorrowItem không tồn tại/đã trả hoặc đã có request PENDING).</div>
    </c:if>

    <div class="row g-3">
        <!-- LEFT -->
        <div class="col-lg-5">
            <div class="card mb-3">
                <div class="card-header fw-semibold">Tạo nhanh (reader trả trực tiếp)</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/librarian/return-requests" class="row g-2">
                        <input type="hidden" name="action" value="create_auto"/>
                        <input type="hidden" name="filter" value="${filter}"/>
                        <div class="col-12">
                            <label class="form-label">BorrowItem ID</label>
                            <input class="form-control" type="number" name="borrowItemId" min="1" placeholder="Ví dụ: 123" required/>
                            <div class="small text-muted">Librarian tạo thì đơn sẽ auto CONFIRMED, hệ thống cập nhật returned_at + BookCopy AVAILABLE.</div>
                        </div>
                        <div class="col-12">
                            <button class="btn btn-danger" type="submit">Tạo & xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header d-flex align-items-center justify-content-between gap-2">
                    <div class="fw-semibold">Danh sách request</div>
                    <div class="d-flex gap-1 flex-wrap">
                        <a class="btn btn-sm ${filter eq 'pending' ? 'btn-danger' : 'btn-outline-danger'}"
                           href="${pageContext.request.contextPath}/librarian/return-requests?filter=pending">Đang chờ</a>
                        <a class="btn btn-sm ${filter eq 'confirmed' ? 'btn-danger' : 'btn-outline-danger'}"
                           href="${pageContext.request.contextPath}/librarian/return-requests?filter=confirmed">Đã nhận</a>
                        <a class="btn btn-sm ${filter eq 'rejected' ? 'btn-danger' : 'btn-outline-danger'}"
                           href="${pageContext.request.contextPath}/librarian/return-requests?filter=rejected">Từ chối</a>
                        <a class="btn btn-sm ${filter eq 'all' ? 'btn-danger' : 'btn-outline-danger'}"
                           href="${pageContext.request.contextPath}/librarian/return-requests?filter=all">Tất cả</a>
                    </div>
                </div>

                <div class="list-group list-group-flush">
                    <c:choose>
                        <c:when test="${empty requests}">
                            <div class="p-3 text-muted">Không có request nào.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${requests}" var="r">
                                <a class="list-group-item list-group-item-action"
                                   href="${pageContext.request.contextPath}/librarian/return-requests?filter=${filter}&requestId=${r.returnRequestId}">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <div class="fw-semibold">#${r.returnRequestId} • ${r.readerName}</div>
                                            <div class="small text-muted">${r.createdAt} • ${r.createdByType}</div>
                                        </div>
                                        <span class="badge bg-secondary">${r.status}</span>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- RIGHT -->
        <div class="col-lg-7">
            <c:choose>
                <c:when test="${empty detail}">
                    <div class="alert alert-light border">Chọn một request để xem chi tiết.</div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="card-header fw-semibold d-flex align-items-center justify-content-between flex-wrap gap-2">
                            <div>Chi tiết request #${detail.returnRequestId}</div>
                            <span class="badge bg-secondary">${detail.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="mb-2"><strong>Reader:</strong> ${detail.readerName}</div>
                            <div class="mb-2"><strong>Created at:</strong> ${detail.createdAt}</div>
                            <div class="mb-2"><strong>Created by:</strong> ${detail.createdByType}
                                <c:if test="${detail.createdByType eq 'LIBRARIAN'}">
                                    (${detail.createdByEmployeeName})
                                </c:if>
                            </div>

                            <c:if test="${detail.confirmedAt != null}">
                                <div class="mb-2"><strong>Processed at:</strong> ${detail.confirmedAt}</div>
                                <div class="mb-2"><strong>Processed by:</strong> ${detail.confirmedByEmployeeName}</div>
                            </c:if>

                            <c:if test="${not empty detail.note}">
                                <div class="mb-3"><strong>Note:</strong> <c:out value="${detail.note}"/></div>
                            </c:if>

                            <c:if test="${not empty detail.items}">
                                <c:set var="it" value="${detail.items[0]}"/>
                                <div class="d-flex align-items-center gap-3 border rounded p-3">
                                    <img class="mini-cover"
                                         src="${pageContext.request.contextPath}/img/book/${empty it.book.coverUrl ? 'no-cover.png' : it.book.coverUrl}"
                                         alt="${it.book.title}">
                                    <div class="flex-grow-1">
                                        <div class="fw-semibold">${it.book.title}</div>
                                        <div class="small text-muted">Copy: ${it.copyCode} • Borrow ID: ${it.borrowId} • BorrowItem ID: ${it.borrowItemId}</div>
                                        <div class="small">
                                            Borrow: <fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy"/>
                                            • Due: <fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/>
                                            <c:if test="${it.returnedAt != null}">
                                                • Returned: <fmt:formatDate value="${it.returnedAt}" pattern="dd/MM/yyyy"/>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <hr/>

                            <c:choose>
                                <c:when test="${detail.status ne 'PENDING'}">
                                    <div class="alert alert-light border mb-0">Request này đã được xử lý, không thể confirm/reject nữa.</div>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/librarian/return-requests" class="mt-2">
                                        <input type="hidden" name="requestId" value="${detail.returnRequestId}"/>
                                        <input type="hidden" name="filter" value="${filter}"/>

                                        <div class="mb-2">
                                            <label class="form-label fw-semibold">Note khi từ chối (tuỳ chọn)</label>
                                            <textarea class="form-control" name="note" rows="2" placeholder="Ví dụ: Chưa nhận được sách..."></textarea>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button class="btn btn-danger" type="submit" name="action" value="confirm">Xác nhận đã nhận sách</button>
                                            <button class="btn btn-outline-danger" type="submit" name="action" value="reject">Từ chối</button>
                                            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/return-requests?filter=${filter}">Đóng</a>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>