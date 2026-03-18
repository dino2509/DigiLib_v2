<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="page-header">

    <h2>Borrow Request #${request.requestId}</h2>

    <span class="status-badge ${request.status}">
        ${request.status}
    </span>

</div>

<div class="request-card">

    <div class="request-info">

        <div>
            <b>Reader</b>
            <span>${request.readerName}</span>
        </div>

        <div>
            <b>Requested At</b>
            <span>
                <fmt:formatDate value="${request.requestedAt}" pattern="yyyy-MM-dd HH:mm"/>
            </span>
        </div>

    </div>

</div>

<h3 class="section-title">Requested Books</h3>

<div class="card">

    <table>

        <thead>
            <tr>
                <th>Book</th>
                <th>Author</th>
                <th>Category</th>
                <th>ISBN</th>
                <th>Pages</th>
                <th>Quantity</th>
            </tr>
        </thead>

        <tbody>

            <c:forEach var="item" items="${items}">

                <tr>

                    <td class="book-cell">

                        <img src="${pageContext.request.contextPath}/img/book/${item.coverUrl}" class="book-cover">

                        <div>
                            <div class="book-title">${item.bookTitle}</div>
                        </div>

                    </td>

                    <td>${item.authorName}</td>
                    <td>${item.categoryName}</td>
                    <td>${item.isbn}</td>
                    <td>${item.totalPages}</td>

                    <td>
                        <span class="qty">${item.quantity}</span>
                    </td>

                </tr>

            </c:forEach>

        </tbody>

    </table>

</div>

<div class="actions">

    <c:if test="${request.status == 'PENDING'}">

        <button class="btn approve" onclick="openApproveModal()">
            <i class="fa-solid fa-check"></i> Approve
        </button>

        <button class="btn reject" onclick="openRejectModal()">
            <i class="fa-solid fa-xmark"></i> Reject
        </button>

    </c:if>

    <a class="btn back"
       href="${pageContext.request.contextPath}/librarian/requests">
        ← Back
    </a>

</div>

<!-- ================= APPROVE MODAL ================= -->

<div id="approveModal" class="modal">

    <div class="modal-content">

        <h3>Approve Borrow Request</h3>

        <form method="post"
              action="${pageContext.request.contextPath}/librarian/request-approve">

            <!-- CORE -->
            <input type="hidden" name="requestId" value="${request.requestId}">

            <!-- BOOK DATA (multi support) -->
            <c:forEach var="item" items="${items}">
                <input type="hidden" name="titles" value="${item.bookTitle}">
                <input type="hidden" name="isbns" value="${item.isbn}">
            </c:forEach>

            <label>Due Date</label>
            <input type="date" name="dueDate" required>

            <label>Note</label>
            <textarea name="note" rows="3" placeholder="Optional note"></textarea>

            <div class="modal-actions">

                <button type="submit" class="btn approve">
                    Confirm
                </button>

                <button type="button" class="btn cancel" onclick="closeApproveModal()">
                    Cancel
                </button>

            </div>

        </form>

    </div>

</div>

<!-- ================= REJECT MODAL ================= -->

<div id="rejectModal" class="modal">

    <div class="modal-content">

        <h3>Reject Borrow Request</h3>

        <form method="post"
              action="${pageContext.request.contextPath}/librarian/request-reject">

            <!-- CORE -->
            <input type="hidden" name="requestId" value="${request.requestId}">

            <!-- BOOK DATA -->
            <c:forEach var="item" items="${items}">
                <input type="hidden" name="titles" value="${item.bookTitle}">
                <input type="hidden" name="isbns" value="${item.isbn}">
            </c:forEach>

            <label>Reason</label>
            <textarea name="note"
                      rows="4"
                      required
                      placeholder="Explain why this request is rejected"></textarea>

            <div class="modal-actions">

                <button type="submit" class="btn reject">
                    Reject
                </button>

                <button type="button" class="btn cancel" onclick="closeRejectModal()">
                    Cancel
                </button>

            </div>

        </form>

    </div>

</div>

<!-- ================= STYLE ================= -->

<style>
    .page-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:20px;
    }

    .status-badge{
        padding:6px 12px;
        border-radius:20px;
        font-size:13px;
        font-weight:bold;
    }

    .PENDING{
        background:#fff3cd;
        color:#ff9800;
    }
    .APPROVED{
        background:#d4edda;
        color:#28a745;
    }
    .REJECTED{
        background:#f8d7da;
        color:#dc3545;
    }

    .request-card{
        background:white;
        padding:20px;
        border-radius:8px;
        box-shadow:0 3px 8px rgba(0,0,0,0.08);
        margin-bottom:20px;
    }

    .request-info{
        display:flex;
        gap:40px;
        font-size:14px;
    }

    .card{
        background:white;
        border-radius:8px;
        box-shadow:0 2px 8px rgba(0,0,0,0.08);
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
    }
    td{
        padding:12px;
        border-bottom:1px solid #eee;
    }
    tr:hover{
        background:#fafafa;
    }

    .book-cell{
        display:flex;
        gap:10px;
        align-items:center;
    }
    .book-cover{
        width:50px;
        height:70px;
        object-fit:cover;
        border-radius:4px;
    }
    .book-title{
        font-weight:bold;
    }

    .qty{
        background:#eee;
        padding:4px 8px;
        border-radius:4px;
    }

    .actions{
        margin-top:20px;
    }

    .btn{
        padding:8px 14px;
        border-radius:4px;
        border:none;
        cursor:pointer;
        text-decoration:none;
        margin-right:10px;
        display:inline-flex;
        align-items:center;
        gap:5px;
    }

    .approve{
        background:#28a745;
        color:white;
    }
    .reject{
        background:#dc3545;
        color:white;
    }
    .back{
        background:#777;
        color:white;
    }
    .cancel{
        background:#999;
        color:white;
    }

    .modal{
        display:none;
        position:fixed;
        top:0;
        left:0;
        width:100%;
        height:100%;
        background:rgba(0,0,0,0.4);
        justify-content:center;
        align-items:center;
    }

    .modal-content{
        background:white;
        padding:20px;
        border-radius:8px;
        width:420px;
    }

    .modal-content input,
    .modal-content textarea{
        width:100%;
        padding:8px;
        margin-bottom:10px;
    }

    .modal-actions{
        text-align:right;
    }
</style>

<!-- ================= SCRIPT ================= -->

<script>
    function openApproveModal() {
        document.getElementById("approveModal").style.display = "flex";
    }
    function closeApproveModal() {
        document.getElementById("approveModal").style.display = "none";
    }
    function openRejectModal() {
        document.getElementById("rejectModal").style.display = "flex";
    }
    function closeRejectModal() {
        document.getElementById("rejectModal").style.display = "none";
    }
</script>