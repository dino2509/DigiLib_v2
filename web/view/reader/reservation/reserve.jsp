<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>.form-group{
        margin-bottom:15px;
    }

    .form-control{
        padding:8px;
        width:250px;
    }

    .btn{
        padding:8px 14px;
        border:none;
        border-radius:4px;
        cursor:pointer;
    }

    .btn-primary{
        background:#3498db;
        color:white;
    }

    .btn-secondary{
        background:#777;
        color:white;
    }</style>
<h2>Reserve Book</h2>

<form method="post"
      action="${pageContext.request.contextPath}/reader/reserve">

    <input type="hidden" name="bookId" value="${bookId}"/>

    <div class="form-group">
        <label>Quantity</label>
        <input type="number"
               name="quantity"
               value="1"
               min="1"
               required
               class="form-control"/>
    </div>

    <br>

    <button type="submit" class="btn btn-primary">
        Reserve
    </button>

    <button type="button"
            class="btn btn-secondary"
            onclick="history.back()">
        Cancel
    </button>

</form>

