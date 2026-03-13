<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<h2>Borrow Request Detail</h2>

<div class="info-box">

    <p><b>Request ID:</b> #${request.requestId}</p>

    <p>
        <b>Reader:</b>
        <i class="fa-solid fa-user"></i>
        ${request.readerName}
    </p>

    <p>
        <b>Date:</b>
        <fmt:formatDate value="${request.requestedAt}" pattern="yyyy-MM-dd HH:mm"/>
    </p>

    <p>
        <b>Status:</b>
        ${request.status}
    </p>

</div>

<h3>Books</h3>

<table class="book-table">

    <thead>
        <tr>
            <th>Book</th>
            <th>Quantity</th>
        </tr>
    </thead>

    <tbody>

        <c:forEach var="item" items="${items}">
            <tr>
                <td>${item.bookTitle}</td>
                <td>${item.quantity}</td>
            </tr>
        </c:forEach>

    </tbody>

</table>


<div class="actions">

    <button class="btn approve" onclick="openApproveModal()">
        Approve
    </button>

    <button class="btn reject" onclick="openRejectModal()">
        Reject
    </button>

    <a class="btn back"
       href="${pageContext.request.contextPath}/librarian/requests">
        Back
    </a>

</div>


<!-- APPROVE MODAL -->

<div id="approveModal" class="modal">

    <div class="modal-content">

        <h3>Approve Borrow Request</h3>

        <form method="post"
              action="${pageContext.request.contextPath}/librarian/request-approve">

            <input type="hidden" name="requestId" value="${request.requestId}">

            <label>Due Date</label>
            <input type="date" name="dueDate" required>

            <label>Decision Note</label>
            <textarea name="note" rows="3"></textarea>

            <div class="modal-actions">

                <button type="submit" class="btn approve">
                    Confirm Approve
                </button>

                <button type="button" class="btn cancel"
                        onclick="closeApproveModal()">
                    Cancel
                </button>

            </div>

        </form>

    </div>

</div>



<!-- REJECT MODAL -->

<div id="rejectModal" class="modal">

    <div class="modal-content">

        <h3>Reject Borrow Request</h3>

        <form method="post"
              action="${pageContext.request.contextPath}/librarian/request-reject">

            <input type="hidden" name="requestId" value="${request.requestId}">

            <label>Reason for rejection</label>

            <textarea name="note"
                      rows="4"
                      required
                      placeholder="Enter reason for rejecting this request"></textarea>

            <div class="modal-actions">

                <button type="submit" class="btn reject">
                    Confirm Reject
                </button>

                <button type="button"
                        class="btn cancel"
                        onclick="closeRejectModal()">
                    Cancel
                </button>

            </div>

        </form>

    </div>

</div>



<style>

    .info-box{
        background:white;
        padding:20px;
        border-radius:6px;
        box-shadow:0 2px 6px rgba(0,0,0,0.05);
        margin-bottom:20px;
    }

    .book-table{
        width:100%;
        border-collapse:collapse;
        background:white;
    }

    .book-table th{
        background:#ff7a00;
        color:white;
        padding:10px;
    }

    .book-table td{
        padding:10px;
        border-bottom:1px solid #eee;
    }

    .actions{
        margin-top:20px;
    }

    .btn{
        padding:8px 14px;
        border-radius:4px;
        text-decoration:none;
        margin-right:10px;
        cursor:pointer;
    }

    .approve{
        background:#28a745;
        color:white;
        border:none;
    }

    .reject{
        background:#dc3545;
        color:white;
        border:none;
    }

    .back{
        background:#999;
        color:white;
    }

    .cancel{
        background:#666;
        color:white;
        border:none;
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
        border-radius:6px;
        width:400px;
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