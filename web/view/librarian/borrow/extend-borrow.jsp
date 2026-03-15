<%@page contentType="text/html;charset=UTF-8"%>

<style>

    .extend-box{
        max-width:500px;
        margin:auto;
        background:white;
        padding:25px;
        border-radius:10px;
        box-shadow:0 4px 10px rgba(0,0,0,0.08);
    }

    .extend-title{
        font-size:20px;
        font-weight:600;
        color:#ff7a00;
        margin-bottom:15px;
    }

    .form-group{
        margin-bottom:15px;
    }

    .form-group label{
        display:block;
        font-weight:500;
        margin-bottom:5px;
    }

    .form-group input{
        width:100%;
        padding:8px;
        border:1px solid #ddd;
        border-radius:4px;
    }

    .btn-submit{
        background:#ff7a00;
        border:none;
        padding:10px 14px;
        color:white;
        border-radius:5px;
        cursor:pointer;
    }

</style>


<div class="extend-box">

    <div class="extend-title">
        Extend Borrow
    </div>

    <form method="post"
          action="${pageContext.request.contextPath}/librarian/extend-borrow">

        <input type="hidden" name="borrowItemId" value="${borrowItemId}">
        <input type="hidden" name="borrowId" value="${param.borrowId}">

        <div class="form-group">

            <label>New Due Date</label>

            <input type="date"
                   name="newDueDate"
                   required>

        </div>

        <button class="btn-submit">
            Extend
        </button>

    </form>

</div>