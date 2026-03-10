<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Yêu thích - DigiLib</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .fav-grid{
            display:grid;
            grid-template-columns:repeat(auto-fill, minmax(220px, 1fr));
            gap:18px;
        }
        .fav-card{
            border:1px solid #eee;
            border-radius:12px;
            overflow:hidden;
            box-shadow:0 6px 18px rgba(0,0,0,0.06);
            background:#fff;
        }
        .fav-cover{
            width:100%;
            height:240px;
            object-fit:cover;
            background:#f3f3f3;
        }
        .fav-title{
            font-weight:600;
            line-height:1.35;
            min-height:44px;
        }
        .muted{ color:#6c757d; }
    </style>
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div>
            <h3 class="mb-0">❤️ Sách yêu thích</h3>
            <div class="muted">Danh sách sách bạn đã thêm vào mục yêu thích.</div>
        </div>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/books">+ Thêm sách</a>
    </div>

    <hr class="my-3"/>

    <c:choose>
        <c:when test="${empty favorites}">
            <div class="alert alert-light border">
                Chưa có sách nào trong mục yêu thích.
                <a href="${pageContext.request.contextPath}/books">Xem danh sách sách</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="fav-grid">
                <c:forEach items="${favorites}" var="it">
                    <div class="fav-card">
                        <a href="${pageContext.request.contextPath}/books/detail?id=${it.book.bookId}" class="text-decoration-none text-dark">
                            <img class="fav-cover"
                                 src="${pageContext.request.contextPath}/img/book/${empty it.book.coverUrl ? 'no-cover.png' : it.book.coverUrl}"
                                 alt="${it.book.title}"/>
                        </a>
                        <div class="p-3">
                            <div class="fav-title">${it.book.title}</div>
                            <div class="muted small mt-1">
                                <c:choose>
                                    <c:when test="${it.book.price == null || it.book.price == 0}">
                                        Miễn phí
                                    </c:when>
                                    <c:otherwise>
                                        ${it.book.price} ${it.book.currency}
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="d-flex gap-2 mt-3">
                                <a class="btn btn-sm btn-warning flex-grow-1"
                                   href="${pageContext.request.contextPath}/books/detail?id=${it.book.bookId}">
                                    Xem
                                </a>
                                <form method="post" action="${pageContext.request.contextPath}/reader/favorites" class="m-0">
                                    <input type="hidden" name="action" value="remove"/>
                                    <input type="hidden" name="bookId" value="${it.book.bookId}"/>
                                    <button class="btn btn-sm btn-outline-danger" title="Bỏ yêu thích">✕</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
