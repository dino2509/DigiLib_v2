<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Librarian - Q&A</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<jsp:include page="/include/common/navbar.jsp"/>

<div class="container mt-4">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div>
            <h3 class="mb-0">💬 Q&A (Tất cả)</h3>
            <div class="text-muted">Ưu tiên hiển thị câu hỏi chưa trả lời (OPEN) ở phía trên.</div>
        </div>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/librarian/dashboard">Dashboard</a>
    </div>

    <hr/>

    <c:choose>
        <c:when test="${empty questions}">
            <div class="alert alert-light border">Chưa có câu hỏi nào.</div>
        </c:when>
        <c:otherwise>
            <div class="list-group">
                <c:forEach items="${questions}" var="q">
                    <div class="list-group-item">
                        <div class="d-flex justify-content-between flex-wrap gap-2">
                            <div class="fw-semibold">${q.readerName}</div>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-${q.status eq 'OPEN' ? 'secondary' : 'success'}">${q.status}</span>
                                <div class="small text-muted">${q.createdAt}</div>
                            </div>
                        </div>
                        <div class="mt-2">${q.questionText}</div>

                        <div class="mt-3">
                            <c:if test="${q.status eq 'OPEN'}">
                                <form method="post" action="${pageContext.request.contextPath}/librarian/qna" class="d-flex gap-2 flex-wrap">
                                    <input type="hidden" name="questionId" value="${q.questionId}"/>
                                    <input class="form-control" name="answer" placeholder="Nhập câu trả lời..." required />
                                    <button class="btn btn-danger" type="submit">Trả lời</button>
                                    <a class="btn btn-outline-secondary" target="_blank"
                                       href="${pageContext.request.contextPath}/books/detail?id=${q.bookId}#qna">
                                        Mở sách
                                    </a>
                                </form>
                            </c:if>

                            <c:if test="${q.status ne 'OPEN'}">
                                <a class="btn btn-sm btn-outline-secondary" target="_blank"
                                   href="${pageContext.request.contextPath}/books/detail?id=${q.bookId}#qna">
                                    Mở sách
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
