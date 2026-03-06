<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
    <title>Librarian - Borrowed Books</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .cover-thumb{
            width: 54px;
            height: 72px;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid rgba(0,0,0,.08);
            background: #f6f6f6;
        }
        .table td{ vertical-align: middle; }
        .filter-btns .btn{ white-space: nowrap; }
        .muted-2{ color: rgba(0,0,0,.55); }

        .toggle-btn{
            width: 40px;
            height: 40px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }
        .detail-wrap{ background: rgba(0,0,0,.02); }
        .detail-label{ color: rgba(0,0,0,.6); width: 120px; display:inline-block; }
        .detail-grid{ display:flex; flex-wrap: wrap; gap: 14px 24px; }
        .detail-item{ min-width: 260px; }
        .detail-actions{
            background: #fff;
            border: 1px solid rgba(0,0,0,.08);
            border-radius: 10px;
            padding: 12px;
        }
        .hidden{ display:none !important; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex flex-wrap gap-2 align-items-center justify-content-between mb-2">
        <div>
            <h3 class="mb-0">📚 Quản lý sách đang cho mượn</h3>
            <div class="small text-muted">Danh sách gọn • Nhấn (+/−) để xem chi tiết • Lọc không tải lại trang</div>
        </div>

        <div class="d-flex gap-2 align-items-center">
            <input id="searchInput" class="form-control form-control-sm" style="width: 280px" placeholder="Tìm theo sách / reader / copy..."/>
        </div>
    </div>

    <!-- Alerts after actions -->
    <c:if test="${param.returned eq '1'}">
        <div class="alert alert-success">Đã xác nhận trả sách.</div>
    </c:if>
    <c:if test="${param.returnError eq '1'}">
        <div class="alert alert-danger">Không thể xác nhận trả sách (có thể sách đã trả hoặc dữ liệu không hợp lệ).</div>
    </c:if>
    <c:if test="${param.rejected eq '1'}">
        <div class="alert alert-warning">Đã từ chối yêu cầu trả sách.</div>
    </c:if>
    <c:if test="${param.rejectError eq '1'}">
        <div class="alert alert-danger">Không thể từ chối yêu cầu trả sách (có thể request đã được xử lý).</div>
    </c:if>

    <!-- Client-side filter buttons (NO redirect / NO reload) -->
    <div class="d-flex flex-wrap gap-2 align-items-center mb-3">
        <div class="btn-group btn-group-sm filter-btns" role="group" aria-label="Filters">
            <button type="button" class="btn btn-outline-dark" data-filter="all">Tất cả <span class="badge bg-dark ms-1" id="count-all">0</span></button>
            <button type="button" class="btn btn-outline-primary" data-filter="borrowing">Đang mượn <span class="badge bg-primary ms-1" id="count-borrowing">0</span></button>
            <button type="button" class="btn btn-outline-danger" data-filter="overdue">Quá hạn <span class="badge bg-danger ms-1" id="count-overdue">0</span></button>
            <button type="button" class="btn btn-outline-success" data-filter="returned">Đã trả <span class="badge bg-success ms-1" id="count-returned">0</span></button>
        </div>
        <div class="small muted-2">(Bấm filter để ẩn/hiện dòng, không gọi server)</div>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th style="width: 520px;">Sách</th>
                <th style="width: 260px;">Reader</th>
                <th style="width: 110px;">Copy</th>
                <th style="width: 170px;">Trạng thái</th>
                <th style="width: 72px;" class="text-center">Chi tiết</th>
            </tr>
            </thead>

            <tbody id="borrowedBody">
            <c:forEach items="${items}" var="it">
                <c:set var="rowId" value="bb_${it.borrowItemId}"/>

                <!-- SUMMARY ROW -->
                <tr class="borrow-row"
                    data-status="${it.status}"
                    data-search="${it.book.title} ${it.readerName} ${it.copyCode}">

                    <td>
                        <div class="d-flex gap-2">
                            <!-- FIX COVER -->
                            <img class="cover-thumb"
                                 src="${pageContext.request.contextPath}/img/book/${empty it.book.coverUrl ? 'no-cover.png' : it.book.coverUrl}"
                                 alt="cover">
                            <div>
                                <div class="fw-semibold">${it.book.title}</div>
                                <c:if test="${it.overdueDays > 0}">
                                    <div class="small text-danger">Quá hạn: <b>${it.overdueDays}</b> ngày</div>
                                </c:if>
                            </div>
                        </div>
                    </td>

                    <td>
                        <div class="fw-semibold">${it.readerName}</div>
                    </td>

                    <td><span class="badge bg-secondary">${it.copyCode}</span></td>

                    <td>
                        <c:choose>
                            <c:when test="${it.status=='OVERDUE'}">
                                <span class="badge bg-danger">Quá hạn</span>
                            </c:when>
                            <c:when test="${it.status=='RETURNED'}">
                                <span class="badge bg-success">Đã trả</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning text-dark">Đang mượn</span>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${it.pendingReturnRequestId != null}">
                            <span class="badge bg-info ms-1">Return Request</span>
                        </c:if>
                    </td>

                    <!-- TOGGLE BUTTON ON THE RIGHT -->
                    <td class="text-center">
                        <button class="btn btn-sm btn-outline-secondary toggle-btn js-toggle"
                                type="button"
                                data-bs-toggle="collapse"
                                data-bs-target="#${rowId}"
                                aria-expanded="false"
                                aria-controls="${rowId}">
                            +
                        </button>
                    </td>
                </tr>

                <!-- DETAIL ROW -->
                <tr class="detail-wrap">
                    <td colspan="5" class="p-0">
                        <div id="${rowId}" class="collapse">
                            <div class="p-3">
                                <div class="fw-semibold mb-2">Chi tiết</div>

                                <div class="detail-grid">
                                    <div class="detail-item">
                                        <div><span class="detail-label">Ngày mượn:</span>
                                            <b><fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy"/></b>
                                        </div>
                                        <div><span class="detail-label">Hạn trả:</span>
                                            <b><fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/></b>
                                        </div>
                                        <div><span class="detail-label">Ngày trả:</span>
                                            <c:choose>
                                                <c:when test="${it.returnedAt != null}">
                                                    <b><fmt:formatDate value="${it.returnedAt}" pattern="dd/MM/yyyy"/></b>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">-</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="detail-item">
                                        <div><span class="detail-label">Phí phạt:</span>
                                            <c:choose>
                                                <c:when test="${it.overdueDays > 0}">
                                                    <span class="text-danger"><b>${it.overdueDays}</b> ngày</span>
                                                    <span class="small text-muted">(5.000đ/ngày)</span>
                                                    <c:choose>
                                                        <c:when test="${it.overdueFineAmount != null}">
                                                            <div class="small">Chưa nộp: <b><fmt:formatNumber value="${it.overdueFineAmount}" type="number"/> đ</b></div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="small text-muted">Ước tính: <b><fmt:formatNumber value="${it.overdueDays * 5000}" type="number"/> đ</b></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- chỉ hiện nếu có request -->
                                        <c:if test="${it.pendingReturnRequestId != null}">
                                            <div class="small text-muted">Return Request: <b>#${it.pendingReturnRequestId}</b></div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="mt-3 detail-actions">
                                    <c:choose>
                                        <c:when test="${it.status=='RETURNED'}">
                                            <div class="text-muted">Đơn này đã trả xong.</div>
                                        </c:when>
                                        <c:otherwise>

                                            <!-- ACTIONS: Trả sách / Duyệt trả -->
                                            <div class="d-flex flex-wrap gap-2 align-items-start">
                                                <!-- Confirm return -->
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/librarian/borrowed-books"
                                                      class="m-0 js-return-form"
                                                      data-book-title="${it.book.title}"
                                                      data-borrowitem-id="${it.borrowItemId}">

                                                    <input type="hidden" name="action" value="return"/>
                                                    <input type="hidden" name="filter" class="activeFilterField" value="${filter}"/>
                                                    <input type="hidden" name="borrowItemId" value="${it.borrowItemId}"/>
                                                    <c:if test="${it.pendingReturnRequestId != null}">
                                                        <input type="hidden" name="returnRequestId" value="${it.pendingReturnRequestId}"/>
                                                    </c:if>

                                                    <!-- button triggers showing condition dropdown -->
                                                    <button type="button"
                                                            class="btn btn-sm btn-danger js-show-return-ui">
                                                        <c:choose>
                                                            <c:when test="${it.pendingReturnRequestId != null}">Duyệt trả</c:when>
                                                            <c:otherwise>Trả sách</c:otherwise>
                                                        </c:choose>
                                                    </button>

                                                    <!-- return ui (hidden by default) -->
                                                    <div class="mt-2 js-return-ui hidden">
                                                        <div class="d-flex flex-wrap gap-2 align-items-center">
                                                            <select class="form-select form-select-sm js-condition" style="min-width: 200px;">
                                                                <option value="NORMAL" selected>Bình thường</option>
                                                                <option value="DAMAGED">Hỏng</option>
                                                            </select>

                                                            <button type="submit" class="btn btn-sm btn-primary">
                                                                Xác nhận trả
                                                            </button>

                                                            <button type="button" class="btn btn-sm btn-outline-secondary js-cancel-return">
                                                                Huỷ
                                                            </button>
                                                        </div>

                                                        <!-- damage fields -->
                                                        <div class="mt-2 js-damage-fields hidden">
                                                            <div class="input-group input-group-sm mb-2" style="max-width: 420px;">
                                                                <span class="input-group-text">Phí phạt (đ)</span>
                                                                <input type="number" min="0" step="1000"
                                                                       class="form-control js-damage-amount"
                                                                       placeholder="Nhập phí phạt...">
                                                            </div>
                                                            <input type="text"
                                                                   class="form-control form-control-sm js-damage-reason"
                                                                   style="max-width: 520px;"
                                                                   placeholder="Lý do hư hỏng (tuỳ chọn)">
                                                        </div>

                                                        <!-- actual fields posted to controller -->
                                                        <input type="hidden" name="damageAmount" class="js-post-damageAmount" value=""/>
                                                        <input type="hidden" name="damageReason" class="js-post-damageReason" value=""/>
                                                    </div>
                                                </form>

                                                <!-- Reject pending return request -->
                                                <c:if test="${it.pendingReturnRequestId != null}">
                                                    <form method="post" action="${pageContext.request.contextPath}/librarian/borrowed-books" class="m-0">
                                                        <input type="hidden" name="action" value="reject"/>
                                                        <input type="hidden" name="filter" class="activeFilterField" value="${filter}"/>
                                                        <input type="hidden" name="returnRequestId" value="${it.pendingReturnRequestId}"/>
                                                        <input type="text" class="form-control form-control-sm mb-2" name="decisionNote" style="max-width: 520px;"
                                                               placeholder="Lý do từ chối (tuỳ chọn)"/>
                                                        <button class="btn btn-sm btn-outline-secondary" type="submit">Từ chối</button>
                                                    </form>
                                                </c:if>
                                            </div>

                                            <div class="mt-2 small text-muted">
                                                • Phạt quá hạn: 5000đ / 1 ngày (tính theo <b>ngày</b>, không tính theo giờ).
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                            </div>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty items}">
                <tr>
                    <td colspan="5" class="text-center text-muted">Không có dữ liệu.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        // ========= Filter + Search (no reload) =========
        const rows = Array.from(document.querySelectorAll('.borrow-row'));
        const searchInput = document.getElementById('searchInput');
        const filterButtons = Array.from(document.querySelectorAll('[data-filter]'));
        const countEls = {
            all: document.getElementById('count-all'),
            borrowing: document.getElementById('count-borrowing'),
            overdue: document.getElementById('count-overdue'),
            returned: document.getElementById('count-returned')
        };

        function statusToKey(status) {
            if (!status) return 'borrowing';
            status = String(status).toUpperCase();
            if (status === 'RETURNED') return 'returned';
            if (status === 'OVERDUE') return 'overdue';
            return 'borrowing';
        }

        function setActiveButton(filterKey) {
            filterButtons.forEach(btn => {
                const key = btn.getAttribute('data-filter');
                btn.classList.remove('active');
                if (key === filterKey) btn.classList.add('active');
            });
        }

        function updateHiddenFilterFields(filterKey) {
            document.querySelectorAll('.activeFilterField').forEach(el => el.value = filterKey);
        }

        function applyFilter(filterKey) {
            const q = (searchInput.value || '').trim().toLowerCase();

            let visibleAll = 0;
            let visibleBorrowing = 0;
            let visibleOverdue = 0;
            let visibleReturned = 0;

            rows.forEach(tr => {
                const key = statusToKey(tr.getAttribute('data-status'));
                const hay = (tr.getAttribute('data-search') || '').toLowerCase();
                const matchSearch = !q || hay.includes(q);
                const matchFilter = (filterKey === 'all') || (key === filterKey);

                const show = matchSearch && matchFilter;
                tr.style.display = show ? '' : 'none';

                const detailTr = tr.nextElementSibling;
                if (detailTr) detailTr.style.display = show ? '' : 'none';

                if (matchSearch) {
                    visibleAll++;
                    if (key === 'borrowing') visibleBorrowing++;
                    else if (key === 'overdue') visibleOverdue++;
                    else if (key === 'returned') visibleReturned++;
                }
            });

            countEls.all.textContent = visibleAll;
            countEls.borrowing.textContent = visibleBorrowing;
            countEls.overdue.textContent = visibleOverdue;
            countEls.returned.textContent = visibleReturned;

            setActiveButton(filterKey);
            updateHiddenFilterFields(filterKey);
        }

        const initial = ("${filter}" || 'all').trim().toLowerCase();
        const initialKey = ['all', 'borrowing', 'overdue', 'returned'].includes(initial) ? initial : 'all';
        applyFilter(initialKey);

        filterButtons.forEach(btn => btn.addEventListener('click', () => applyFilter(btn.getAttribute('data-filter'))));

        let t = null;
        searchInput.addEventListener('input', () => {
            if (t) window.clearTimeout(t);
            const activeBtn = document.querySelector('[data-filter].active');
            const activeKey = activeBtn ? activeBtn.getAttribute('data-filter') : initialKey;
            t = window.setTimeout(() => applyFilter(activeKey), 120);
        });

        // ========= Toggle button text + / - =========
        document.querySelectorAll('.js-toggle').forEach(btn => {
            const targetSel = btn.getAttribute('data-bs-target');
            const el = document.querySelector(targetSel);
            if (!el) return;

            el.addEventListener('show.bs.collapse', () => btn.textContent = '−');
            el.addEventListener('hide.bs.collapse', () => btn.textContent = '+');
        });

        // ========= Return flow: show dropdown only when click Return =========
        document.querySelectorAll('.js-return-form').forEach(form => {
            const showBtn = form.querySelector('.js-show-return-ui');
            const ui = form.querySelector('.js-return-ui');
            const cancelBtn = form.querySelector('.js-cancel-return');

            const condition = form.querySelector('.js-condition');
            const damageFields = form.querySelector('.js-damage-fields');
            const damageAmountInput = form.querySelector('.js-damage-amount');
            const damageReasonInput = form.querySelector('.js-damage-reason');

            const postDamageAmount = form.querySelector('.js-post-damageAmount');
            const postDamageReason = form.querySelector('.js-post-damageReason');

            function hideUI() {
                ui.classList.add('hidden');
                // reset UI
                if (condition) condition.value = 'NORMAL';
                if (damageFields) damageFields.classList.add('hidden');
                if (damageAmountInput) damageAmountInput.value = '';
                if (damageReasonInput) damageReasonInput.value = '';
                if (postDamageAmount) postDamageAmount.value = '';
                if (postDamageReason) postDamageReason.value = '';
            }

            function syncDamagePostFields() {
                if (!condition) return;
                if (condition.value === 'DAMAGED') {
                    const amt = (damageAmountInput && damageAmountInput.value) ? damageAmountInput.value.trim() : '';
                    const reason = (damageReasonInput && damageReasonInput.value) ? damageReasonInput.value.trim() : '';
                    postDamageAmount.value = amt;
                    postDamageReason.value = reason;
                } else {
                    postDamageAmount.value = '';
                    postDamageReason.value = '';
                }
            }

            if (showBtn && ui) {
                showBtn.addEventListener('click', () => {
                    ui.classList.remove('hidden');
                });
            }

            if (cancelBtn) {
                cancelBtn.addEventListener('click', () => hideUI());
            }

            if (condition && damageFields) {
                condition.addEventListener('change', () => {
                    if (condition.value === 'DAMAGED') {
                        damageFields.classList.remove('hidden');
                    } else {
                        damageFields.classList.add('hidden');
                        if (damageAmountInput) damageAmountInput.value = '';
                        if (damageReasonInput) damageReasonInput.value = '';
                    }
                    syncDamagePostFields();
                });
            }

            if (damageAmountInput) damageAmountInput.addEventListener('input', syncDamagePostFields);
            if (damageReasonInput) damageReasonInput.addEventListener('input', syncDamagePostFields);

            form.addEventListener('submit', (e) => {
                // Only confirm when UI is visible (user intentionally clicked return)
                if (ui && ui.classList.contains('hidden')) {
                    e.preventDefault();
                    return;
                }

                syncDamagePostFields();

                const title = form.getAttribute('data-book-title') || 'cuốn sách';
                const cond = condition ? condition.value : 'NORMAL';

                if (cond === 'DAMAGED') {
                    const amt = (postDamageAmount.value || '').trim();
                    if (!amt || isNaN(Number(amt)) || Number(amt) <= 0) {
                        e.preventDefault();
                        alert('Vui lòng nhập phí phạt hợp lệ khi chọn tình trạng "Hỏng".');
                        return;
                    }
                    const ok = window.confirm('Xác nhận trả sách "' + title + '" với tình trạng HỎNG và phí phạt ' + Number(amt).toLocaleString('vi-VN') + ' đ ?');
                    if (!ok) e.preventDefault();
                } else {
                    const ok = window.confirm('Xác nhận trả sách "' + title + '" (Bình thường)?');
                    if (!ok) e.preventDefault();
                }
            });
        });
    })();
</script>

</body>
</html>