<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Librarian - Borrowed Books</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .cover-thumb {
            width: 54px;
            height: 72px;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid rgba(0,0,0,.08);
            background: #f6f6f6;
        }
        .table td { vertical-align: middle; }
        .filter-btns .btn { white-space: nowrap; }
        .muted-2 { color: rgba(0,0,0,.55); }
        .toggle-btn {
            width: 40px;
            height: 40px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }
        .detail-wrap { background: rgba(0,0,0,.02); }
        .detail-label {
            color: rgba(0,0,0,.6);
            width: 130px;
            display: inline-block;
        }
        .detail-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 14px 24px;
        }
        .detail-item { min-width: 260px; }
        .detail-actions {
            background: #fff;
            border: 1px solid rgba(0,0,0,.08);
            border-radius: 10px;
            padding: 12px;
        }
        .hidden { display: none !important; }
        .borrow-row.hidden-row,
        .detail-row.hidden-row {
            display: none !important;
        }
    </style>
</head>
<body>
<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4 mb-5">
    <div class="d-flex flex-wrap gap-2 align-items-center justify-content-between mb-2">
        <div>
            <h3 class="mb-0">📚 Quản lý sách đang cho mượn</h3>
            <div class="small text-muted">Danh sách gọn, filter chạy trực tiếp trên trang, tìm kiếm theo sách / reader / copy.</div>
        </div>
        <div class="d-flex gap-2 align-items-center">
            <input id="searchInput"
                   class="form-control form-control-sm"
                   style="width: 300px"
                   placeholder="Tìm theo sách / reader / copy..." />
            <a class="btn btn-sm btn-outline-primary"
               href="${pageContext.request.contextPath}/librarian/requests">
                Mở trang requests
            </a>
        </div>
    </div>

    <c:if test="${param.returned eq '1'}"><div class="alert alert-success">Đã xác nhận trả sách.</div></c:if>
    <c:if test="${param.returnError eq '1'}"><div class="alert alert-danger">Không thể xác nhận trả sách.</div></c:if>
    <c:if test="${param.rejected eq '1'}"><div class="alert alert-warning">Đã từ chối yêu cầu trả sách.</div></c:if>
    <c:if test="${param.rejectError eq '1'}"><div class="alert alert-danger">Không thể từ chối yêu cầu trả sách.</div></c:if>
    <c:if test="${param.extendRequested eq '1'}"><div class="alert alert-success">Đã tạo yêu cầu gia hạn.</div></c:if>
    <c:if test="${param.extendError eq '1'}"><div class="alert alert-danger">Không thể gia hạn. Sách có thể đang có yêu cầu gia hạn/yêu cầu trả hoặc còn phí phạt chưa thanh toán.</div></c:if>

    <div class="d-flex flex-wrap gap-2 align-items-center mb-3">
        <div class="btn-group btn-group-sm filter-btns" role="group">
            <button type="button" class="btn btn-outline-dark js-filter-btn" data-filter="all">
                Tất cả <span class="badge bg-dark ms-1" id="count-all">0</span>
            </button>
            <button type="button" class="btn btn-outline-primary js-filter-btn" data-filter="borrowing">
                Đang mượn <span class="badge bg-primary ms-1" id="count-borrowing">0</span>
            </button>
            <button type="button" class="btn btn-outline-danger js-filter-btn" data-filter="overdue">
                Quá hạn <span class="badge bg-danger ms-1" id="count-overdue">0</span>
            </button>
            <button type="button" class="btn btn-outline-success js-filter-btn" data-filter="returned">
                Đã trả <span class="badge bg-success ms-1" id="count-returned">0</span>
            </button>
        </div>
        <div class="small muted-2">(Filter không tải lại trang)</div>
    </div>

    <div id="emptyMessage" class="alert alert-light border d-none">Không có bản ghi nào phù hợp với filter hiện tại.</div>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
            <tr>
                <th style="width: 520px;">Sách</th>
                <th style="width: 260px;">Reader</th>
                <th style="width: 110px;">Copy</th>
                <th style="width: 180px;">Trạng thái</th>
                <th style="width: 72px;" class="text-center">Chi tiết</th>
            </tr>
            </thead>

            <tbody id="borrowedBody">
            <c:choose>
                <c:when test="${empty items}">
                    <tr>
                        <td colspan="5" class="text-center text-muted py-4">Không có dữ liệu.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${items}" var="it">
                        <c:set var="rowId" value="bb_${it.borrowItemId}" />
                        <c:set var="statusKey" value="${it.status == 'RETURNED' ? 'returned' : (it.status == 'OVERDUE' ? 'overdue' : 'borrowing')}" />
                        <c:set var="canExtendNow" value="${it.status != 'RETURNED' and it.pendingReturnRequestId == null and it.pendingExtendRequestId == null and !it.hasUnpaidFine}" />
                        <c:set var="canReturnNow" value="${it.status != 'RETURNED' and it.pendingExtendRequestId == null}" />

                        <tr class="borrow-row"
                            data-status-key="${statusKey}"
                            data-search="${it.book.title} ${it.readerName} ${it.copyCode}">
                            <td>
                                <div class="d-flex gap-2">
                                    <img class="cover-thumb"
                                         src="${pageContext.request.contextPath}/img/book/${empty it.book.coverUrl ? 'no-cover.png' : it.book.coverUrl}"
                                         alt="cover">
                                    <div>
                                        <div class="fw-semibold">${it.book.title}</div>

                                        <c:if test="${it.overdueDays > 0}">
                                            <div class="small text-danger">Quá hạn: <b>${it.overdueDays}</b> ngày</div>
                                        </c:if>

                                        <c:if test="${it.pendingReturnRequestId != null and it.status != 'RETURNED'}">
                                            <div class="small text-info">Đang có yêu cầu trả sách chờ xử lý.</div>
                                        </c:if>

                                        <c:if test="${it.pendingExtendRequestId != null and it.status != 'RETURNED'}">
                                            <div class="small text-primary">
                                                Đang có yêu cầu gia hạn chờ xử lý
                                                <c:if test="${it.pendingExtendRequestedDays != null}">
                                                    (${it.pendingExtendRequestedDays} ngày)
                                                </c:if>.
                                            </div>
                                        </c:if>

                                        <c:if test="${it.hasUnpaidFine and it.status != 'RETURNED'}">
                                            <div class="small text-danger">
                                                Có phí phạt chưa thanh toán
                                                <c:if test="${it.unpaidFineAmount != null}">
                                                    : <fmt:formatNumber value="${it.unpaidFineAmount}" type="number"/> đ
                                                </c:if>.
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty it.unpaidFineSummary and it.status != 'RETURNED'}">
                                            <div class="small text-muted">${it.unpaidFineSummary}</div>
                                        </c:if>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <div class="fw-semibold">${it.readerName}</div>
                                <div class="small text-muted">Reader ID: ${it.readerId}</div>
                            </td>

                            <td>
                                <span class="badge bg-secondary">${it.copyCode}</span>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${it.status == 'OVERDUE'}">
                                        <span class="badge bg-danger">Quá hạn</span>
                                    </c:when>
                                    <c:when test="${it.status == 'RETURNED'}">
                                        <span class="badge bg-success">Đã trả</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning text-dark">Đang mượn</span>
                                    </c:otherwise>
                                </c:choose>

                                <div class="small text-muted mt-1">
                                    BorrowItem ID: ${it.borrowItemId}
                                </div>
                            </td>

                            <td class="text-center">
                                <button class="btn btn-outline-secondary btn-sm toggle-btn js-toggle"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#${rowId}">
                                    +
                                </button>
                            </td>
                        </tr>

                        <tr class="detail-row"
                            data-status-key="${statusKey}"
                            data-search="${it.book.title} ${it.readerName} ${it.copyCode}">
                            <td colspan="5" class="p-0">
                                <div id="${rowId}" class="collapse detail-wrap">
                                    <div class="p-3">
                                        <div class="detail-grid mb-3">
                                            <div class="detail-item">
                                                <span class="detail-label">Borrow ID:</span> ${it.borrowId}
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">BorrowItem ID:</span> ${it.borrowItemId}
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Reader:</span> ${it.readerName}
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Copy:</span> ${it.copyCode}
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Ngày mượn:</span>
                                                <fmt:formatDate value="${it.borrowDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                            <div class="detail-item">
                                                <span class="detail-label">Hạn trả:</span>
                                                <fmt:formatDate value="${it.dueDate}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <c:if test="${it.returnedAt != null}">
                                                <div class="detail-item">
                                                    <span class="detail-label">Ngày trả:</span>
                                                    <fmt:formatDate value="${it.returnedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </c:if>
                                            <c:if test="${it.overdueDays > 0}">
                                                <div class="detail-item">
                                                    <span class="detail-label">Quá hạn:</span> ${it.overdueDays} ngày
                                                </div>
                                            </c:if>
                                        </div>

                                        <div class="detail-actions">
                                            <c:choose>
                                                <c:when test="${it.status == 'RETURNED'}">
                                                    <div class="small text-muted">Sách này đã được trả, không còn thao tác khả dụng.</div>
                                                </c:when>

                                                <c:otherwise>
                                                    <div class="d-flex flex-column gap-3">

                                                        <div>
                                                            <div class="fw-semibold mb-2">Xử lý trả sách</div>

                                                            <c:choose>
                                                                <c:when test="${it.pendingExtendRequestId != null}">
                                                                    <button class="btn btn-sm btn-outline-secondary" type="button" disabled>
                                                                        Không thể trả trực tiếp khi đang có request gia hạn
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form method="post"
                                                                          action="${pageContext.request.contextPath}/librarian/borrowed-books"
                                                                          class="m-0 js-return-form"
                                                                          data-book-title="${it.book.title}">
                                                                        <input type="hidden" name="action" value="return"/>
                                                                        <input type="hidden" name="filter" class="activeFilterField" value="${filter}"/>
                                                                        <input type="hidden" name="borrowItemId" value="${it.borrowItemId}"/>

                                                                        <button type="button"
                                                                                class="btn btn-sm btn-outline-success js-show-return-ui">
                                                                            Xử lý trả sách
                                                                        </button>

                                                                        <div class="mt-2 js-return-ui hidden">
                                                                            <div class="d-flex flex-wrap gap-2 align-items-center">
                                                                                <select class="form-select form-select-sm js-condition" style="width: 220px;">
                                                                                    <option value="NORMAL">Sách bình thường</option>
                                                                                    <option value="DAMAGED">Sách bị hư hỏng</option>
                                                                                </select>
                                                                                <button type="submit" class="btn btn-sm btn-success">Xác nhận trả</button>
                                                                                <button type="button" class="btn btn-sm btn-outline-secondary js-cancel-return">Huỷ</button>
                                                                            </div>

                                                                            <div class="mt-2 js-damage-fields hidden">
                                                                                <div class="input-group input-group-sm mb-2" style="max-width: 420px;">
                                                                                    <span class="input-group-text">Phí phạt (đ)</span>
                                                                                    <input type="number"
                                                                                           min="0"
                                                                                           step="1000"
                                                                                           class="form-control js-damage-amount"
                                                                                           placeholder="Nhập phí phạt...">
                                                                                </div>
                                                                                <input type="text"
                                                                                       class="form-control form-control-sm js-damage-reason"
                                                                                       style="max-width: 520px;"
                                                                                       placeholder="Lý do hư hỏng (tuỳ chọn)">
                                                                            </div>

                                                                            <input type="hidden" name="damageAmount" class="js-post-damageAmount" value=""/>
                                                                            <input type="hidden" name="damageReason" class="js-post-damageReason" value=""/>
                                                                        </div>
                                                                    </form>
                                                                </c:otherwise>
                                                            </c:choose>

                                                            <c:if test="${it.pendingReturnRequestId != null}">
                                                                <form method="post"
                                                                      action="${pageContext.request.contextPath}/librarian/borrowed-books"
                                                                      class="m-0 mt-2">
                                                                    <input type="hidden" name="action" value="reject"/>
                                                                    <input type="hidden" name="filter" class="activeFilterField" value="${filter}"/>
                                                                    <input type="hidden" name="returnRequestId" value="${it.pendingReturnRequestId}"/>
                                                                    <input type="text"
                                                                           class="form-control form-control-sm mb-2"
                                                                           name="decisionNote"
                                                                           style="max-width: 520px;"
                                                                           placeholder="Lý do từ chối (tuỳ chọn)"/>
                                                                    <button class="btn btn-sm btn-outline-danger" type="submit">Từ chối yêu cầu trả</button>
                                                                </form>
                                                            </c:if>
                                                        </div>

                                                        <div>
                                                            <div class="fw-semibold mb-2">Gia hạn</div>

                                                            <c:choose>
                                                                <c:when test="${canExtendNow}">
                                                                    <form method="post"
                                                                          action="${pageContext.request.contextPath}/librarian/borrowed-books"
                                                                          class="m-0">
                                                                        <input type="hidden" name="action" value="extend"/>
                                                                        <input type="hidden" name="filter" class="activeFilterField" value="${filter}"/>
                                                                        <input type="hidden" name="borrowItemId" value="${it.borrowItemId}"/>

                                                                        <div class="row g-2 align-items-end" style="max-width: 700px;">
                                                                            <div class="col-sm-3">
                                                                                <label class="form-label form-label-sm small fw-semibold">Số ngày gia hạn</label>
                                                                                <input type="number"
                                                                                       class="form-control form-control-sm"
                                                                                       name="extendDays"
                                                                                       min="1"
                                                                                       max="14"
                                                                                       value="7"/>
                                                                            </div>
                                                                            <div class="col-sm-6">
                                                                                <label class="form-label form-label-sm small fw-semibold">Ghi chú</label>
                                                                                <input type="text"
                                                                                       class="form-control form-control-sm"
                                                                                       name="decisionNote"
                                                                                       placeholder="Ghi chú gia hạn (tuỳ chọn)"/>
                                                                            </div>
                                                                            <div class="col-sm-3">
                                                                                <button class="btn btn-sm btn-outline-primary w-100"
                                                                                        type="submit"
                                                                                        onclick="return confirm('Tạo yêu cầu gia hạn cho sách này?');">
                                                                                    Tạo yêu cầu gia hạn
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                    </form>
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <div class="small text-muted">
                                                                        <c:choose>
                                                                            <c:when test="${it.pendingReturnRequestId != null}">
                                                                                Không thể gia hạn vì đang có yêu cầu trả sách.
                                                                            </c:when>
                                                                            <c:when test="${it.pendingExtendRequestId != null}">
                                                                                Không thể gia hạn vì đang có yêu cầu gia hạn chờ xử lý.
                                                                            </c:when>
                                                                            <c:when test="${it.hasUnpaidFine}">
                                                                                Không thể gia hạn vì còn phí phạt chưa thanh toán.
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Chưa thể gia hạn ở trạng thái hiện tại.
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <button class="btn btn-sm btn-outline-secondary mt-2" type="button" disabled>Chưa thể gia hạn</button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>

                                                    <div class="mt-3 small text-muted">
                                                        • Filter và tìm kiếm chỉ ẩn/hiện dòng phù hợp.
                                                        • Nếu có request gia hạn đang chờ thì tạm khoá xử lý trả trực tiếp.
                                                        • Nếu có request trả hoặc phí phạt chưa thanh toán thì không thể tạo request gia hạn mới.
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    const VALID_FILTERS = ['all', 'borrowing', 'overdue', 'returned'];
    const rowPairs = [];
    const mainRows = Array.from(document.querySelectorAll('.borrow-row'));
    const detailRows = Array.from(document.querySelectorAll('.detail-row'));
    const searchInput = document.getElementById('searchInput');
    const filterButtons = Array.from(document.querySelectorAll('.js-filter-btn'));
    const emptyMessage = document.getElementById('emptyMessage');

    const countEls = {
        all: document.getElementById('count-all'),
        borrowing: document.getElementById('count-borrowing'),
        overdue: document.getElementById('count-overdue'),
        returned: document.getElementById('count-returned')
    };

    for (let i = 0; i < mainRows.length; i++) {
        rowPairs.push({
            main: mainRows[i],
            detail: detailRows[i] || null
        });
    }

    function getInitialFilter() {
        const url = new URL(window.location.href);
        const fromUrl = (url.searchParams.get('filter') || '').toLowerCase();
        const fromServer = ('${filter}' || 'all').toLowerCase();
        const value = fromUrl || fromServer || 'all';
        return VALID_FILTERS.includes(value) ? value : 'all';
    }

    function setActiveButton(filterKey) {
        filterButtons.forEach(btn => {
            btn.classList.toggle('active', btn.dataset.filter === filterKey);
        });
    }

    function updateUrlFilter(filterKey) {
        const url = new URL(window.location.href);
        if (filterKey === 'all') {
            url.searchParams.delete('filter');
        } else {
            url.searchParams.set('filter', filterKey);
        }
        history.replaceState({}, '', url.toString());
    }

    function updateHiddenFilterFields(filterKey) {
        document.querySelectorAll('.activeFilterField').forEach(el => {
            el.value = filterKey;
        });
    }

    function applyFilter(filterKey) {
        const activeFilter = VALID_FILTERS.includes(filterKey) ? filterKey : 'all';
        const q = (searchInput.value || '').trim().toLowerCase();

        let matchedVisible = 0;
        let totalByStatus = {
            all: 0,
            borrowing: 0,
            overdue: 0,
            returned: 0
        };

        rowPairs.forEach(pair => {
            const key = (pair.main.dataset.statusKey || 'borrowing').toLowerCase();
            const hay = (pair.main.dataset.search || '').toLowerCase();

            if (totalByStatus[key] !== undefined) {
                totalByStatus[key]++;
            }
            totalByStatus.all++;

            const matchSearch = !q || hay.includes(q);
            const matchFilter = activeFilter === 'all' || key === activeFilter;
            const show = matchSearch && matchFilter;

            pair.main.classList.toggle('hidden-row', !show);
            if (pair.detail) {
                pair.detail.classList.toggle('hidden-row', !show);
            }

            if (show) matchedVisible++;
        });

        countEls.all.textContent = totalByStatus.all;
        countEls.borrowing.textContent = totalByStatus.borrowing;
        countEls.overdue.textContent = totalByStatus.overdue;
        countEls.returned.textContent = totalByStatus.returned;

        emptyMessage.classList.toggle('d-none', matchedVisible > 0 || rowPairs.length === 0);
        setActiveButton(activeFilter);
        updateHiddenFilterFields(activeFilter);
        updateUrlFilter(activeFilter);
    }

    let activeFilter = getInitialFilter();
    applyFilter(activeFilter);

    filterButtons.forEach(btn => {
        btn.addEventListener('click', function () {
            activeFilter = btn.dataset.filter || 'all';
            applyFilter(activeFilter);
        });
    });

    searchInput.addEventListener('input', function () {
        applyFilter(activeFilter);
    });

    document.querySelectorAll('.js-toggle').forEach(btn => {
        const target = document.querySelector(btn.getAttribute('data-bs-target'));
        if (!target) return;
        target.addEventListener('show.bs.collapse', () => btn.textContent = '−');
        target.addEventListener('hide.bs.collapse', () => btn.textContent = '+');
    });

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
            if (!ui) return;
            ui.classList.add('hidden');
            if (condition) condition.value = 'NORMAL';
            if (damageFields) damageFields.classList.add('hidden');
            if (damageAmountInput) damageAmountInput.value = '';
            if (damageReasonInput) damageReasonInput.value = '';
            if (postDamageAmount) postDamageAmount.value = '';
            if (postDamageReason) postDamageReason.value = '';
        }

        function syncDamagePostFields() {
            if (!condition || !postDamageAmount || !postDamageReason) return;

            if (condition.value === 'DAMAGED') {
                postDamageAmount.value = damageAmountInput ? (damageAmountInput.value || '').trim() : '';
                postDamageReason.value = damageReasonInput ? (damageReasonInput.value || '').trim() : '';
            } else {
                postDamageAmount.value = '';
                postDamageReason.value = '';
            }
        }

        if (showBtn && ui) {
            showBtn.addEventListener('click', () => ui.classList.remove('hidden'));
        }

        if (cancelBtn) {
            cancelBtn.addEventListener('click', hideUI);
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

        if (damageAmountInput) {
            damageAmountInput.addEventListener('input', syncDamagePostFields);
        }

        if (damageReasonInput) {
            damageReasonInput.addEventListener('input', syncDamagePostFields);
        }

        form.addEventListener('submit', function (e) {
            if (ui && ui.classList.contains('hidden')) {
                e.preventDefault();
                return;
            }
            syncDamagePostFields();
        });
    });
})();
</script>
</body>
</html>