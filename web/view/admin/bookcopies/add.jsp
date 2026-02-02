<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .add-wrapper {
        max-width: 700px;
        margin: 0 auto;
    }

    .add-card {
        background: #ffffff;
        padding: 32px 36px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 16px 36px rgba(0,0,0,0.08);
    }

    .add-title {
        text-align: center;
        font-size: 24px;
        font-weight: 700;
        color: #ea580c;
        margin-bottom: 28px;
    }

    label {
        font-weight: 600;
        color: #374151;
        margin-bottom: 6px;
        font-size: 14px;
    }

    .form-control,
    .form-select {
        border-radius: 10px;
        font-size: 14px;
        padding: 10px 12px;
        margin-bottom: 18px;
    }

    .form-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 20px;
        padding-top: 16px;
        border-top: 1px dashed #fed7aa;
    }

    .btn-save {
        background: linear-gradient(135deg, #f97316, #ea580c);
        color: #fff;
        padding: 10px 28px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        border: none;
    }

    .btn-save:hover {
        box-shadow: 0 6px 18px rgba(249,115,22,0.45);
    }

    .btn-back {
        color: #ea580c;
        font-weight: 600;
        text-decoration: none;
    }

    .btn-back:hover {
        text-decoration: underline;
    }
</style>

<div class="add-wrapper">
    <div class="add-card">

        <div class="add-title">
            ➕ Add New Book Copy
        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/bookcopies/add">

            <!-- BOOK -->
            <label>Book</label>
            <select name="book_id" class="form-select" required>
                <option value="">-- Select Book --</option>
                <c:forEach items="${books}" var="b">
                    <option value="${b.bookId}">
                        ${b.title}
                    </option>
                </c:forEach>
            </select>
           
            <!-- COPY CODE -->
            <label>Copy Code</label>
            <input type="text"
                   name="copy_code"
                   class="form-control"
                   placeholder="VD: BK-001"
                   required/>

            <!-- STATUS -->
            <label>Status</label>
            <select name="status" class="form-select">
                <option value="AVAILABLE">AVAILABLE</option>
                <option value="INACTIVE">INACTIVE</option>
            </select>

            <!-- ACTIONS -->
            <div class="form-actions">
                <button type="submit" class="btn-save">
                    💾 Create
                </button>

                <a href="${pageContext.request.contextPath}/admin/bookcopies/list"
                   class="btn-back">
                    ⬅ Cancel
                </a>
            </div>

        </form>

    </div>
</div>
