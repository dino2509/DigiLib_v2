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
        <div class="d-flex gap-2">
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/borrowed-books">Borrowed books</a>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/qna">Q&amp;A</a>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">Dashboard</a>
        </div>
    </div>

    <hr/>

    <c:if test="${param.error eq 'not_enough_copies'}">
        <div class="alert alert-danger">Không đủ bản sao (BookCopy) AVAILABLE để duyệt đơn này.</div>
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

</body>
</html>