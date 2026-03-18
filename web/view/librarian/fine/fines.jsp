<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    .fine-container {
        padding: 20px;
    }

    .page-title {
        font-size: 26px;
        font-weight: bold;
        color: #ff6600;
        margin-bottom: 20px;
    }

    /* FILTER */
    .filter-box {
        background: #fff7f0;
        border: 1px solid #ffd9b3;
        border-radius: 10px;
        padding: 15px;
        margin-bottom: 20px;
    }

    .filter-box input,
    .filter-box select {
        padding: 8px;
        border-radius: 6px;
        border: 1px solid #ccc;
        margin-right: 10px;
    }

    .btn-search {
        background-color: #ff6600;
        color: white;
        border: none;
        padding: 8px 14px;
        border-radius: 6px;
        cursor: pointer;
    }

    .btn-search:hover {
        background-color: #e65c00;
    }

    /* TABLE */
    .fine-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 10px;
        overflow: hidden;
    }

    .fine-table th {
        background: #ff6600;
        color: white;
        padding: 10px;
        text-align: left;
    }

    .fine-table td {
        padding: 10px;
        border-bottom: 1px solid #eee;
    }

    .fine-table tr:hover {
        background-color: #fff3e6;
    }

    /* STATUS */
    .status {
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: bold;
    }

    .status-paid {
        background: #d4edda;
        color: #155724;
    }

    .status-unpaid {
        background: #f8d7da;
        color: #721c24;
    }

    /* ACTION */
    .btn-action {
        padding: 5px 10px;
        border-radius: 5px;
        text-decoration: none;
        font-size: 13px;
    }

    .btn-view {
        background: #3498db;
        color: white;
    }

    .btn-pay {
        background: #ff6600;
        color: white;
    }

    .btn-view:hover {
        background: #2980b9;
    }

    .btn-pay:hover {
        background: #e65c00;
    }

    /* PAGINATION */
    .pagination {
        margin-top: 20px;
        text-align: center;
    }

    .pagination a {
        margin: 0 5px;
        padding: 6px 12px;
        border: 1px solid #ff6600;
        border-radius: 5px;
        text-decoration: none;
        color: #ff6600;
    }

    .pagination a.active {
        background: #ff6600;
        color: white;
    }

    .pagination a:hover {
        background: #ff6600;
        color: white;
    }

</style>

<div class="fine-container">

    <div class="page-title">📄 Fine Management</div>

    <!-- FILTER -->
    <form method="get" action="fines" class="filter-box">
        <input type="text" name="readerId" placeholder="Reader ID"
               value="${readerId}" />

        <select name="status">
            <option value="">All Status</option>
            <option value="UNPAID" ${status=='UNPAID'?'selected':''}>Unpaid</option>
            <option value="PAID" ${status=='PAID'?'selected':''}>Paid</option>
        </select>

        <select name="typeId">
            <option value="">All Types</option>
            <option value="1" ${typeId=='1'?'selected':''}>Overdue</option>
            <option value="2" ${typeId=='2'?'selected':''}>Damage</option>
        </select>

        <button type="submit" class="btn-search">Search</button>
    </form>

    <!-- TABLE -->
    <table class="fine-table">
        <tr>
            <th>ID</th>
            <th>Reader</th>
            <th>Type</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Created</th>
            <th>Action</th>
        </tr>

        <c:forEach var="f" items="${fines}">
            <tr>
                <td>${f.fineId}</td>
                <td>${f.readerName}</td>
                <td>${f.fineTypeName}</td>
                <td>${f.amount} VND</td>

                <td>
            <c:choose>
                <c:when test="${f.status == 'PAID'}">
                    <span class="status status-paid">PAID</span>
                </c:when>
                <c:otherwise>
                    <span class="status status-unpaid">UNPAID</span>
                </c:otherwise>
            </c:choose>
            </td>

            <td>${f.createdAt}</td>

            <td>
                <a href="fine-detail?id=${f.fineId}" class="btn-action btn-view">View</a>

            <c:if test="${f.status == 'UNPAID'}">
                <a href="pay-fine?id=${f.fineId}" class="btn-action btn-pay">Pay</a>
            </c:if>
            </td>
            </tr>
        </c:forEach>
    </table>

    <!-- PAGINATION -->
    <c:set var="query"
           value="&readerId=${readerId}&status=${status}&typeId=${typeId}" />

    <div class="pagination">
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="fines?page=${i}${query}"
               class="${i == page ? 'active' : ''}">
                ${i}
            </a>
        </c:forEach>
    </div>

</div>