<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Reader Home - Digital Library</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>
    <body>

        <jsp:include page="/include/reader/header.jsp"/>

        <div class="container mt-4">

            <!-- Welcome -->
            <div class="alert alert-primary">
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
                    <button class="btn btn-primary w-100">🔍 Tìm kiếm</button>
                </div>
            </form>

            <!-- Quick Actions -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <a href="${pageContext.request.contextPath}/reader/borrowed-books"
                       class="btn btn-outline-success w-100">
                        📖 Sách đang mượn
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="${pageContext.request.contextPath}/reader/history"
                       class="btn btn-outline-info w-100">
                        🕒 Lịch sử mượn
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="${pageContext.request.contextPath}/reader/profile"
                       class="btn btn-outline-warning w-100">
                        👤 Hồ sơ cá nhân
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="${pageContext.request.contextPath}/logout"
                       class="btn btn-outline-danger w-100">
                        🚪 Đăng xuất
                    </a>
                </div>
            </div>

            <!-- Book List -->
            <h4 class="mb-3">📚 Sách mới / Nổi bật</h4>

            <div class="row">
                <c:forEach var="book" items="${bookList}">
                    <div class="col-md-3 mb-4">
                        <div class="card h-100">
                            <img src="${pageContext.request.contextPath}/${book.coverImage}"
                                 class="card-img-top"
                                 alt="${book.title}">
                            <div class="card-body">
                                <h6 class="card-title">${book.title}</h6>
                                <p class="text-muted">${book.author}</p>
                            </div>
                            <div class="card-footer text-center">
                                <a href="${pageContext.request.contextPath}/book/detail?id=${book.bookId}"
                                   class="btn btn-sm btn-primary">
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
