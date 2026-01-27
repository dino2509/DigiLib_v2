<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Reader Home - Digital Library</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <style>
        .book-cover {
            height: 220px;
            object-fit: cover;
        }
    </style>
</head>

<body>

<jsp:include page="/include/reader/header.jsp"/>

<div class="container mt-4">

    <!-- Welcome -->
    <div class="alert alert-warning">
        👋 Xin chào, <strong>${sessionScope.user.fullName}</strong>!
        Chúc bạn đọc sách vui vẻ 📚
    </div>

    <!-- Search -->
    <form action="${pageContext.request.contextPath}/search" method="get" class="row mb-4">
        <div class="col-md-10">
            <input type="text" name="keyword" class="form-control"
                   placeholder="Tìm kiếm theo tên sách, tác giả...">
        </div>
        <div class="col-md-2">
            <button class="btn btn-warning w-100">🔍 Tìm kiếm</button>
        </div>
    </form>

    <!-- Book List -->
    <h4 class="mb-3">📚 Danh sách sách</h4>

    <!-- DEBUG – XÓA SAU -->
    <p class="text-danger">DEBUG bookList size: ${bookList.size()}</p>

    <div class="row">
        <c:forEach var="book" items="${bookList}">
            <div class="col-md-3 mb-4">
                <div class="card h-100 shadow-sm">

                    <!-- BOOK COVER -->
                    <img class="card-img-top book-cover"
                         src="${pageContext.request.contextPath}/${empty book.coverUrl 
                                ? 'assets/images/no-cover.png' 
                                : book.coverUrl}"
                         alt="${book.title}">

                    <div class="card-body">
                        <h6 class="card-title">${book.title}</h6>

                        <p class="text-muted mb-0">
                            <c:choose>
                                <c:when test="${book.price == null || book.price == 0}">
                                    Miễn phí
                                </c:when>
                                <c:otherwise>
                                    ${book.price} ${book.currency}
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div class="card-footer text-center bg-white">
                        <a href="${pageContext.request.contextPath}/book/detail?id=${book.bookId}"
                           class="btn btn-sm btn-warning">
                            Xem chi tiết
                        </a>
                    </div>

                </div>
            </div>
        </c:forEach>
    </div>

</div>

<jsp:include page="/include/reader/footer.jsp"/>

</body>
</html>
