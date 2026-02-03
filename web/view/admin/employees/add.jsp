<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .add-wrapper {
        max-width: 900px;
        margin: 0 auto;
    }

    .add-card {
        background: #ffffff;
        padding: 34px 38px;
        border-radius: 18px;
        border: 1px solid #fed7aa;
        box-shadow: 0 18px 40px rgba(0,0,0,0.08);
    }

    .add-title {
        text-align: center;
        font-size: 24px;
        font-weight: 700;
        color: #c2410c;
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
        width: 100%;
        border-radius: 10px;
        font-size: 14px;
        padding: 10px 12px;
        margin-bottom: 16px;
        border: 1px solid #e5e7eb;
    }

    .form-control[readonly] {
        background: #f3f4f6;
        color: #6b7280;
    }

    .divider {
        margin: 20px 0;
        border-top: 1px dashed #fed7aa;
    }

    .form-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 24px;
        padding-top: 18px;
        border-top: 1px dashed #fed7aa;
    }

    .btn-save {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        padding: 10px 30px;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 600;
        border: none;
        cursor: pointer;
    }

    .btn-save:hover {
        box-shadow: 0 6px 18px rgba(234,88,12,0.45);
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

    .hint {
        font-size: 13px;
        color: #6b7280;
        margin-top: -10px;
        margin-bottom: 12px;
        font-style: italic;
    }
</style>

<div class="add-wrapper">
    <div class="add-card">

        <div class="add-title">
            🚀 Promote Reader to Employee
        </div>

        <form action="${pageContext.request.contextPath}/admin/employees/add"
              method="post">

            <!-- SELECT READER -->
            <label>Reader</label>
            <select id="readerSelect"
                    name="reader_id"
                    class="form-select"
                    required
                    onchange="fillReaderInfo()">
                <option value="">-- Select Reader --</option>

                <c:forEach items="${readers}" var="r">
                    <c:if test="${r.roleId == 3}">
                        <option value="${r.readerId}"
                                data-name="${r.fullName}"
                                data-email="${r.email}"
                                data-phone="${r.phone}"
                                data-status="${r.status}">
                            ${r.fullName} - ${r.email}
                        </option>
                    </c:if>
                </c:forEach>

            </select>
            <div class="hint">Chọn reader để tự động điền thông tin</div>

            <div class="divider"></div>

            <!-- FULL NAME -->
            <label>Full Name</label>
            <input type="text"
                   id="fullName"
                   name="full_name"
                   class="form-control"
                   required>

            <!-- EMAIL -->
            <label>Email</label>
            <input type="text"
                   id="email"
                   class="form-control"
                   readonly>

            <!-- PHONE -->
            <label>Phone</label>
            <input type="text"
                   id="phone"
                   class="form-control"
                   readonly>

            <!-- STATUS -->
            <label>Status</label>
            <input type="text"
                   id="status"
                   class="form-control"
                   readonly>

            <!-- ROLE -->
            <label>Role</label>
            <select name="role_id"
                    class="form-select"
                    required>

                <c:forEach items="${roles}" var="r">
                    <c:if test="${r.roleId ne 3}">
                        <option value="${r.roleId}">
                            ${r.roleName}
                        </option>
                    </c:if>
                </c:forEach>
            </select>

            <!-- ACTIONS -->
            <div class="form-actions">
                <button type="submit" class="btn-save">
                    🚀 Promote
                </button>

                <a href="${pageContext.request.contextPath}/admin/employees"
                   class="btn-back">
                    ⬅ Cancel
                </a>
            </div>

        </form>

    </div>
</div>

<script>
    function fillReaderInfo() {
        const select = document.getElementById("readerSelect");
        const opt = select.options[select.selectedIndex];

        if (!opt.value)
            return;

        document.getElementById("fullName").value = opt.dataset.name;
        document.getElementById("email").value = opt.dataset.email;
        document.getElementById("phone").value = opt.dataset.phone;
        document.getElementById("status").value = opt.dataset.status;
    }
</script>
