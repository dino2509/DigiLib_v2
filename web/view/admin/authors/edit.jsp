<%@ page contentType="text/html;charset=UTF-8" %>

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
        margin-bottom: 26px;
    }

    label {
        font-weight: 600;
        color: #374151;
        margin-bottom: 6px;
        font-size: 14px;
        display: block;
    }

    .form-control {
        width: 100%;
        border-radius: 10px;
        font-size: 14px;
        padding: 10px 12px;
        margin-bottom: 16px;
        border: 1px solid #e5e7eb;
    }

    textarea.form-control {
        resize: vertical;
    }

    .form-control:focus {
        border-color: #f97316;
        box-shadow: 0 0 0 3px rgba(249,115,22,0.2);
        outline: none;
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
        cursor: pointer;
    }

    .btn-save:hover {
        box-shadow: 0 6px 18px rgba(249,115,22,0.45);
    }

    .btn-back {
        color: #ea580c;
        font-weight: 600;
        text-decoration: none;
        font-size: 14px;
    }

    .btn-back:hover {
        text-decoration: underline;
    }
</style>

<div class="edit-wrapper">
    <div class="edit-card">

        <div class="edit-title">
            ✏ Edit Author
        </div>

        <form action="${pageContext.request.contextPath}/admin/authors/edit"
              method="post">

            <!-- hidden id -->
            <input type="hidden"
                   name="author_id"
                   value="${author.author_id}">

            <label for="author_name">Author Name</label>
            <input type="text"
                   id="author_name"
                   name="author_name"
                   class="form-control"
                   value="${author.author_name}"
                   required>

            <label for="bio">Bio</label>
            <textarea id="bio"
                      name="bio"
                      rows="5"
                      class="form-control"
                      placeholder="Short biography (optional)">${author.bio}</textarea>

            <div class="form-actions">
                <button type="submit" class="btn-save">
                    💾 Update
                </button>

                <a href="${pageContext.request.contextPath}/admin/authors"
                   class="btn-back">
                    ⬅ Cancel
                </a>
            </div>

        </form>

    </div>
</div>
