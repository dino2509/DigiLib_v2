<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lịch sử mượn sách - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .mini-cover { width: 56px; height: 72px; object-fit: cover; border-radius: 6px; }
        .muted { color: #6c757d; }
        .borrow-item.hidden-by-filter { display: none !important; }
        .filter-pill.active { box-shadow: inset 0 0 0 999px rgba(13,110,253,.08); }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>
<jsp:useBean id="now" class="java.util.Date" />

<div class="container mt-4 mb-5">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div>
            <h4 class="mb-0">📚 Lịch sử mượn sách</h4>
            <div class="small text-muted">Bạn có thể lọc trực tiếp theo trạng thái, gửi yêu cầu trả sách sau bước xác nhận, và chọn gia hạn từ 1-7 ngày.</div>
        </div>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/reader/home">← Về trang Reader</a>
    </div>

    <c:if test="${param.returnRequested eq '1'}"><div class="alert alert-success mt-3">Đã tạo yêu cầu trả sách.</div></c:if>
    <c:if test="${param.returnError eq '1'}"><div class="alert alert-danger mt-3">Không thể tạo yêu cầu trả sách.</div></c:if>
    <c:if test="${param.extendRequested eq '1'}"><div class="alert alert-success mt-3">Đã gửi yêu cầu gia hạn.</div></c:if>
    <c:if test="${param.extendError eq '1'}"><div class="alert alert-danger mt-3">Không thể gửi yêu cầu gia hạn. Hãy kiểm tra xem sách có đang có phí phạt chưa thanh toán, đã có yêu cầu gia hạn trước đó, hoặc số ngày gia hạn không hợp lệ.</div></c:if>

    <div class="d-flex flex-wrap gap-2 mt-3" id="borrowFilterBar">
        <button class="btn btn-sm btn-outline-dark js-filter-btn filter-pill" type="button" data-filter="all">Tất cả</button>
        <button class="btn btn-sm btn-outline-success js-filter-btn filter-pill" type="button" data-filter="returned">Đã trả</button>
        <button class="btn btn-sm btn-outline-warning js-filter-btn filter-pill" type="button" data-filter="borrowing">Đang mượn</button>
        <button class="btn btn-sm btn-outline-danger js-filter-btn filter-pill" type="button" data-filter="overdue">Quá hạn</button>
    </div>

    <div class="list-group shadow-sm mt-3" id="borrowedList">
        <c:choose>
            <c:when test="${empty borrowedItems}">
                <div class="alert alert-light border mt-3 mb-0">Không có dữ liệu.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="it" items="${borrowedItems}">
                    <c:set var="isOverdue" value="${it.returnedAt == null and it.dueDate != null and it.dueDate.time < now.time}" />
                    <c:set var="statusKey" value="${it.returnedAt != null ? 'returned' : (isOverdue ? 'overdue' : 'borrowing')}" />
                    <c:set var="isPendingReturn" value="${pendingReturnBorrowItemIds != null and pendingReturnBorrowItemIds.contains(it.borrowItemId)}" />
                    <c:set var="isPendingExtend" value="${pendingExtendBorrowItemIds != null and pendingExtendBorrowItemIds.contains(it.borrowItemId)}" />

                    <div class="list-group-item d-flex align-items-center gap-3 borrow-item"
                         data-filter-key="${statusKey}"
                         data-borrow-item-id="${it.borrowItemId}"
                         data-book-title="${it.book.title}"
                         data-copy-code="${it.copyCode}"
                         data-due-date="<fmt:formatDate value='${it.dueDate}' pattern='dd/MM/yyyy'/>">
                        <img class="mini-cover"
                             src="${pageContext.request.contextPath}/img/book/${empty it.book.coverUrl ? 'no-cover.png' : it.book.coverUrl}"
                             alt="${it.book.title}">

                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                                <div class="fw-semibold">${it.book.title}</div>
                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                    <c:choose>
                                        <c:when test="${it.returnedAt != null}"><span class="badge bg-success">Đã trả</span></c:when>
                                        <c:when test="${isOverdue}"><span class="badge bg-danger">Quá hạn</span></c:when>
                                        <c:otherwise><span class="badge bg-warning text-dark">Đang mượn</span></c:otherwise>
                                    </c:choose>
                                    <c:if test="${it.returnedAt == null and isPendingReturn}"><span class="badge bg-info text-dark">Đã gửi yêu cầu trả</span></c:if>
                                    <c:if test="${it.returnedAt == null and isPendingExtend}"><span class="badge bg-primary">Đã gửi yêu cầu gia hạn</span></c:if>
                                </div>
                            </div>

                            <div class="small muted">Copy: ${it.copyCode} • Borrow ID: ${it.borrowId} • BorrowItem ID: ${it.borrowItemId}</div>
                            <div class="small">
                                Mượn: <fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy"/>
                                • Hạn trả: <fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/>
                                <c:if test="${it.returnedAt != null}">• Đã trả: <fmt:formatDate value="${it.returnedAt}" pattern="dd/MM/yyyy"/></c:if>
                            </div>
                            <c:if test="${it.unpaidFineAmount != null and it.unpaidFineAmount > 0}">
                                <div class="small text-danger mt-1">Phí phạt chưa thanh toán: <fmt:formatNumber value="${it.unpaidFineAmount}" type="number"/> đ. Cần thanh toán trước khi gia hạn.</div>
                            </c:if>
                            <c:if test="${not empty it.unpaidFineSummary and it.returnedAt == null}">
                                <div class="small text-danger mt-1"><c:out value="${it.unpaidFineSummary}"/></div>
                            </c:if>
                            <c:if test="${it.returnedAt == null and it.pendingExtendMaxDays != null and it.pendingExtendMaxDays > 0 and not isPendingExtend}">
                                <div class="small text-muted mt-1">Bạn có thể xin gia hạn tối đa ${it.pendingExtendMaxDays} ngày.</div>
                            </c:if>
                        </div>

                        <div class="d-flex flex-column gap-2">
                            <a class="btn btn-sm btn-warning" href="${pageContext.request.contextPath}/books/detail?id=${it.book.bookId}">Chi tiết</a>

                            <c:if test="${it.returnedAt == null}">
                                <c:choose>
                                    <c:when test="${isPendingReturn}">
                                        <button class="btn btn-sm btn-outline-secondary" type="button" disabled>Đã gửi yêu cầu trả</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-sm btn-outline-danger js-open-return-modal"
                                                type="button"
                                                data-borrow-item-id="${it.borrowItemId}"
                                                data-book-title="${it.book.title}"
                                                data-copy-code="${it.copyCode}"
                                                data-filter-key="${statusKey}">
                                            Trả sách
                                        </button>
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${isPendingExtend}">
                                        <button class="btn btn-sm btn-outline-secondary" type="button" disabled>Đã gửi gia hạn</button>
                                    </c:when>
                                    <c:when test="${!it.hasUnpaidFine}">
                                        <button class="btn btn-sm btn-outline-primary js-open-extend-modal"
                                                type="button"
                                                data-borrow-item-id="${it.borrowItemId}"
                                                data-book-title="${it.book.title}"
                                                data-copy-code="${it.copyCode}"
                                                data-due-date="<fmt:formatDate value='${it.dueDate}' pattern='dd/MM/yyyy'/>"
                                                data-max-days="7"
                                                data-filter-key="${statusKey}">
                                            Gia hạn
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-sm btn-outline-secondary" type="button" disabled>Chưa thể gia hạn</button>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <div id="emptyFilterMessage" class="alert alert-light border mt-3 d-none">Không có bản ghi nào phù hợp với bộ lọc hiện tại.</div>
</div>

<div class="modal fade" id="returnConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xác nhận gửi yêu cầu trả sách</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-2"><strong>Sách:</strong> <span id="returnBookTitle"></span></div>
                <div class="mb-2"><strong>Copy:</strong> <span id="returnCopyCode"></span></div>
                <div class="text-muted small">Sau khi xác nhận, hệ thống mới thật sự gửi request trả sách cho librarian.</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/reader/return/request" class="m-0">
                    <input type="hidden" name="borrowItemId" id="returnBorrowItemId" />
                    <input type="hidden" name="filter" id="returnFilter" value="${currentFilter}" />
                    <button class="btn btn-danger" type="submit">Xác nhận gửi yêu cầu trả</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="extendConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Yêu cầu gia hạn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-2"><strong>Sách:</strong> <span id="extendBookTitle"></span></div>
                <div class="mb-2"><strong>Copy:</strong> <span id="extendCopyCode"></span></div>
                <div class="mb-2"><strong>Hạn trả hiện tại:</strong> <span id="extendDueDate"></span></div>
                <div class="mb-3">
                    <label for="extendDaysInput" class="form-label fw-semibold">Số ngày muốn gia hạn</label>
                    <input type="number" class="form-control" id="extendDaysInput" min="1" max="7" value="1">
                    <div class="form-text">Reader được chọn từ 1 đến 7 ngày. Sau đó cần xác nhận lại trước khi request được gửi.</div>
                </div>
                <div class="alert alert-warning py-2 mb-0">Librarian khi duyệt có thể chấp nhận trong khoảng từ 1 đến đúng số ngày bạn đã yêu cầu.</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <form method="post" action="${pageContext.request.contextPath}/reader/borrow/extend-request" class="m-0" id="extendRequestForm">
                    <input type="hidden" name="borrowItemId" id="extendBorrowItemId" />
                    <input type="hidden" name="extendDays" id="extendDaysHidden" value="1" />
                    <input type="hidden" name="filter" id="extendFilter" value="${currentFilter}" />
                    <button class="btn btn-primary" type="submit">Xác nhận gửi yêu cầu gia hạn</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        const VALID_FILTERS = ['all', 'returned', 'borrowing', 'overdue'];
        const buttons = Array.from(document.querySelectorAll('.js-filter-btn'));
        const items = Array.from(document.querySelectorAll('.borrow-item'));
        const emptyMessage = document.getElementById('emptyFilterMessage');
        const currentFilterFromServer = '${currentFilter}';
        const urlParams = new URLSearchParams(window.location.search);
        let activeFilter = (urlParams.get('filter') || currentFilterFromServer || 'all').toLowerCase();
        if (!VALID_FILTERS.includes(activeFilter)) activeFilter = 'all';

        function updateUrlFilter(filterKey) {
            const url = new URL(window.location.href);
            if (filterKey === 'all') {
                url.searchParams.delete('filter');
            } else {
                url.searchParams.set('filter', filterKey);
            }
            window.history.replaceState({}, '', url.toString());
        }

        function setActive(filterKey) {
            activeFilter = VALID_FILTERS.includes(filterKey) ? filterKey : 'all';
            let visibleCount = 0;

            buttons.forEach(btn => {
                btn.classList.toggle('active', btn.dataset.filter === activeFilter);
            });

            items.forEach(item => {
                const show = activeFilter === 'all' || item.dataset.filterKey === activeFilter;
                item.classList.toggle('hidden-by-filter', !show);
                if (show) visibleCount++;
            });

            emptyMessage.classList.toggle('d-none', visibleCount > 0 || items.length === 0);
            updateUrlFilter(activeFilter);
        }

        buttons.forEach(btn => {
            btn.addEventListener('click', () => setActive(btn.dataset.filter));
        });

        setActive(activeFilter);

        const returnModalEl = document.getElementById('returnConfirmModal');
        const extendModalEl = document.getElementById('extendConfirmModal');
        const returnModal = returnModalEl ? new bootstrap.Modal(returnModalEl) : null;
        const extendModal = extendModalEl ? new bootstrap.Modal(extendModalEl) : null;

        const returnBorrowItemId = document.getElementById('returnBorrowItemId');
        const returnBookTitle = document.getElementById('returnBookTitle');
        const returnCopyCode = document.getElementById('returnCopyCode');
        const returnFilter = document.getElementById('returnFilter');

        document.querySelectorAll('.js-open-return-modal').forEach(btn => {
            btn.addEventListener('click', () => {
                returnBorrowItemId.value = btn.dataset.borrowItemId || '';
                returnBookTitle.textContent = btn.dataset.bookTitle || '';
                returnCopyCode.textContent = btn.dataset.copyCode || '';
                returnFilter.value = activeFilter;
                returnModal.show();
            });
        });

        const extendBorrowItemId = document.getElementById('extendBorrowItemId');
        const extendBookTitle = document.getElementById('extendBookTitle');
        const extendCopyCode = document.getElementById('extendCopyCode');
        const extendDueDate = document.getElementById('extendDueDate');
        const extendDaysInput = document.getElementById('extendDaysInput');
        const extendDaysHidden = document.getElementById('extendDaysHidden');
        const extendFilter = document.getElementById('extendFilter');
        const extendRequestForm = document.getElementById('extendRequestForm');

        function normalizeExtendDays(value, max) {
            const n = parseInt(value, 10);
            if (Number.isNaN(n)) return 1;
            if (n < 1) return 1;
            if (n > max) return max;
            return n;
        }

        document.querySelectorAll('.js-open-extend-modal').forEach(btn => {
            btn.addEventListener('click', () => {
                const maxDays = Math.max(1, Math.min(7, parseInt(btn.dataset.maxDays || '7', 10) || 7));
                extendBorrowItemId.value = btn.dataset.borrowItemId || '';
                extendBookTitle.textContent = btn.dataset.bookTitle || '';
                extendCopyCode.textContent = btn.dataset.copyCode || '';
                extendDueDate.textContent = btn.dataset.dueDate || '';
                extendDaysInput.min = '1';
                extendDaysInput.max = String(maxDays);
                extendDaysInput.value = '1';
                extendDaysHidden.value = '1';
                extendFilter.value = activeFilter;
                extendModal.show();
            });
        });

        extendDaysInput.addEventListener('input', () => {
            const maxDays = parseInt(extendDaysInput.max || '7', 10) || 7;
            const normalized = normalizeExtendDays(extendDaysInput.value, maxDays);
            extendDaysInput.value = normalized;
            extendDaysHidden.value = normalized;
        });

        extendRequestForm.addEventListener('submit', function () {
            const maxDays = parseInt(extendDaysInput.max || '7', 10) || 7;
            const normalized = normalizeExtendDays(extendDaysInput.value, maxDays);
            extendDaysInput.value = normalized;
            extendDaysHidden.value = normalized;
            extendFilter.value = activeFilter;
        });
    })();
</script>

<jsp:include page="/include/reader/footer.jsp"/>
</body>
</html>