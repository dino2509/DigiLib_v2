<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    .fine-detail-container {
        padding: 20px;
    }

    .title {
        font-size: 26px;
        font-weight: bold;
        color: #ff6600;
        margin-bottom: 20px;
    }

    .card {
        background: #fff7f0;
        border: 1px solid #ffd9b3;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
    }

    .row {
        margin-bottom: 10px;
    }

    .label {
        font-weight: bold;
        color: #333;
        width: 180px;
        display: inline-block;
    }

    .value {
        color: #555;
    }

    .status {
        padding: 5px 12px;
        border-radius: 12px;
        font-weight: bold;
    }

    .paid {
        background: #d4edda;
        color: #155724;
    }

    .unpaid {
        background: #f8d7da;
        color: #721c24;
    }

    .btn {
        padding: 8px 14px;
        border-radius: 6px;
        text-decoration: none;
        color: white;
        margin-right: 10px;
    }

    .btn-back {
        background: gray;
    }

    .btn-pay {
        background: #ff6600;
    }

    .btn-pay:hover {
        background: #e65c00;
    }
</style>

<div class="fine-detail-container">

    <div class="title">📄 Fine Detail</div>

    <div class="card">

        <div class="row">
            <span class="label">Fine ID:</span>
            <span class="value">${fine.fineId}</span>
        </div>

        <div class="row">
            <span class="label">Reader:</span>
            <span class="value">${fine.readerName}</span>
        </div>

        <div class="row">
            <span class="label">Book:</span>
            <span class="value">${fine.bookTitle}</span>
        </div>

        <div class="row">
            <span class="label">Fine Type:</span>
            <span class="value">${fine.fineTypeName}</span>
        </div>

        <div class="row">
            <span class="label">Amount:</span>
            <span class="value">${fine.amount} VND</span>
        </div>

        <div class="row">
            <span class="label">Reason:</span>
            <span class="value">${fine.reason}</span>
        </div>

        <div class="row">
            <span class="label">Status:</span>
            <span class="value">
                <c:choose>
                    <c:when test="${fine.status == 'PAID'}">
                        <span class="status paid">PAID</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status unpaid">UNPAID</span>
                    </c:otherwise>
                </c:choose>
            </span>
        </div>

        <div class="row">
            <span class="label">Created At:</span>
            <span class="value">${fine.createdAt}</span>
        </div>

        <div class="row">
            <span class="label">Paid At:</span>
            <span class="value">${fine.paidAt}</span>
        </div>

        <div class="row">
            <span class="label">Handled By:</span>
            <span class="value">${fine.employeeName}</span>
        </div>

    </div>

    <!-- ACTION -->
    <a href="fines" class="btn btn-back">← Back</a>

    <c:if test="${fine.status == 'UNPAID'}">
        <a href="pay-fine?id=${fine.fineId}" class="btn btn-pay">💳 Pay Fine</a>
    </c:if>

</div>