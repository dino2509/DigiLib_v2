<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .add-wrapper{
        max-width:900px;
        margin:0 auto;
    }

    .add-card{
        background:#fff;
        padding:34px 38px;
        border-radius:18px;
        border:1px solid #fed7aa;
        box-shadow:0 18px 40px rgba(0,0,0,0.08);
    }

    .add-title{
        text-align:center;
        font-size:24px;
        font-weight:700;
        color:#c2410c;
        margin-bottom:28px;
    }

    label{
        font-weight:600;
        color:#374151;
        margin-bottom:6px;
        font-size:14px;
        display:block;
    }

    .form-control,
    .form-select{
        width:100%;
        border-radius:10px;
        font-size:14px;
        padding:10px 12px;
        margin-bottom:16px;
        border:1px solid #e5e7eb;
    }

    .error{
        color:#dc2626;
        font-size:13px;
        margin-top:-12px;
        margin-bottom:10px;
    }

    .form-actions{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-top:24px;
        padding-top:18px;
        border-top:1px dashed #fed7aa;
    }

    .btn-save{
        background:linear-gradient(135deg,#fb923c,#ea580c);
        color:#fff;
        padding:10px 30px;
        border-radius:999px;
        font-weight:600;
        border:none;
    }

    .btn-back{
        color:#ea580c;
        font-weight:600;
        text-decoration:none;
    }
</style>


<div class="add-wrapper">

    <div class="add-card">

        <div class="add-title">
            ➕ Add Employee
        </div>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/employees/add"
              method="post"
              onsubmit="return validateForm()">

            <label>Full Name</label>
            <input type="text"
                   name="full_name"
                   id="fullName"
                   class="form-control"
                   required>

            <label>Email</label>
            <input type="email"
                   name="email"
                   id="email"
                   class="form-control"
                   required>

            <label>Password</label>
            <input type="password"
                   name="password"
                   id="password"
                   class="form-control"
                   required>

            <label>Status</label>
            <select name="status" class="form-select">
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select>

            <label>Role</label>
            <select name="role_id" class="form-select" required>
                <c:forEach items="${roles}" var="r">
                    <option value="${r.roleId}">
                        ${r.roleName}
                    </option>
                </c:forEach>
            </select>

            <div class="form-actions">

                <button type="submit" class="btn-save">
                    💾 Save
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

    function validateForm() {

        let name = document.getElementById("fullName").value.trim();
        let email = document.getElementById("email").value.trim();
        let password = document.getElementById("password").value;

        if (name.length < 3) {
            alert("Full name must be at least 3 characters");
            return false;
        }

        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailRegex.test(email)) {
            alert("Invalid email format");
            return false;
        }

        if (password.length < 6) {
            alert("Password must be at least 6 characters");
            return false;
        }

        return true;

    }

</script>