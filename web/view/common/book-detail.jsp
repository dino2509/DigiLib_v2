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

            .book-card a:hover {
                background: var(--primary-dark);
            }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <a class="small" href="${pageContext.request.contextPath}/books">← Quay lại danh sách</a>

    <div class="row mt-3">
        <div class="col-md-4">
            <img class="card-img-top book-cover"
                             src="${pageContext.request.contextPath}/img/book/${empty book.coverUrl 
                                    ? 'no-cover.png' 
                                    : book.coverUrl}"
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

            <div class="mt-4 d-flex gap-2 flex-wrap">
                <c:if test="${isReader}">
                    <form method="post" action="${pageContext.request.contextPath}/favorites">
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
                </c:if>

                <a class="btn btn-warning" href="${pageContext.request.contextPath}/books">Xem thêm sách</a>
            </div>

            <c:if test="${!isReader}">
                <div class="alert alert-light border mt-3">
                    Đăng nhập để dùng tính năng <strong>Yêu thích</strong> và <strong>Mượn sách</strong>.
                </div>
            </c:if>
        </div>
    </div>
</div>

</body>
</html>
