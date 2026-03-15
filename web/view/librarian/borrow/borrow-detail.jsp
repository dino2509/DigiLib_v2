<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="borrow-header">

    <h2>Borrow Detail #${borrow.borrowId}</h2>

    <div class="borrow-info">

        <div>
            <b>Reader</b>
            <span>${borrow.readerName}</span>
        </div>

        <div>
            <b>Borrow Date</b>
            <span>
                <fmt:formatDate value="${borrow.borrowDate}" pattern="yyyy-MM-dd HH:mm"/>
            </span>
        </div>

    </div>

</div>



<div class="card">

    <table>

        <thead>

            <tr>
                <th>Book</th>
                <th>Author</th>
                <th>Category</th>
                <th>ISBN</th>
                <th>Copy Code</th>
                <th>Due Date</th>
                <th>Returned</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>

        </thead>

        <tbody>

            <c:forEach var="i" items="${items}">

                <tr>

                    <td>
                        <div class="book-title">${i.bookTitle}</div>
                        <div class="book-id">ID: ${i.bookId}</div>
                    </td>

                    <td>${i.authorName}</td>

                    <td>${i.categoryName}</td>

                    <td>${i.isbn}</td>

                    <td>
                        <span class="copy-badge">${i.copyCode}</span>
                    </td>

                    <td>

                        <span class="date">
                            <fmt:formatDate value="${i.dueDate}" pattern="yyyy-MM-dd"/>
                        </span>

                    </td>

                    <td>

                        <c:choose>

                            <c:when test="${i.returnedAt != null}">
                                <fmt:formatDate value="${i.returnedAt}" pattern="yyyy-MM-dd"/>
                            </c:when>

                            <c:otherwise>
                                -
                            </c:otherwise>

                        </c:choose>

                    </td>

                    <td>

                        <c:choose>

                            <c:when test="${i.status=='BORROWING'}">
                                <span class="badge borrowing">Borrowing</span>
                            </c:when>

                            <c:when test="${i.status=='RETURNED'}">
                                <span class="badge returned">Returned</span>
                            </c:when>

                            <c:when test="${i.status=='OVERDUE'}">
                                <span class="badge overdue">Overdue</span>
                            </c:when>

                        </c:choose>

                    </td>

                    <td class="actions">

                        <c:if test="${i.status=='BORROWING'}">

                            <form method="post"
                                  action="${pageContext.request.contextPath}/librarian/return">

                                <input type="hidden"
                                       name="borrowItemId"
                                       value="${i.borrowItemId}">

                                <input type="hidden"
                                       name="borrowId"
                                       value="${borrow.borrowId}">

                                <button class="btn return">
                                    <i class="fa-solid fa-rotate-left"></i>
                                    Return
                                </button>

                            </form>


                            <a class="btn extend"
                               href="${pageContext.request.contextPath}/librarian/extend?id=${i.borrowItemId}">

                                <i class="fa-solid fa-clock"></i>
                                Extend

                            </a>

                        </c:if>

                    </td>

                </tr>

            </c:forEach>

        </tbody>

    </table>

</div>



<div class="bottom-actions">

    <a class="btn back"
       href="${pageContext.request.contextPath}/librarian/borrows">

        ← Back to Borrow List

    </a>

</div>



<style>

    .borrow-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .borrow-info{
        display:flex;
        gap:30px;
        font-size:14px;
    }

    .card{
        background:white;
        border-radius:8px;
        box-shadow:0 3px 8px rgba(0,0,0,0.08);
        overflow:hidden;
    }

    table{
        width:100%;
        border-collapse:collapse;
    }

    th{
        background:#ff7a00;
        color:white;
        padding:12px;
        text-align:left;
        font-size:14px;
    }

    td{
        padding:12px;
        border-bottom:1px solid #eee;
        font-size:14px;
    }

    tr:hover{
        background:#fafafa;
    }

    .book-title{
        font-weight:bold;
    }

    .book-id{
        font-size:12px;
        color:#888;
    }

    .copy-badge{
        background:#eee;
        padding:4px 8px;
        border-radius:4px;
        font-weight:bold;
    }

    .badge{
        padding:4px 10px;
        border-radius:20px;
        font-size:12px;
        font-weight:bold;
    }

    .borrowing{
        background:#fff3cd;
        color:#ff9800;
    }

    .returned{
        background:#d4edda;
        color:#28a745;
    }

    .overdue{
        background:#f8d7da;
        color:#dc3545;
    }

    .actions{
        display:flex;
        gap:6px;
    }

    .btn{
        border:none;
        padding:6px 10px;
        border-radius:4px;
        font-size:13px;
        cursor:pointer;
        text-decoration:none;
        display:inline-flex;
        align-items:center;
        gap:4px;
    }

    .return{
        background:#28a745;
        color:white;
    }

    .extend{
        background:#3498db;
        color:white;
    }

    .back{
        background:#555;
        color:white;
        padding:8px 14px;
    }

    .bottom-actions{
        margin-top:20px;
    }

</style>