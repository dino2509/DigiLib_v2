<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Reader - Borrow Requests</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div>
            <h3 class="mb-0">📩 Lịch sử yêu cầu mượn &amp; đặt trước</h3>
            <div class="text-muted">Gộp Borrow_Request và Reservation_Request.</div>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/reader/home">Reader Home</a>
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/reader/borrowed">Đang mượn</a>
        </div>
    </div>

    <hr/>

    <c:if test="${param.msg eq 'cancelled'}">
        <div class="alert alert-success">Đã huỷ đặt trước.</div>
    </c:if>

    <div class="d-flex gap-2 flex-wrap mb-3">
        <a class="btn btn-sm ${filter eq 'all' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/reader/borrow-requests?filter=all">Tất cả</a>
        <a class="btn btn-sm ${filter eq 'reserved' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/reader/borrow-requests?filter=reserved">Đặt trước</a>
        <a class="btn btn-sm ${filter eq 'pending' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/reader/borrow-requests?filter=pending">Đang chờ</a>
        <a class="btn btn-sm ${filter eq 'approved' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/reader/borrow-requests?filter=approved">Đã duyệt</a>
        <a class="btn btn-sm ${filter eq 'rejected' ? 'btn-danger' : 'btn-outline-danger'}"
           href="${pageContext.request.contextPath}/reader/borrow-requests?filter=rejected">Từ chối</a>
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
                                   href="${pageContext.request.contextPath}/reader/borrow-requests?filter=${filter}&type=${r.type eq 'BORROW' ? 'borrow' : 'reservation'}&id=${r.id}">
                                    <div class="d-flex justify-content-between gap-2">
                                        <div>
                                            <div class="fw-semibold">
                                                <c:choose>
                                                    <c:when test="${r.type eq 'BORROW'}">BR#${r.id}</c:when>
                                                    <c:otherwise>RES#${r.id}</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="small text-muted">${r.createdAt}</div>

                                            <c:choose>
                                                <c:when test="${r.type eq 'BORROW'}">
                                                    <div class="small mt-1">📚 ${r.titleSummary}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="small mt-1">📚 ${r.titleSummary}
                                                        <c:if test="${r.status eq 'WAITING' && r.position != null}">
                                                            • Hàng đợi #${r.position}
                                                        </c:if>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-end">
                                            <span class="badge ${r.type eq 'RESERVATION' ? 'bg-primary' : 'bg-secondary'}">${r.type}</span>
                                            <div class="mt-1"><span class="badge bg-dark">${r.status}</span></div>
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
                            <div>Borrow Request #${borrowDetail.requestId}</div>
                            <span class="badge bg-secondary">${borrowDetail.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="mb-2"><strong>Requested:</strong> ${borrowDetail.requestedAt}</div>
                            <c:if test="${not empty borrowDetail.note}">
                                <div class="mb-2"><strong>Ghi chú:</strong> <c:out value="${borrowDetail.note}"/></div>
                            </c:if>

                            <div class="table-responsive">
                                <table class="table table-sm align-middle">
                                    <thead>
                                    <tr>
                                        <th>Sách</th>
                                        <th style="width:120px">Số lượng</th>
                                        <th style="width:120px"></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${borrowDetail.items}" var="it">
                                        <tr>
                                            <td>${it.bookTitle}</td>
                                            <td>${it.quantity}</td>
                                            <td>
                                                <a class="btn btn-sm btn-outline-secondary"
                                                   href="${pageContext.request.contextPath}/books/detail?id=${it.bookId}">Xem</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <c:if test="${borrowDetail.status ne 'PENDING' && not empty borrowDetail.decisionNote}">
                                <div class="alert alert-light border mb-0">
                                    <strong>Decision note:</strong> <c:out value="${borrowDetail.decisionNote}"/>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="card">
                        <div class="card-header fw-semibold d-flex justify-content-between flex-wrap gap-2">
                            <div>Reservation #${reservationDetail.reservationId}</div>
                            <span class="badge bg-primary">${reservationDetail.status}</span>
                        </div>
                        <div class="card-body">
                            <div class="mb-2"><strong>Book:</strong> ${reservationDetail.bookTitle}</div>
                            <div class="mb-2"><strong>Created:</strong> ${reservationDetail.createdAt}</div>

                            <c:if test="${reservationDetail.status eq 'WAITING' && reservationDetail.position != null}">
                                <div class="mb-3"><strong>Queue position:</strong> #${reservationDetail.position}</div>
                            </c:if>

                            <c:if test="${reservationDetail.status eq 'CONVERTED' && reservationDetail.convertedRequestId != null}">
                                <div class="alert alert-success">
                                    Đơn đặt trước đã được chuyển thành Borrow Request #${reservationDetail.convertedRequestId}.
                                    Bạn có thể theo dõi ở tab "Đang chờ".
                                </div>
                            </c:if>

                            <div class="d-flex gap-2 flex-wrap">
                                <a class="btn btn-outline-secondary"
                                   href="${pageContext.request.contextPath}/books/detail?id=${reservationDetail.bookId}">Xem sách</a>

                                <c:if test="${reservationDetail.status eq 'WAITING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/reader/borrow-requests" class="m-0">
                                        <input type="hidden" name="filter" value="${filter}"/>
                                        <input type="hidden" name="reservationId" value="${reservationDetail.reservationId}"/>
                                        <button class="btn btn-outline-danger" name="action" value="cancel_reservation" type="submit"
                                                onclick="return confirm('Huỷ đặt trước này?');">
                                            Huỷ đặt trước
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>