<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận yêu cầu mượn - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .mini-cover { width: 90px; height: 120px; object-fit: cover; border-radius: 8px; }
        .muted { color: #6c757d; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <a class="small" href="${pageContext.request.contextPath}/books/detail?id=${book.bookId}">← Quay lại chi tiết sách</a>

    <div class="row mt-3 g-3">
        <div class="col-lg-7">
            <div class="card shadow-sm">
                <div class="card-header fw-semibold">📩 Tạo yêu cầu mượn sách</div>
                <div class="card-body">

                    <div class="d-flex gap-3 align-items-start">
                        <img class="mini-cover"
                             src="${pageContext.request.contextPath}/img/book/${empty book.coverUrl ? 'no-cover.png' : book.coverUrl}"
                             alt="${book.title}">
                        <div class="flex-grow-1">
                            <div class="h5 mb-1">${book.title}</div>
                            <div class="muted">
                                <c:if test="${book.author != null}">Tác giả: <strong>${book.author.author_name}</strong><br/></c:if>
                                <c:if test="${book.category != null}">Thể loại: <strong>${book.category.category_name}</strong><br/></c:if>
                                Trong kho: <strong>${availableCopies}</strong> copy
                            </div>
                        </div>
                    </div>

                    <hr/>

                    <div class="mb-2">
                        <div class="fw-semibold">⏳ Thời hạn trả sách</div>
                        <div>Hạn trả mặc định: <strong>${defaultBorrowDays} ngày</strong> (Librarian có thể chỉnh trong khoảng <strong>7–14 ngày</strong> khi duyệt).</div>
                    </div>

                    <div class="mb-3">
                        <div class="fw-semibold">💸 Phí phạt quá hạn</div>
                        <div>Nếu trả muộn, phí phạt: <strong><fmt:formatNumber value="${finePerDay}" type="number"/></strong> / ngày.</div>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/reader/borrow/request" class="d-flex gap-2 flex-wrap">
                        <input type="hidden" name="bookId" value="${book.bookId}" />
                        <button class="btn btn-danger" type="submit">✅ Xác nhận tạo yêu cầu</button>
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/books/detail?id=${book.bookId}">Hủy</a>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="alert alert-light border">
                <div class="fw-semibold mb-1">Lưu ý</div>
                <ul class="mb-0">
                    <li>Yêu cầu mượn chỉ được tạo khi bạn không có sách quá hạn.</li>
                    <li>Mỗi tài khoản chỉ được mượn tối đa <strong>3</strong> cuốn cùng lúc.</li>
                    <li>Sau khi tạo, Librarian sẽ duyệt và cấp bản sao (BookCopy) phù hợp.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

</body>
</html>