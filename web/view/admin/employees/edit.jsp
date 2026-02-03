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

    .form-control[readonly] {
        background: #f3f4f6;
        color: #6b7280;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #f97316;
        box-shadow: 0 0 0 3px rgba(249,115,22,0.2);
        outline: none;
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
</style>

<div class="edit-wrapper">
    <div class="edit-card">

        <div class="edit-title">
            ✏ Edit Employee
        </div>

        <form action="${pageContext.request.contextPath}/admin/employees/edit"
              method="post">

            <!-- ID -->
            <input type="hidden"
                   name="employee_id"
                   value="${employee.employeeId}"/>

            <!-- FULL NAME -->
            <label>Full Name</label>
            <input type="text"
                   name="full_name"
                   class="form-control"
                   value="${employee.fullName}"
                   required/>

            <!-- EMAIL (READONLY) -->
            <label>Email</label>
            <input type="text"
                   class="form-control"
                   value="${employee.email}"
                   readonly/>

            <!-- ROLE -->
            <label>Role</label>
            <select name="role_id"
                    class="form-select"
                    required>
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
                <option value="active"
                        <c:if test="${employee.status == 'active'}">selected</c:if>>
                            Active
                        </option>
                        <option value="inactive"
                        <c:if test="${employee.status == 'inactive'}">selected</c:if>>
                            Inactive
                        </option>
                </select>

                <!-- ACTIONS -->
                <div class="form-actions">
                    <button type="submit" class="btn-save">
                        💾 Update
                    </button>

                    <a href="${pageContext.request.contextPath}/admin/employees"
                   class="btn-back">
                    ⬅ Cancel
                </a>
            </div>

        </form>

    </div>
</div>
