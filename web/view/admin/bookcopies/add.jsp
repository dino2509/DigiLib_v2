<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    .add-wrapper{
        max-width:760px;
        margin:auto;
    }

    .add-card{
        background:#fff;
        padding:32px 36px;
        border-radius:18px;
        border:1px solid #fed7aa;
        box-shadow:0 16px 36px rgba(0,0,0,0.08);
    }

    .add-title{
        text-align:center;
        font-size:24px;
        font-weight:700;
        color:#ea580c;
        margin-bottom:26px;
    }

    label{
        font-weight:600;
        margin-bottom:6px;
    }

    .form-control,
    .form-select{
        border-radius:10px;
        padding:10px 12px;
        margin-bottom:16px;
    }

    .book-info{
        background:#fff7ed;
        padding:12px;
        border-radius:10px;
        font-size:13px;
        margin-bottom:18px;
        color:#9a3412;
    }

    .form-actions{
        display:flex;
        justify-content:space-between;
        margin-top:20px;
        padding-top:16px;
        border-top:1px dashed #fed7aa;
    }

    .btn-save{
        background:linear-gradient(135deg,#f97316,#ea580c);
        color:white;
        border:none;
        padding:10px 28px;
        border-radius:999px;
        font-weight:600;
    }

    .btn-back{
        color:#ea580c;
        text-decoration:none;
        font-weight:600;
    }

    .copy-preview{
        font-size:13px;
        color:#6b7280;
    }

</style>


<div class="add-wrapper">

    <div class="add-card">

        <div class="add-title">
            📚 Add Book Copies
        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/bookcopies/add">


            <!-- BOOK SELECT -->

            <label>Book</label>

            <select name="book_id"
                    class="form-select"
                    required>

                <option value="">-- Select Book --</option>

                <c:forEach items="${books}" var="b">

                    <option value="${b.bookId}">
                        ${b.title}
                    </option>

                </c:forEach>

            </select>



            <!-- QUANTITY -->

            <label>Number of Copies</label>

            <input type="number"
                   name="quantity"
                   class="form-control"
                   min="1"
                   max="50"
                   value="1"
                   required>

            <div class="copy-preview">
                You can create multiple copies at once (max 50).
            </div>



            <!-- COPY PREFIX -->

            <label>Copy Code Prefix</label>

            <input type="text"
                   name="prefix"
                   class="form-control"
                   placeholder="Example: CP"
                   value="CP">

            <div class="copy-preview">
                Codes will be generated automatically:
                CP001, CP002, CP003...
            </div>



            <!-- STATUS -->

            <label>Status</label>

            <select name="status"
                    class="form-select">

                <option value="AVAILABLE">AVAILABLE</option>
                <option value="INACTIVE">INACTIVE</option>

            </select>



            <div class="form-actions">

                <button type="submit"
                        class="btn-save">

                    💾 Create Copies

                </button>


                <a href="${pageContext.request.contextPath}/admin/bookcopies/list"
                   class="btn-back">

                    ⬅ Cancel

                </a>

            </div>

        </form>

    </div>

</div>