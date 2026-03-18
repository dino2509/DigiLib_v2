<%@page contentType="text/html" pageEncoding="UTF-8"%>

<style>
    .page-container{
        display:flex;
        justify-content:center;
        margin-top:40px;
    }

    .card{
        background:#fff;
        padding:30px;
        border-radius:16px;
        width:400px;
        box-shadow:0 8px 20px rgba(0,0,0,0.08);
        border:1px solid #f3f4f6;
    }

    /* header */
    .card-title{
        font-size:22px;
        font-weight:600;
        margin-bottom:6px;
        color:#111827;
    }

    .card-sub{
        font-size:14px;
        color:#6b7280;
        margin-bottom:20px;
    }

    /* form */
    .form-group{
        margin-bottom:18px;
    }

    .form-label{
        display:block;
        font-weight:500;
        margin-bottom:6px;
        color:#374151;
    }

    .form-control{
        width:100%;
        padding:10px;
        border-radius:8px;
        border:1px solid #d1d5db;
        transition:0.2s;
    }

    .form-control:focus{
        border-color:#f97316;
        outline:none;
        box-shadow:0 0 0 2px #fed7aa;
    }

    /* buttons */
    .btn-group{
        display:flex;
        gap:10px;
        margin-top:10px;
    }

    .btn{
        flex:1;
        padding:10px;
        border:none;
        border-radius:10px;
        cursor:pointer;
        font-weight:600;
        transition:0.2s;
    }

    .btn-primary{
        background:#f97316;
        color:white;
    }

    .btn-primary:hover{
        background:#ea580c;
    }

    .btn-secondary{
        background:#e5e7eb;
    }

    .btn-secondary:hover{
        background:#d1d5db;
    }
</style>

<div class="page-container">

    <div class="card">

        <div class="card-title">📚 Reserve Book</div>
        <div class="card-sub">
            Enter the quantity you want to reserve
        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/reader/reserve">

            <input type="hidden" name="bookId" value="${bookId}"/>

            <div class="form-group">
                <label class="form-label">Quantity</label>

                <input type="number"
                       name="quantity"
                       value="1"
                       min="1"
                       required
                       class="form-control"/>
            </div>

            <div class="btn-group">

                <button type="submit" class="btn btn-primary">
                    ✅ Reserve
                </button>

                <button type="button"
                        class="btn btn-secondary"
                        onclick="history.back()">
                    Cancel
                </button>

            </div>

        </form>

    </div>

</div>