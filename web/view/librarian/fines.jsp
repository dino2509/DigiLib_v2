<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Librarian - Quỹ phạt</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .cover-thumb{
            width: 48px;
            height: 64px;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid rgba(0,0,0,.08);
            background: #f6f6f6;
        }
        .table td{ vertical-align: middle; }
        .expand-btn{ width: 38px; height: 38px; padding: 0; display:inline-flex; align-items:center; justify-content:center; }
        .detail-wrap{ background: rgba(0,0,0,.02); }
        .detail-label{ color: rgba(0,0,0,.6); width: 120px; }
        .detail-grid{ display:flex; flex-wrap: wrap; gap: 14px 24px; }
        .detail-item{ min-width: 260px; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
        <div>
            <h3 class="mb-0">💰 Quản lý quỹ phạt</h3>
            <div class="small text-muted">Danh sách gọn • Nhấn mở rộng để xem chi tiết</div>
        </div>
        <div class="d-flex gap-2 align-items-center">
            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">← Dashboard</a>
            <input id="searchInput" class="form-control form-control-sm" style="width: 260px" placeholder="Tìm theo reader / sách / copy / lý do..."/>
        </div>
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

    <!-- Server-side tab (giữ nguyên) -->
    <div class="mt-4 mb-3">
        <a class="btn btn-sm ${tab=='UNPAID'?'btn-danger':'btn-outline-danger'}" href="?tab=UNPAID">Chưa nộp</a>
        <a class="btn btn-sm ${tab=='PAID'?'btn-success':'btn-outline-success'}" href="?tab=PAID">Đã nộp</a>
        <a class="btn btn-sm ${tab=='ALL'?'btn-dark':'btn-outline-dark'}" href="?tab=ALL">Tất cả</a>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th style="width: 52px;"></th>
                <th style="width: 420px;">Sách</th>
                <th style="width: 220px;">Reader</th>
                <th style="width: 140px;">Loại</th>
                <th style="width: 150px;">Số tiền</th>
                <th style="width: 140px;">Trạng thái</th>
                <th style="width: 120px;">Thao tác</th>
            </tr>
            </thead>
            <tbody id="fineBody">
            <c:forEach items="${fines}" var="f">
                <c:set var="rowId" value="fine_${f.fineId}"/>

                <tr class="fine-row" data-search="${f.readerName} ${f.bookTitle} ${f.copyCode} ${f.reason} ${f.fineTypeName} ${f.fineId}">
                    <td class="text-center">
                        <button class="btn btn-sm btn-outline-secondary expand-btn" type="button"
                                data-bs-toggle="collapse" data-bs-target="#${rowId}">
                            +
                        </button>
                    </td>

                    <td>
                        <div class="d-flex gap-2">
                            <img class="cover-thumb"
                                 src="${pageContext.request.contextPath}/img/book/no-cover.png"
                                 alt="cover">
                            <div>
                                <div class="fw-semibold">${f.bookTitle}</div>
                                <div class="small text-muted">Fine #${f.fineId} • Copy: ${f.copyCode}</div>
                            </div>
                        </div>
                    </td>

                    <td>
                        <div class="fw-semibold">${f.readerName}</div>
                        <div class="small text-muted">Reader #${f.readerId}</div>
                    </td>

                    <td>
                        <span class="badge bg-${f.fineTypeName=='OVERDUE'?'danger':'warning'}">${f.fineTypeName}</span>
                    </td>

                    <td class="text-end"><b><fmt:formatNumber value="${f.amount}" type="number"/> đ</b></td>

                    <td>
                        <span class="badge bg-${f.status=='PAID'?'success':'danger'}">${f.status}</span>
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

                <tr class="detail-wrap">
                    <td colspan="7" class="p-0">
                        <div id="${rowId}" class="collapse">
                            <div class="p-3">
                                <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
                                    <div class="fw-semibold">Chi tiết • Fine #${f.fineId}</div>
                                    <button class="btn btn-sm btn-outline-secondary" type="button"
                                            data-bs-toggle="collapse" data-bs-target="#${rowId}">
                                        Đóng
                                    </button>
                                </div>
                                <hr class="my-2"/>

                                <div class="detail-grid">
                                    <div class="detail-item">
                                        <div><span class="detail-label">Sách:</span> <b>${f.bookTitle}</b></div>
                                        <div><span class="detail-label">Copy:</span> <b>${f.copyCode}</b></div>
                                        <div><span class="detail-label">Loại phạt:</span> <b>${f.fineTypeName}</b></div>
                                    </div>

                                    <div class="detail-item">
                                        <div><span class="detail-label">Số tiền:</span> <b><fmt:formatNumber value="${f.amount}" type="number"/> đ</b></div>
                                        <div><span class="detail-label">Trạng thái:</span> <b>${f.status}</b></div>
                                        <div><span class="detail-label">Ngày tạo:</span>
                                            <b><fmt:formatDate value="${f.createdAt}" pattern="dd/MM/yyyy HH:mm"/></b>
                                        </div>
                                        <div><span class="detail-label">Ngày nộp:</span>
                                            <c:choose>
                                                <c:when test="${f.paidAt != null}"><b><fmt:formatDate value="${f.paidAt}" pattern="dd/MM/yyyy HH:mm"/></b></c:when>
                                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="detail-item" style="min-width: 320px;">
                                        <div class="fw-semibold mb-1">Lý do</div>
                                        <div class="border rounded p-2 bg-white small">${empty f.reason ? '-' : f.reason}</div>
                                    </div>
                                </div>

                                <div class="mt-2 small text-muted">
                                    • Phạt quá hạn: 5000đ / 1 ngày • Phạt hư hỏng: thủ thư nhập lúc duyệt trả / trả sách.
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty fines}">
                <tr>
                    <td colspan="7" class="text-center text-muted">Không có dữ liệu.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        const rows = Array.from(document.querySelectorAll('.fine-row'));
        const searchInput = document.getElementById('searchInput');

        function applySearch() {
            const q = (searchInput.value || '').trim().toLowerCase();
            rows.forEach(tr => {
                const hay = (tr.getAttribute('data-search') || '').toLowerCase();
                const show = !q || hay.includes(q);
                tr.style.display = show ? '' : 'none';
                const detailTr = tr.nextElementSibling;
                if (detailTr) detailTr.style.display = show ? '' : 'none';
            });
        }

        let t = null;
        searchInput.addEventListener('input', () => {
            if (t) window.clearTimeout(t);
            t = window.setTimeout(applySearch, 120);
        });
    })();
</script>

</body>
</html>