<%@ page contentType="text/html;charset=UTF-8" %>

<h2>Tạo Reader mới</h2>

<form action="${pageContext.request.contextPath}/admin/readers/add" method="post">

    <label>Họ tên</label>
    <input type="text" name="full_name" required>

    <label>Email</label>
    <input type="email" name="email" required>

    <label>Mật khẩu</label>
    <input type="password" name="password" required>

    <label>Phone</label>
    <input type="text" name="phone">

    <label>Status</label>
    <select name="status">
        <option value="active">active</option>
        <option value="inactive">inactive</option>
    </select>

    <label>Role</label>
    <select name="role_id">
        <option value="3">Reader</option>
        <option value="2">Librarian</option>
        <option value="1">Admin</option>
    </select>

    <button type="submit">Tạo</button>
</form>
