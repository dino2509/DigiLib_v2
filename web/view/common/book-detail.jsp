<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Book Detail - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .muted { color: #6c757d; }
        .book-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 30px;
        }
        .book-card {
            background: white;
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .book-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.12);
        }
        .book-card img {
            width: 130px;
            height: 180px;
            object-fit: cover;
            margin: 0 auto 12px;
            border-radius: 6px;
        }
        .book-card h3 {
            font-size: 16px;
            min-height: 44px;
            margin: 8px 0;
        }
        .book-card p {
            font-weight: 600;
            margin: 6px 0 14px;
            color: #555;
        }
        .book-card a {
            margin-top: auto;
            background: var(--primary);
            color: white;
            padding: 9px 14px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
        }
        .book-card a:hover { background: var(--primary-dark); }
        .book-cover{ width:100%; max-height:420px; object-fit:cover; border-radius:10px; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <a class="small" href="${pageContext.request.contextPath}/books">← Quay lại danh sách</a>

    <div class="row mt-3">
        <div class="col-md-4">
            <img class="book-cover"
                 src="${pageContext.request.contextPath}/img/book/${empty book.coverUrl ? 'no-cover.png' : book.coverUrl}"
                 alt="${book.title}">
        </div>

        <div class="col-md-8">
            <h2 class="mb-1">${book.title}</h2>

            <div class="muted mb-3">
                <c:if test="${book.author != null}">Tác giả: <strong>${book.author.author_name}</strong> • </c:if>
                <c:if test="${book.category != null}">Thể loại: <strong>${book.category.category_name}</strong></c:if>
            </div>

            <div class="mb-2">
                <c:choose>
                    <c:when test="${book.price == null || book.price == 0}">
                        <span class="badge bg-success">Miễn phí</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-warning text-dark">${book.price} ${book.currency}</span>
                    </c:otherwise>
                </c:choose>
                <span class="badge bg-secondary">${book.status}</span>
            </div>

            <c:if test="${not empty book.summary}">
                <h5 class="mt-4">Tóm tắt</h5>
                <p>${book.summary}</p>
            </c:if>

            <c:if test="${not empty book.description}">
                <h5 class="mt-4">Mô tả</h5>
                <p>${book.description}</p>
            </c:if>

            <div class="mt-4 d-flex gap-2 flex-wrap align-items-center">
                <c:if test="${isReader}">
                    <form method="post" action="${pageContext.request.contextPath}/reader/favorites">
                        <input type="hidden" name="bookId" value="${book.bookId}">
                        <c:choose>
                            <c:when test="${isFavorite}">
                                <input type="hidden" name="action" value="remove">
                                <button class="btn btn-outline-danger">❤️ Bỏ yêu thích</button>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="action" value="add">
                                <button class="btn btn-danger">❤️ Thêm yêu thích</button>
                            </c:otherwise>
                        </c:choose>
                    </form>

                    <!-- Borrow request (Reader) -->
                    <c:choose>
                        <c:when test="${hasOverdue}">
                            <button class="btn btn-outline-danger" disabled>⛔ Bạn có sách quá hạn</button>
                        </c:when>
                        <c:when test="${isBorrowingThisBook}">
                            <button class="btn btn-outline-secondary" disabled>📚 Bạn đang mượn cuốn này</button>
                        </c:when>
                        <c:when test="${hasPendingBorrow}">
                            <button class="btn btn-outline-secondary" disabled>📩 Đã gửi yêu cầu mượn</button>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="${pageContext.request.contextPath}/reader/borrow/request" class="d-flex gap-2 flex-wrap">
                                <input type="hidden" name="bookId" value="${book.bookId}">
                                <input class="form-control" style="min-width: 240px" name="note" placeholder="Ghi chú (tuỳ chọn)" />
                                <button class="btn btn-primary" type="submit">📩 Yêu cầu mượn</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <a class="btn btn-warning" href="${pageContext.request.contextPath}/books">Xem thêm sách</a>
            </div>

            <c:if test="${param.borrowRequested == '1'}">
                <div class="alert alert-success mt-3">Đã gửi yêu cầu mượn. Vui lòng chờ Librarian duyệt.</div>
            </c:if>
            <c:if test="${param.borrowError == '1'}">
                <div class="alert alert-danger mt-3">Không thể gửi yêu cầu mượn (lỗi hệ thống). Thử lại sau.</div>
            </c:if>
            <c:if test="${param.alreadyBorrowing == '1'}">
                <div class="alert alert-info mt-3">Bạn đang mượn cuốn này nên không thể gửi yêu cầu mượn mới.</div>
            </c:if>
            <c:if test="${param.hasOverdue == '1' || hasOverdue}">
                <div class="alert alert-danger mt-3">Bạn đang có sách quá hạn. Vui lòng trả sách trước khi mượn thêm.</div>
            </c:if>
        </div>
    </div>

    <!-- Gợi ý sách khác -->
    <c:if test="${not empty recommendedBooks}">
        <hr class="my-4"/>
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
            <h4 class="mb-0">📚 Gợi ý sách khác</h4>
            <a class="small" href="${pageContext.request.contextPath}/books">Xem tất cả</a>
        </div>
        <div class="book-list mt-3">
            <c:forEach items="${recommendedBooks}" var="rb">
                <div class="book-card">
                    <img src="${pageContext.request.contextPath}/img/book/${empty rb.coverUrl ? 'no-cover.png' : rb.coverUrl}" alt="${rb.title}">
                    <h3>${rb.title}</h3>
                    <p>
                        <c:choose>
                            <c:when test="${rb.price == null || rb.price == 0}">Miễn phí</c:when>
                            <c:otherwise>${rb.price} ${rb.currency}</c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/books/detail?id=${rb.bookId}">Xem chi tiết</a>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- Hỏi & đáp -->
    <hr class="my-4"/>
    <div id="qna">
        <h4 class="mb-3">💬 Hỏi &amp; đáp về sách</h4>

        <c:if test="${isReader}">
            <form class="card card-body mb-3" method="post" action="${pageContext.request.contextPath}/books/qna">
                <input type="hidden" name="bookId" value="${book.bookId}" />
                <label class="form-label fw-semibold">Đặt câu hỏi</label>
                <div class="d-flex gap-2 flex-wrap">
                    <input class="form-control" name="question" placeholder="Viết câu hỏi của bạn tại đây" required />
                    <button class="btn btn-danger" type="submit">Gửi câu hỏi</button>
                </div>
                <div class="small text-muted mt-2">Librarian sẽ trả lời trong mục bên dưới.</div>
            </form>
        </c:if>
        <c:if test="${!isReader}">
            <div class="alert alert-light border">Đăng nhập Reader để đặt câu hỏi.</div>
        </c:if>

        <c:choose>
            <c:when test="${empty qas}">
                <div class="alert alert-light border">Chưa có câu hỏi nào cho sách này.</div>
            </c:when>
            <c:otherwise>
                <div class="list-group">
                    <c:forEach items="${qas}" var="q">
                        <div class="list-group-item">
                            <div class="d-flex justify-content-between flex-wrap gap-2">
                                <div>
                                    <div class="fw-semibold">${q.readerName}</div>
                                    <div class="text-muted small">${q.createdAt}</div>
                                </div>
                                <span class="badge bg-${q.status eq 'ANSWERED' ? 'success' : 'secondary'}">${q.status}</span>
                            </div>

                            <div class="mt-2">${q.questionText}</div>

                            <c:if test="${not empty q.answers}">
                                <div class="mt-3 ps-3 border-start">
                                    <c:forEach items="${q.answers}" var="a">
                                        <div class="mb-2">
                                            <div class="fw-semibold">${a.employeeName} <span class="text-muted small">• ${a.createdAt}</span></div>
                                            <div>${a.answerText}</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <c:if test="${empty q.answers}">
                                <div class="mt-2 text-muted small">Chưa có trả lời.</div>

                                <!-- Librarian only: answer directly here -->
                                <c:if test="${isLibrarian}">
                                    <form class="mt-3" method="post" action="${pageContext.request.contextPath}/librarian/qna/answer">
                                        <input type="hidden" name="bookId" value="${book.bookId}" />
                                        <input type="hidden" name="questionId" value="${q.questionId}" />
                                        <div class="d-flex gap-2 flex-wrap">
                                            <input class="form-control" name="answer" placeholder="Librarian trả lời tại đây..." required />
                                            <button class="btn btn-warning" type="submit">Trả lời</button>
                                        </div>
                                    </form>
                                </c:if>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</body>
</html>