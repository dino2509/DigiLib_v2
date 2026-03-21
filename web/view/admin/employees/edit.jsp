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
        color: #c2410c;
        margin-bottom: 26px;
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

    .avatar-preview {
        text-align: center;
        margin-bottom: 15px;
    }

    .avatar-preview img {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #fed7aa;
    }

    .form-actions {
        display: flex;
        justify-content: space-between;
        margin-top: 22px;
        padding-top: 16px;
        border-top: 1px dashed #fed7aa;
    }

    .btn-save {
        background: linear-gradient(135deg, #fb923c, #ea580c);
        color: #fff;
        padding: 10px 30px;
        border-radius: 999px;
        font-weight: 600;
        border: none;
    }

    .btn-back {
        color: #ea580c;
        font-weight: 600;
        text-decoration: none;
    }
</style>
<c:if test="${not empty error}">
    <div style="color:red; margin-bottom:10px;">
        ${error}
    </div>
</c:if>
<div class="edit-wrapper">
    <div class="edit-card">

        <div class="edit-title">✏ Edit Employee</div>

        <form action="${pageContext.request.contextPath}/admin/employees/edit"
              method="post"
              enctype="multipart/form-data"
              onsubmit="return validateEditForm()">

            <input type="hidden" name="employee_id" value="${employee.employeeId}"/>

            <!-- AVATAR -->
            <div class="avatar-preview">
                <c:choose>
                    <c:when test="${not empty employee.avatar}">
                        <img src="${pageContext.request.contextPath}/img/avatar/${employee.avatar}">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/img/book/no-cover.png">
                    </c:otherwise>
                </c:choose>
            </div>

            <label>Change Avatar</label>
            <input type="file" name="avatar" class="form-control" accept="image/*">

            <!-- FULL NAME -->
            <label>Full Name</label>
            <input type="text" name="full_name" class="form-control"
                   value="${employee.fullName}" required/>

            <!-- PHONE -->
            <label>Phone</label>
            <input type="text" name="phone" class="form-control"
                   value="${employee.phone}"/>

            <!-- EMAIL -->
            <label>Email</label>
            <input type="text" class="form-control"
                   value="${employee.email}" readonly/>

            <!-- ROLE -->
            <label>Role</label>
            <select name="role_id" class="form-select" required>
                <c:forEach items="${roles}" var="r">
                    <c:if test="${r.roleId ne 3}">
                        <option value="${r.roleId}"
                                <c:if test="${employee.roleId == r.roleId}">selected</c:if>>
                            ${r.roleName}
                        </option>
                    </c:if>
                </c:forEach>
            </select>

            <!-- STATUS -->
            <label>Status</label>
            <select name="status" class="form-select">
                <option value="active" ${employee.status == 'active' ? 'selected' : ''}>Active</option>
                <option value="inactive" ${employee.status == 'inactive' ? 'selected' : ''}>Inactive</option>
            </select>

            <div class="form-actions">
                <button type="submit" class="btn-save">💾 Update</button>
                <a href="${pageContext.request.contextPath}/admin/employees" class="btn-back">⬅ Cancel</a>
            </div>

        </form>
    </div>
</div>
<script>
    function validateEditForm() {

        let name = document.querySelector("input[name='full_name']").value.trim();
        let phone = document.querySelector("input[name='phone']").value.trim();
        let file = document.querySelector("input[name='avatar']").files[0];

// NAME
        if (name.length < 3) {
            alert("Full name must be at least 3 characters");
            return false;
        }

// PHONE (optional nhưng phải đúng format)
        if (phone) {
            let phoneRegex = /^[0-9]{9,11}$/;
            if (!phoneRegex.test(phone)) {
                alert("Phone must be 9-11 digits");
                return false;
            }
        }

// AVATAR
        if (file) {
            let maxSize = 20 * 1024 * 1024;

            if (file.size > maxSize) {
                alert("Avatar must be under 20MB");
                return false;
            }

            let allowed = ["image/jpeg", "image/png", "image/gif", "image/webp"];

            if (!allowed.includes(file.type)) {
                alert("Only image files allowed (jpg, png, gif, webp)");
                return false;
            }
        }

        return true;
    }
</script>