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
            <h3 class="mb-0">📥 Quản lý yêu cầu mượn &amp; đặt trước</h3>
            <div class="text-muted">Gộp Borrow_Request và Reservation_Request theo bộ lọc.</div>
        </div>
        <div class="d-flex gap-2 flex-wrap">
            <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#createBorrowModal">
                + Tạo request mượn
            </button>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/borrowed-books">Borrowed books</a>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">Dashboard</a>
        </div>
    </div>

    <hr/>

    <c:if test="${param.error eq 'not_enough_copies'}">
        <div class="alert alert-danger">Không đủ bản sao (BookCopy) AVAILABLE để duyệt đơn này.</div>
    </c:if>

    <c:if test="${param.msg eq 'created'}">
        <div class="alert alert-success">Đã tạo Borrow Request (PENDING) từ phía librarian.</div>
    </c:if>

    <c:if test="${param.error eq 'create_failed'}">
        <div class="alert alert-danger">Tạo request thất bại. Có thể reader đã có request PENDING cho sách này.</div>
    </c:if>

    <c:if test="${param.error eq 'invalid_input'}">
        <div class="alert alert-warning">Thông tin không hợp lệ. Vui lòng chọn Reader và Book.</div>
    </c:if>

    <c:if test="${param.error eq 'out_of_stock'}">
        <div class="alert alert-danger">Đầu sách này trong kho đã hết.</div>
    </c:if>

    <c:if test="${param.error eq 'insufficient_stock'}">
        <div class="alert alert-warning">
            Số lượng sách trong kho không đủ để tạo request.
            <c:if test="${not empty param.available}">
                Hiện chỉ còn <b>${param.available}</b> copy AVAILABLE.
            </c:if>
        </div>
    </c:if>

    <c:if test="${param.msg eq 'cancelled'}">
        <div class="alert alert-success">Đã huỷ đặt trước.</div>
    </c:if>

    <div class="d-flex gap-2 flex-wrap mb-3">
        <a class="btn btn-sm ${filter eq 'all' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/librarian/borrow-requests?filter=all">Tất cả</a>
        <a class="btn btn-sm ${filter eq 'reserved' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/librarian/borrow-requests?filter=reserved">Đặt trước</a>
        <a class="btn btn-sm ${filter eq 'pending' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/librarian/borrow-requests?filter=pending">Đang chờ</a>
        <a class="btn btn-sm ${filter eq 'approved' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/librarian/borrow-requests?filter=approved">Đã duyệt</a>
        <a class="btn btn-sm ${filter eq 'rejected' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/librarian/borrow-requests?filter=rejected">Từ chối</a>
    </div>

    <div class="row g-3">
        <div class="col-lg-5">
            <div class="card">
                <div class="card-header fw-semibold">Danh sách</div>
                <div class="list-group list-group-flush">
                    <c:choose>
                        <c:when test="${empty rows}">
                            <div class="p-3 text-muted">Không có dữ liệu.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${rows}" var="r">
                                <a class="list-group-item list-group-item-action"
                                   href="${pageContext.request.contextPath}/librarian/borrow-requests?filter=${filter}&type=${r.type eq 'BORROW' ? 'borrow' : 'reservation'}&id=${r.id}">
                                    <div class="d-flex justify-content-between gap-2">
                                        <div>
                                            <div class="fw-semibold">
                                                <c:choose>
                                                    <c:when test="${r.type eq 'BORROW'}">
                                                        BR#${r.id} • ${r.readerName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        RES#${r.id} • ${r.readerName}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="small text-muted">${r.createdAt}</div>
                                            <c:if test="${r.type eq 'RESERVATION'}">
                                                <div class="small mt-1">
                                                    📚 ${r.titleSummary}
                                                    <c:if test="${r.status eq 'WAITING' && r.position != null}">
                                                        • Hàng đợi #${r.position}
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="text-end">
                                            <span class="badge ${r.type eq 'RESERVATION' ? 'bg-primary' : 'bg-secondary'}">${r.type}</span>
                                            <div class="mt-1">
                                                <span class="badge bg-dark">${r.status}</span>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <c:choose>
                <c:when test="${empty borrowDetail && empty reservationDetail}">
                    <div class="alert alert-light border">Chọn một dòng để xem chi tiết.</div>
                </c:when>

                <c:when test="${not empty borrowDetail}">
                    <div class="card">
                        <div class="card-header fw-semibold d-flex justify-content-between flex-wrap gap-2">
                            <div>Chi tiết Borrow Request #${borrowDetail.requestId}</div>
                            <span class="badge bg-secondary">${borrowDetail.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="mb-2"><strong>Reader:</strong> ${borrowDetail.readerName}</div>
                            <div class="mb-2"><strong>Requested:</strong> ${borrowDetail.requestedAt}</div>
                            <div class="mb-3"><strong>Ghi chú:</strong> <c:out value="${borrowDetail.note}"/></div>

                            <div class="table-responsive">
                                <table class="table table-sm align-middle">
                                    <thead>
                                    <tr>
                                        <th>Sách</th>
                                        <th style="width:120px">Số lượng</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${borrowDetail.items}" var="it">
                                        <tr>
                                            <td>${it.bookTitle}</td>
                                            <td>${it.quantity}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <c:choose>
                                <c:when test="${borrowDetail.status ne 'PENDING'}">
                                    <div class="alert alert-light border mb-0">Đơn đã được xử lý, không thể duyệt/từ chối nữa.</div>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/librarian/borrow-requests" class="mt-3">
                                        <input type="hidden" name="requestId" value="${borrowDetail.requestId}"/>
                                        <input type="hidden" name="filter" value="${filter}"/>

                                        <div class="row g-2">
                                            <div class="col-md-4">
                                                <label class="form-label fw-semibold">Hạn trả (ngày)</label>
                                                <input class="form-control" type="number" name="dueDays" min="7" max="14" value="14"/>
                                            </div>
                                            <div class="col-md-8">
                                                <label class="form-label fw-semibold">Decision note (tuỳ chọn)</label>
                                                <textarea class="form-control" name="decisionNote" rows="2"></textarea>
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2 mt-3">
                                            <button class="btn btn-danger" name="action" value="approve" type="submit">Duyệt</button>
                                            <button class="btn btn-outline-danger" name="action" value="reject" type="submit">Từ chối</button>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="card">
                        <div class="card-header fw-semibold d-flex justify-content-between flex-wrap gap-2">
                            <div>Chi tiết Reservation #${reservationDetail.reservationId}</div>
                            <span class="badge bg-primary">${reservationDetail.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="mb-2"><strong>Reader:</strong> ${reservationDetail.readerName}</div>
                            <div class="mb-2"><strong>Book:</strong> ${reservationDetail.bookTitle}</div>
                            <div class="mb-2"><strong>Created:</strong> ${reservationDetail.createdAt}</div>

                            <c:if test="${reservationDetail.status eq 'WAITING' && reservationDetail.position != null}">
                                <div class="mb-3"><strong>Queue position:</strong> #${reservationDetail.position}</div>
                            </c:if>

                            <c:if test="${reservationDetail.status eq 'CONVERTED' && reservationDetail.convertedRequestId != null}">
                                <div class="alert alert-success">
                                    Đã chuyển thành Borrow Request #${reservationDetail.convertedRequestId}
                                    (PENDING) để Librarian duyệt.
                                </div>
                            </c:if>

                            <c:choose>
                                <c:when test="${reservationDetail.status ne 'WAITING'}">
                                    <div class="alert alert-light border mb-0">Reservation không còn ở trạng thái WAITING nên không thể huỷ.</div>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/librarian/borrow-requests" class="mt-2">
                                        <input type="hidden" name="filter" value="${filter}"/>
                                        <input type="hidden" name="reservationId" value="${reservationDetail.reservationId}"/>
                                        <button class="btn btn-outline-danger" name="action" value="cancel_reservation" type="submit"
                                                onclick="return confirm('Huỷ đặt trước này?');">
                                            Huỷ đặt trước
                                        </button>
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

<div class="modal fade" id="createBorrowModal" tabindex="-1" aria-labelledby="createBorrowModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/librarian/borrow-requests">
                <div class="modal-header">
                    <h5 class="modal-title" id="createBorrowModalLabel">Tạo request mượn sách từ phía librarian</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="create_manual"/>
                    <input type="hidden" name="filter" value="${filter}"/>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Reader</label>
                            <select class="form-select" name="readerId" required>
                                <option value="">-- Chọn Reader --</option>
                                <c:forEach var="u" items="${readers}">
                                    <option value="${u.readerId}">#${u.readerId} • ${u.fullName} (${u.email})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Book</label>
                            <select class="form-select" name="bookId" required>
                                <option value="">-- Chọn Book --</option>
                                <c:forEach var="b" items="${books}">
                                    <option value="${b.bookId}">#${b.bookId} • ${b.title}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Quantity</label>
                            <input class="form-control" type="number" name="quantity" value="1" min="1" max="10"/>
                        </div>

                        <div class="col-md-8">
                            <label class="form-label">Note (optional)</label>
                            <input class="form-control" name="note" placeholder="Ghi chú cho request nếu có"/>
                        </div>

                        <div class="col-12">
                            <div class="alert alert-warning mb-0">
                                Request sẽ được tạo với trạng thái <b>PENDING</b>. Hệ thống sẽ kiểm tra số copy <b>AVAILABLE</b> trước khi tạo.
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Tạo request</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>