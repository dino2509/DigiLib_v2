<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

    .borrow-wrapper{
        padding:20px;
    }

    .page-title{
        font-size:22px;
        margin-bottom:20px;
    }

    /* CARD */

    .table-box{
        background:white;
        border-radius:8px;
        box-shadow:0 2px 10px rgba(0,0,0,0.05);
        overflow:hidden;
    }

    .borrow-table{
        width:100%;
        border-collapse:collapse;
    }

    .borrow-table thead{
        background:#ff7a00;
        color:white;
    }

    .borrow-table th,
    .borrow-table td{
        padding:12px;
        border-bottom:1px solid #eee;
    }

    .borrow-table tr:hover{
        background:#fafafa;
    }

    /* zebra */
    .borrow-table tbody tr:nth-child(even){
        background:#fcfcfc;
    }

    /* index */
    .index{
        font-weight:600;
        color:#555;
    }

    /* status */

    .status{
        padding:4px 10px;
        border-radius:4px;
        font-size:12px;
        font-weight:600;
    }

    .borrowing{
        background:#fff3cd;
        color:#856404;
    }
    .returned{
        background:#d4edda;
        color:#155724;
    }

    /* warnings */

    .warning7{
        color:#ff9800;
        font-weight:600;
    }
    .warning3{
        color:#ff5722;
        font-weight:600;
    }
    .warning1{
        color:#e53935;
        font-weight:700;
    }

    .overdue{
        color:#b71c1c;
        font-weight:700;
    }

    .fine-warning{
        color:#b71c1c;
        font-size:12px;
    }

    /* extend status */

    .extend-status{
        font-size:12px;
        font-weight:600;
    }

    .extend-pending{
        color:#ff9800;
    }
    .extend-approved{
        color:green;
    }
    .extend-rejected{
        color:#d32f2f;
    }

    /* buttons */

    .btn-extend{
        background:#ff7a00;
        color:white;
        border:none;
        padding:6px 12px;
        border-radius:4px;
        cursor:pointer;
        margin-top:4px;
    }

    .btn-extend:hover{
        background:#e56a00;
    }

    /* modal */

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
    }

    .modal-content{
        background:white;
        padding:20px;
        border-radius:8px;
        width:320px;
    }

    /* pagination */

    .pagination{
        text-align:center;
        padding:15px;
    }

    .pagination a{
        padding:6px 10px;
        margin:2px;
        border:1px solid #ddd;
        text-decoration:none;
        color:#333;
    }

    .pagination a.active{
        background:#ff7a00;
        color:white;
        border-color:#ff7a00;
    }

</style>

<div class="borrow-wrapper">

    <h2 class="page-title">My Borrowed Books</h2>

    <div class="table-box">

        <table class="borrow-table">

            <thead>
                <tr>
                    <th>#</th>
                    <th>Book</th>
                    <th>Copy</th>
                    <th>Due Date</th>
                    <th>Remaining</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

            <c:choose>

                <c:when test="${not empty borrowedBooks}">

                    <c:forEach var="b" items="${borrowedBooks}" varStatus="loop">

                        <fmt:formatDate value="${b.dueDate}" pattern="yyyy-MM-dd" var="dueDateStr"/>

                        <tr>

                            <!-- INDEX -->
                            <td class="index">
                                ${loop.index + 1 + (currentPage-1)*10}
                            </td>

                            <!-- BOOK -->
                            <td>
                                <strong>${b.bookTitle}</strong>
                            </td>

                            <!-- COPY -->
                            <td>${b.copyCode}</td>

                            <!-- DATE -->
                            <td>${dueDateStr}</td>

                            <!-- REMAIN -->
                            <td>

                        <c:choose>

                            <c:when test="${b.remainingDays < 0}">
                                <span class="overdue">OVERDUE</span><br>
                                <span class="fine-warning">Fine may apply</span>
                            </c:when>

                            <c:when test="${b.remainingDays == 0}">
                                <span class="warning1">Due today</span>
                            </c:when>

                            <c:when test="${b.remainingDays <= 3}">
                                <span class="warning3">${b.remainingDays} days left</span>
                            </c:when>

                            <c:when test="${b.remainingDays <= 7}">
                                <span class="warning7">${b.remainingDays} days left</span>
                            </c:when>

                            <c:otherwise>
                                ${b.remainingDays} days
                            </c:otherwise>

                        </c:choose>

                        </td>

                        <!-- STATUS -->
                        <td>

                        <c:choose>

                            <c:when test="${b.status eq 'BORROWING'}">
                                <span class="status borrowing">Borrowing</span>
                            </c:when>

                            <c:when test="${b.status eq 'RETURNED'}">
                                <span class="status returned">Returned</span>
                            </c:when>

                            <c:otherwise>${b.status}</c:otherwise>

                        </c:choose>

                        </td>

                        <!-- ACTION -->
                        <td>

                        <c:choose>

                            <c:when test="${b.extendStatus eq 'PENDING'}">
                                <span class="extend-status extend-pending">
                                    ⏳ Extend Requested
                                </span>
                            </c:when>

                            <c:when test="${b.extendStatus eq 'APPROVED'}">
                                <span class="extend-status extend-approved">
                                    ✔ Extended
                                </span>
                            </c:when>

                            <c:when test="${b.extendStatus eq 'REJECTED'}">

                                <span class="extend-status extend-rejected">
                                    ✖ Rejected
                                </span>

                                <c:if test="${b.status eq 'BORROWING' and b.remainingDays >= 0}">
                                    <br>
                                    <button class="btn-extend"
                                            onclick="openExtendDialog(${b.borrowItemId}, '${dueDateStr}')">
                                        Extend Again
                                    </button>
                                </c:if>

                            </c:when>

                            <c:when test="${b.remainingDays < 0}">
                                <span class="fine-warning">Penalty pending</span>
                            </c:when>

                            <c:when test="${b.status eq 'BORROWING' and b.remainingDays >=0 and b.remainingDays <=7}">
                                <button class="btn-extend"
                                        onclick="openExtendDialog(${b.borrowItemId}, '${dueDateStr}')">
                                    Extend
                                </button>
                            </c:when>

                            <c:otherwise>-</c:otherwise>

                        </c:choose>

                        </td>

                        </tr>

                    </c:forEach>

                </c:when>

                <c:otherwise>

                    <tr>
                        <td colspan="7" style="text-align:center;padding:20px">
                            You have no borrowed books
                        </td>
                    </tr>

                </c:otherwise>

            </c:choose>

            </tbody>

        </table>

    </div>

    <div class="pagination">

        <c:if test="${totalPages > 1}">

            <c:forEach begin="1" end="${totalPages}" var="i">

                <a href="${pageContext.request.contextPath}/reader/borrowed?page=${i}"
                   class="${i == currentPage ? 'active' : ''}">
                    ${i}
                </a>

            </c:forEach>

        </c:if>

    </div>

</div>

<!-- MODAL -->

<div id="extendDialog" class="modal">

    <div class="modal-content">

        <form method="post"
              action="${pageContext.request.contextPath}/reader/request-extend">

            <input type="hidden"
                   name="borrowItemId"
                   id="extendBorrowItemId">

            <label>Choose new due date (max 7 days)</label>

            <input type="date"
                   name="requestedDate"
                   id="requestedDate"
                   required>

            <br><br>

            <button type="submit" class="btn-extend">
                Submit Request
            </button>

            <button type="button"
                    onclick="closeDialog()"
                    style="margin-left:10px">
                Cancel
            </button>

        </form>

    </div>

</div>

<script>

    function openExtendDialog(borrowItemId, dueDate) {

        document.getElementById("extendBorrowItemId").value = borrowItemId;

        let due = new Date(dueDate);

        let minDate = new Date(due);
        minDate.setDate(minDate.getDate() + 1);

        let maxDate = new Date(due);
        maxDate.setDate(maxDate.getDate() + 7);

        let input = document.getElementById("requestedDate");

        input.value = "";
        input.min = minDate.toISOString().split('T')[0];
        input.max = maxDate.toISOString().split('T')[0];

        document.getElementById("extendDialog").style.display = "flex";
    }

    function closeDialog() {
        document.getElementById("extendDialog").style.display = "none";
    }

    window.onclick = function (event) {

        let modal = document.getElementById("extendDialog");

        if (event.target === modal) {
            modal.style.display = "none";
        }

    }

</script>