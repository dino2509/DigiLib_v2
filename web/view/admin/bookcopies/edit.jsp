<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .edit-wrapper {
        max-width: 700px;
        margin: 0 auto;
    }

    .edit-card {
        background: #ffffff;
        padding: 32px 36px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 16px 36px rgba(0,0,0,0.08);
    }

    .edit-title {
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
        display: block;
    }

    .form-control,
    .form-select {
        border-radius: 10px;
        font-size: 14px;
        padding: 10px 12px;
        margin-bottom: 16px;
        width: 100%;
    }

    .form-control[readonly] {
        background: #f3f4f6;
        color: #6b7280;
    }

    .note {
        font-size: 13px;
        color: #6b7280;
        margin-top: -10px;
        margin-bottom: 14px;
        font-style: italic;
    }

    .note-warning {
        color: #b45309;
        font-weight: 600;
    }

    .form-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 22px;
        padding-top: 16px;
        border-top: 1px dashed #fed7aa;
    }

    .btn-save {
        background: linear-gradient(135deg, #f97316, #ea580c);
        color: #fff;
        padding: 10px 30px;
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

<div class="edit-wrapper">
    <div class="edit-card">

        <div class="edit-title">
            ✏ Edit Book Copy
        </div>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/bookcopies/edit">

            <!-- hidden id -->
            <input type="hidden" name="copy_id" value="${bookCopy.copyId}" />

            <!-- Book ID (readonly) -->
            <label>Book ID</label>
            <input type="text"
                   class="form-control"
                   value="${bookCopy.bookId}"
                   readonly />
            <div class="note">Book không thể thay đổi</div>

            <!-- Copy Code -->
            <label>Copy Code</label>
            <input type="text"
                   name="copy_code"
                   class="form-control"
                   value="${bookCopy.copyCode}"
                   required />

            <!-- Status -->
            <label>Status</label>
            <select name="status"
                    class="form-select"
                    <c:if test="${bookCopy.status eq 'BORROWED'}">disabled</c:if>>

                        <option value="AVAILABLE"
                        <c:if test="${bookCopy.status eq 'AVAILABLE'}">selected</c:if>>
                            AVAILABLE
                        </option>

                        <option value="BORROWED"
                        <c:if test="${bookCopy.status eq 'BORROWED'}">selected</c:if>>
                            BORROWED
                        </option>

                        <option value="DAMAGED"
                        <c:if test="${bookCopy.status eq 'DAMAGED'}">selected</c:if>>
                            DAMAGED
                        </option>

                        <option value="LOST"
                        <c:if test="${bookCopy.status eq 'LOST'}">selected</c:if>>
                            LOST
                        </option>

                        <option value="INACTIVE"
                        <c:if test="${bookCopy.status eq 'INACTIVE'}">selected</c:if>>
                            INACTIVE
                        </option>
                    </select>

            <c:if test="${bookCopy.status eq 'BORROWED'}">
                <div class="note note-warning">
                    Không thể thay đổi trạng thái khi sách đang được mượn
                </div>
            </c:if>

            <!-- ACTIONS -->
            <div class="form-actions">
                <button type="submit" class="btn-save">
                    💾 Update
                </button>

                <a href="${pageContext.request.contextPath}/admin/bookcopies/list"
                   class="btn-back">
                    ⬅ Cancel
                </a>
            </div>

        </form>

    </div>
</div>
