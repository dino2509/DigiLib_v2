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
        display:block;
        margin-bottom:6px;
    }

    .form-control,
    .form-select{
        width:100%;
        border-radius:10px;
        padding:10px 12px;
        margin-bottom:16px;
        border:1px solid #e5e7eb;
    }

    .form-control:focus,
    .form-select:focus{
        outline:none;
        border-color:#f97316;
        box-shadow:0 0 0 2px rgba(249,115,22,0.2);
    }

    .hint{
        font-size:13px;
        color:#6b7280;
        margin-top:-10px;
        margin-bottom:14px;
    }

    .highlight-box{
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
        cursor:pointer;
    }

    .btn-back{
        color:#ea580c;
        text-decoration:none;
        font-weight:600;
    }

    .preview{
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

            <!-- BOOK -->
            <label>Book</label>
            <select name="book_id"
                    id="bookSelect"
                    class="form-select"
                    required>

                <option value="">-- Select Book --</option>

                <c:forEach items="${books}" var="b">
                    <option value="${b.bookId}">
                        ${b.title}
                    </option>
                </c:forEach>

            </select>

            <div class="hint">
                Prefix will be auto-generated but you can edit it
            </div>


            <!-- PREFIX -->
            <label>Copy Code Prefix</label>
            <input type="text"
                   name="prefix"
                   id="prefixInput"
                   class="form-control"
                   placeholder="Auto generated (editable)">

            <div class="highlight-box">
                Example: Clean Code → CC <br>
                Max 5 characters, uppercase recommended
            </div>


            <!-- QUANTITY -->
            <label>Number of Copies</label>
            <input type="number"
                   name="quantity"
                   class="form-control"
                   min="1"
                   max="50"
                   value="1"
                   required>

            <div class="hint">
                Max 50 copies per request
            </div>


            <!-- STATUS -->
            <label>Status</label>
            <select name="status" class="form-select">
                <option value="AVAILABLE">AVAILABLE</option>
                <option value="INACTIVE">INACTIVE</option>
            </select>


            <!-- PREVIEW -->
            <div class="highlight-box" id="previewBox" style="display:none;">
                Example codes:
                <span id="previewText"></span>
            </div>


            <!-- ACTION -->
            <div class="form-actions">

                <button type="submit" class="btn-save">
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

<script>
    const bookSelect = document.getElementById("bookSelect");
    const prefixInput = document.getElementById("prefixInput");
    const previewBox = document.getElementById("previewBox");
    const previewText = document.getElementById("previewText");

    let userEdited = false;

    // detect user manual edit
    prefixInput.addEventListener("input", () => {
        userEdited = true;
    });

    function generatePrefix(title) {
        if (!title)
            return "";

        let words = title.trim().split(/\s+/);
        let prefix = words.map(w => w[0]).join("");

        return prefix.toUpperCase().substring(0, 5);
    }

    function updatePreview(prefix) {
        if (!prefix) {
            previewBox.style.display = "none";
            return;
        }

        previewBox.style.display = "block";
        previewText.textContent =
                prefix + "001, " +
                prefix + "002, " +
                prefix + "003...";
    }

    bookSelect.addEventListener("change", function () {
        let title = this.options[this.selectedIndex].text;

        let prefix = generatePrefix(title);

        // chỉ auto nếu user chưa chỉnh tay
        if (!userEdited || prefixInput.value === "") {
            prefixInput.value = prefix;
        }

        updatePreview(prefixInput.value);
    });

    // preview khi user tự gõ
    prefixInput.addEventListener("input", function () {
        updatePreview(this.value.toUpperCase());
    });
</script>