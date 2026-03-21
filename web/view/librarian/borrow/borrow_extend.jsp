<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
    /* MODAL */

    .modal{
        position:fixed;
        top:0;
        left:0;
        width:100%;
        height:100%;
        background:rgba(0,0,0,0.4);
        display:none;
        justify-content:center;
        align-items:center;
        z-index:999;
    }

    .modal-content{
        background:white;
        padding:20px;
        border-radius:8px;
        width:350px;
        box-shadow:0 5px 20px rgba(0,0,0,0.2);
        animation:fadeIn 0.2s ease;
    }

    @keyframes fadeIn{
        from{
            transform:scale(0.9);
            opacity:0;
        }
        to{
            transform:scale(1);
            opacity:1;
        }
    }
    .extend-wrapper{
        padding:20px;
    }

    .page-title{
        font-size:22px;
        margin-bottom:20px;
        color:#333;
    }

    /* FILTER BAR */

    .filter-bar{
        display:flex;
        justify-content:space-between;
        margin-bottom:15px;
    }

    .filter-bar form{
        display:flex;
        gap:10px;
    }

    .filter-bar input,
    .filter-bar select{
        padding:6px 8px;
        border:1px solid #ddd;
        border-radius:4px;
    }

    .btn-filter{
        background:#ff7a00;
        color:white;
        border:none;
        padding:6px 12px;
        border-radius:4px;
        cursor:pointer;
    }

    /* CARD */

    .extend-card{
        background:white;
        border-radius:8px;
        box-shadow:0 2px 10px rgba(0,0,0,0.05);
        overflow:hidden;
    }

    .extend-table{
        width:100%;
        border-collapse:collapse;
    }

    .extend-table thead{
        background:#ff7a00;
        color:white;
    }

    .extend-table th{
        padding:14px;
        text-align:left;
    }

    .extend-table td{
        padding:14px;
        border-bottom:1px solid #eee;
    }

    .extend-table tr:hover{
        background:#fafafa;
    }

    /* highlight pending */
    .pending-row{
        background:#fffaf0;
    }

    /* STATUS */

    .badge{
        padding:4px 10px;
        border-radius:4px;
        font-size:12px;
        font-weight:600;
    }

    .badge-pending{
        background:#fff3cd;
        color:#856404;
    }

    .badge-approved{
        background:#d4edda;
        color:#155724;
    }

    .badge-rejected{
        background:#f8d7da;
        color:#721c24;
    }

    /* ACTION */

    .actions form{
        display:flex;
        gap:8px;
    }

    .btn{
        border:none;
        padding:6px 12px;
        border-radius:4px;
        font-size:13px;
        cursor:pointer;
    }

    .btn-approve{
        background:#28a745;
        color:white;
    }

    .btn-reject{
        background:#dc3545;
        color:white;
    }

    .btn-approve:hover{
        background:#1e7e34;
    }

    .btn-reject:hover{
        background:#bd2130;
    }

    .processed{
        font-size:12px;
        color:#777;
    }

    /* EMPTY */

    .empty{
        text-align:center;
        padding:25px;
        color:#888;
    }

    /* PAGINATION */

    .pagination{
        display:flex;
        justify-content:center;
        margin-top:20px;
        gap:5px;
    }

    .pagination a{
        padding:6px 12px;
        border:1px solid #ddd;
        text-decoration:none;
        color:#333;
        border-radius:4px;
    }

    .pagination a:hover{
        background:#ff7a00;
        color:white;
    }

    .pagination a.active{
        background:#ff7a00;
        color:white;
        border-color:#ff7a00;
    }

    /* small text */
    .sub{
        font-size:11px;
        color:#888;
    }

</style>

<c:if test="${not empty sessionScope.error}">
    <div style="color:red; margin-bottom:10px;">
        ${sessionScope.error}
    </div>
    <c:remove var="error" scope="session"/>
</c:if>

<div class="extend-wrapper">

    <h2 class="page-title">Borrow Extend Requests</h2>

    <!-- FILTER BAR -->

    <div class="filter-bar">

        <form method="get"
              action="${pageContext.request.contextPath}/librarian/borrow-extend">

            <input type="text"
                   name="search"
                   value="${search}"
                   placeholder="Search book or copy code">

            <select name="status">

                <option value="">All Status</option>

                <option value="PENDING"
                        <c:if test="${status=='PENDING'}">selected</c:if>>
                            Pending
                        </option>

                        <option value="APPROVED"
                        <c:if test="${status=='APPROVED'}">selected</c:if>>
                            Approved
                        </option>

                        <option value="REJECTED"
                        <c:if test="${status=='REJECTED'}">selected</c:if>>
                            Rejected
                        </option>

                </select>

                <button class="btn-filter">
                    Filter
                </button>

            </form>

        </div>


        <div class="extend-card">

            <table class="extend-table">

                <thead>

                    <tr>
                        <th>ID</th>
                        <th>Book</th>
                        <th>Old Due</th>
                        <th>Requested Due</th>
                        <th>Requested At</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>

                </thead>

                <tbody>

                <c:choose>

                    <c:when test="${not empty extendList}">

                        <c:forEach var="e" items="${extendList}">

                            <tr class="${e.status eq 'PENDING' ? 'pending-row' : ''}">

                                <!-- ID -->
                                <td>
                                    <strong>#${e.extendId}</strong><br>
                                    <span class="sub">Item: ${e.borrowItemId}</span>
                                </td>

                                <!-- BOOK + COPY -->
                                <td>
                                    <strong>${e.bookTitle}</strong><br>
                                    <span class="sub">${e.copyCode}</span>
                                </td>

                                <!-- OLD -->
                                <td>
                                    <fmt:formatDate value="${e.oldDueDate}" pattern="dd/MM/yyyy"/>
                                </td>

                                <!-- REQUEST -->
                                <td>
                                    <fmt:formatDate value="${e.requestedDueDate}" pattern="dd/MM/yyyy"/>
                                </td>

                                <!-- TIME -->
                                <td>
                                    <fmt:formatDate value="${e.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>

                                <!-- STATUS -->
                                <td>

                                    <c:choose>

                                        <c:when test="${e.status eq 'PENDING'}">
                                            <span class="badge badge-pending">⏳ Pending</span>
                                        </c:when>

                                        <c:when test="${e.status eq 'APPROVED'}">
                                            <span class="badge badge-approved">✔ Approved</span>
                                        </c:when>

                                        <c:when test="${e.status eq 'REJECTED'}">
                                            <span class="badge badge-rejected">✖ Rejected</span>
                                        </c:when>

                                    </c:choose>

                                </td>

                                <!-- ACTION -->
                                <td class="actions">

                                    <c:if test="${e.status eq 'PENDING'}">

                                        <!-- APPROVE -->
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/librarian/process-extend"
                                              style="display:inline">

                                            <input type="hidden" name="extendId" value="${e.extendId}">
                                            <input type="hidden" name="action" value="approve">

                                            <button class="btn btn-approve"
                                                    onclick="return confirm('Approve this extend request?')">
                                                ✔ Approve
                                            </button>

                                        </form>

                                        <!-- REJECT BUTTON -->
                                        <button class="btn btn-reject"
                                                onclick="openRejectModal(${e.extendId})">
                                            ✖ Reject
                                        </button>

                                    </c:if>

                                    <c:if test="${e.status ne 'PENDING'}">
                                        <span class="processed">Processed</span>
                                    </c:if>

                                </td>
                            </tr>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <tr>
                            <td colspan="7" class="empty">
                                No extend requests found
                            </td>
                        </tr>

                    </c:otherwise>

                </c:choose>

            </tbody>

        </table>

    </div>


    <!-- PAGINATION -->

    <div class="pagination">

        <c:forEach begin="1" end="${totalPages}" var="i">

            <c:url var="pageUrl" value="/librarian/borrow-extend">

                <c:param name="page" value="${i}"/>

                <c:if test="${not empty search}">
                    <c:param name="search" value="${search}"/>
                </c:if>

                <c:if test="${not empty status}">
                    <c:param name="status" value="${status}"/>
                </c:if>

            </c:url>

            <a href="${pageUrl}"
               class="${i==currentPage?'active':''}">
                ${i}
            </a>

        </c:forEach>

    </div>

</div>
<div id="rejectModal" class="modal">

    <div class="modal-content">

        <form method="post"
              action="${pageContext.request.contextPath}/librarian/process-extend"
              onsubmit="return validateRejectModal()">

            <input type="hidden" name="extendId" id="rejectExtendId">
            <input type="hidden" name="action" value="reject">

            <h3 style="margin-bottom:10px;">Reject Extend Request</h3>

            <label>Reason (required)</label>

            <textarea name="note"
                      id="rejectNote"
                      placeholder="Enter reason..."
                      required
                      style="width:100%; height:80px; margin-top:5px;"></textarea>

            <br><br>

            <button class="btn btn-reject">
                Confirm Reject
            </button>

            <button type="button"
                    onclick="closeRejectModal()"
                    style="margin-left:10px;">
                Cancel
            </button>

        </form>

    </div>

</div>
<script>

    function openRejectModal(extendId) {
        document.getElementById("rejectExtendId").value = extendId;
        document.getElementById("rejectNote").value = "";
        document.getElementById("rejectModal").style.display = "flex";

        // focus textarea
        setTimeout(() => {
            document.getElementById("rejectNote").focus();
        }, 100);
    }

    function closeRejectModal() {
        document.getElementById("rejectModal").style.display = "none";
    }

    function validateRejectModal() {

        let note = document.getElementById("rejectNote").value.trim();

        if (note === "") {
            alert("Please enter a reason!");
            return false;
        }

        if (note.length < 5) {
            alert("Reason must be at least 5 characters!");
            return false;
        }

        return confirm("Confirm reject?");
    }

// click outside → close
    window.onclick = function (event) {
        let modal = document.getElementById("rejectModal");
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }

</script>