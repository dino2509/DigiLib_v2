
<%@ page contentType="text/html;charset=UTF-8" %>

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
        margin-top: 20px;
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

<div class="add-wrapper">
    <div class="add-card">

        <div class="add-title">
            ➕ Tạo Reader mới
        </div>

        <form action="${pageContext.request.contextPath}/admin/readers/add"
              method="post">

            <label>Họ tên</label>
            <input type="text"
                   name="full_name"
                   class="form-control"
                   placeholder="Nhập họ tên"
                   required>

            <label>Email</label>
            <input type="email"
                   name="email"
                   class="form-control"
                   placeholder="example@email.com"
                   required>

            <label>Mật khẩu</label>
            <input type="password"
                   name="password"
                   class="form-control"
                   placeholder="Nhập mật khẩu"
                   required>

            <label>Phone</label>
            <input type="text"
                   name="phone"
                   class="form-control"
                   placeholder="Số điện thoại">

            <label>Status</label>
            <select name="status" class="form-select">
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
            </select>

            <label>Role</label>
            <select name="role_id" class="form-select">
                <option value="3">Reader</option>
                <option value="2">Librarian</option>
                <option value="1">Admin</option>
            </select>

            <div class="form-actions">
                <button type="submit" class="btn-save">
                    💾 Tạo
                </button>

                <a href="${pageContext.request.contextPath}/admin/readers"
                   class="btn-back">
                    ⬅ Quay lại
                </a>
            </div>

        </form>

    </div>
</div>