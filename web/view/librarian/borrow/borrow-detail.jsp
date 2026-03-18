<%@page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>

    :root{
        --main-orange:#ff7a00;
        --light-orange:#fff4e8;
        --border-orange:#ffe0c2;
    }

    .page-wrap{
        max-width:1100px;
        margin:auto;
        background:#fff;
        padding:25px;
        border-radius:10px;
        border:1px solid var(--border-orange);
        box-shadow:0 4px 14px rgba(0,0,0,0.06);
    }

    .borrow-header{
        margin-bottom:25px;
        padding-bottom:15px;
        border-bottom:2px solid var(--border-orange);

        /* 🔥 thêm flex để chứa nút */
        display:flex;
        justify-content:space-between;
        align-items:center;
    }

    .borrow-title{
        font-size:26px;
        font-weight:700;
        color:var(--main-orange);
    }

    /* 🔥 BACK BUTTON */

    .btn-back{
        padding:8px 14px;
        border-radius:6px;
        background:#eee;
        text-decoration:none;
        font-size:13px;
        color:#333;
        display:flex;
        align-items:center;
        gap:6px;
        transition:0.2s;
    }

    .btn-back:hover{
        background:#ff7a00;
        color:white;
    }

    .info-grid{
        display:grid;
        grid-template-columns: repeat(2, 1fr);
        gap:12px 40px;
        font-size:14px;
        margin-top:15px;
    }

    .info-label{
        color:#777;
        font-weight:600;
    }

    .badge{
        padding:5px 12px;
        border-radius:6px;
        font-size:12px;
        font-weight:600;
    }

    .badge-borrowing{
        background:#fff4e8;
        color:#ff7a00;
    }

    .badge-returned{
        background:#e8fff0;
        color:#1c9c47;
    }

    .badge-overdue{
        background:#ffe6e6;
        color:#d60000;
    }

    .borrow-table{
        width:100%;
        border-collapse:collapse;
        margin-top:20px;
    }

    .borrow-table th{
        background:var(--light-orange);
        text-align:left;
        padding:12px;
        font-size:13px;
        color:#444;
    }

    .borrow-table td{
        padding:14px 12px;
        border-top:1px solid #f0f0f0;
        vertical-align:middle;
    }

    .borrow-table tr:hover{
        background:#fff8f1;
    }

    .book-cover{
        width:55px;
        border-radius:5px;
        border:1px solid #eee;
    }

    .book-title{
        font-weight:600;
        color:#333;
    }

    .returned{
        color:#1c9c47;
        font-weight:500;
    }

    .not-returned{
        color:#999;
    }

</style>


<div class="page-wrap">

    <div class="borrow-header">

        <!-- LEFT -->
        <div class="borrow-title">
            📚 Borrow Detail
        </div>

        <!-- 🔥 RIGHT: BACK BUTTON -->
        <a class="btn-back"
           href="${pageContext.request.contextPath}/librarian/borrows">
            <i class="fa-solid fa-arrow-left"></i>
            Back
        </a>

    </div>

    <div class="info-grid">

        <div>
            <span class="info-label">Borrow ID:</span>
            ${borrow.borrowId}
        </div>

        <div>
            <span class="info-label">Borrow Date:</span>
            ${borrow.borrowDate}
        </div>

        <div>
            <span class="info-label">Reader:</span>
            ${borrow.readerName}
        </div>

        <div>
            <span class="info-label">Email:</span>
            ${borrow.readerEmail}
        </div>

        <div>
            <span class="info-label">Status:</span>

            <c:choose>

                <c:when test="${borrow.status == 'BORROWING'}">
                    <span class="badge badge-borrowing">BORROWING</span>
                </c:when>

                <c:when test="${borrow.status == 'RETURNED'}">
                    <span class="badge badge-returned">RETURNED</span>
                </c:when>

                <c:otherwise>
                    <span class="badge badge-overdue">${borrow.status}</span>
                </c:otherwise>

            </c:choose>

        </div>

    </div>

    <table class="borrow-table">

        <tr>
            <th>Book</th>
            <th>Copy Code</th>
            <th>Due Date</th>
            <th>Returned</th>
            <th>Status</th>
        </tr>

        <c:forEach items="${items}" var="i">

            <tr>

                <td>

                    <div style="display:flex;align-items:center;gap:12px">

                        <img src="${pageContext.request.contextPath}/img/book/${i.coverUrl}" class="book-cover">

                        <div class="book-title">
                            ${i.title}
                        </div>

                    </div>

                </td>

                <td>${i.copyCode}</td>

                <td>${i.dueDate}</td>

                <td>

                    <c:choose>

                        <c:when test="${i.returnedAt != null}">
                            <span class="returned">${i.returnedAt}</span>
                        </c:when>

                        <c:otherwise>
                            <span class="not-returned">Not returned</span>
                        </c:otherwise>

                    </c:choose>

                </td>

                <td>

                    <c:choose>

                        <c:when test="${i.status == 'BORROWING'}">
                            <span class="badge badge-borrowing">BORROWING</span>
                        </c:when>

                        <c:when test="${i.status == 'RETURNED'}">
                            <span class="badge badge-returned">RETURNED</span>
                        </c:when>

                        <c:otherwise>
                            <span class="badge badge-overdue">${i.status}</span>
                        </c:otherwise>

                    </c:choose>

                </td>

            </tr>

        </c:forEach>

    </table>

</div>