<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Reader</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

        <div class="container mt-4">

            <h2 class="mb-4">Cập nhật Reader</h2>

            <form action="${pageContext.request.contextPath}/admin/readers/edit" method="post">

                <!-- Hidden ID -->
                <input type="hidden" name="reader_id" value="${reader.readerId}"/>

                <!-- Full name -->
                <div class="mb-3">
                    <label class="form-label">Họ tên</label>
                    <input type="text" name="full_name"
                           class="form-control"
                           value="${reader.fullName}" required>
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email"
                           class="form-control"
                           value="${reader.email}" required>
                </div>

                <!-- Phone -->
                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" name="phone"
                           class="form-control"
                           value="${reader.phone}">
                </div>

                <!-- Avatar -->
                <div class="mb-3">
                    <label class="form-label">Avatar URL</label>
                    <input type="text" name="avatar"
                           class="form-control"
                           value="${reader.avatar}">
                </div>

                <!-- Status -->
                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="active"
                                ${reader.status == 'active' ? 'selected' : ''}>
                            Active
                        </option>
                        <option value="inactive"
                                ${reader.status == 'inactive' ? 'selected' : ''}>
                            Inactive
                        </option>
                    </select>
                </div>

                <!-- Role -->
                <div class="mb-3">
                    <label class="form-label">Role</label>
                   
                    <select name="role_id" class="form-select">
                        <option value="3"
                                ${reader.roleId == ê ? 'selected' : ''}>
                            Reader
                        </option>
                        <option value="2"
                                ${reader.roleId == 2 ? 'selected' : ''}>
                            Librarian
                        </option>
                        <option value="1"
                                ${reader.roleId == 1 ? 'selected' : ''}>
                            Admin
                        </option>
                    </select>
                </div>

                <!-- Actions -->
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        Cập nhật
                    </button>

                    <a href="${pageContext.request.contextPath}/admin/readers"
                       class="btn btn-secondary">
                        Quay lại
                    </a>
                </div>

            </form>
        </div>

    </body>
</html>
