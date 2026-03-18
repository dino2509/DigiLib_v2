<%@page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

    .pay-wrapper{
        max-width:600px;
        margin:40px auto;
        background:white;
        padding:25px;
        border-radius:10px;
        box-shadow:0 4px 12px rgba(0,0,0,0.08);
    }

    .title{
        font-size:22px;
        font-weight:600;
        color:#ff7a00;
        margin-bottom:20px;
    }

    .info{
        margin-bottom:15px;
        font-size:14px;
    }

    .label{
        font-weight:600;
        color:#666;
    }

    .amount{
        font-size:20px;
        font-weight:bold;
        color:#dc3545;
    }

    .form-group{
        margin-top:20px;
    }

    select{
        width:100%;
        padding:10px;
        border-radius:5px;
        border:1px solid #ddd;
    }

    .actions{
        margin-top:25px;
        display:flex;
        justify-content:space-between;
        gap:10px;
    }

    .btn{
        padding:10px 16px;
        border:none;
        border-radius:6px;
        cursor:pointer;
        text-decoration:none;
        font-size:14px;
    }

    .btn-back{
        background:#eee;
        color:#333;
    }

    .btn-back:hover{
        background:#ddd;
    }

    .btn-pay{
        background:#ff7a00;
        color:white;
    }

    .btn-pay:hover{
        background:#e66a00;
    }

</style>

<div class="pay-wrapper">

    <div class="title">
        💳 Pay Fine
    </div>

    <div class="info">
        <span class="label">Fine ID:</span>
        ${fine.fineId}
    </div>

    <div class="info">
        <span class="label">Reader ID:</span>
        ${fine.readerId}
    </div>

    <div class="info">
        <span class="label">Reason:</span>
        ${fine.reason}
    </div>

    <div class="info amount">
        Amount: 
        <fmt:formatNumber value="${fine.amount}" type="number"/> VND
    </div>

    <!-- 🔥 FORM POST -->
    <form method="post"
          action="${pageContext.request.contextPath}/librarian/pay-fine-payment">

        <!-- hidden -->
        <input type="hidden" name="id" value="${fine.fineId}"/>

        <div class="form-group">
            <label class="label">Payment Method</label>
            <select name="paymentMethod" required>
                <option value="">-- Select method --</option>
                <option value="CASH">Cash</option>
                <option value="CARD">Card</option>
                <option value="TRANSFER">Bank Transfer</option>
            </select>
        </div>

        <div class="actions">

            <!-- BACK -->
            <a href="javascript:history.back()" class="btn btn-back">
                ← Back
            </a>

            <!-- PAY -->
            <button type="submit" class="btn btn-pay">
                Confirm Payment
            </button>

        </div>

    </form>

</div>