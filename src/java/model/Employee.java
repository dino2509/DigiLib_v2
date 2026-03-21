package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Employee implements Serializable {

    private int employeeId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String status;
    private LocalDateTime createdAt;
    private int roleId;

    // ✅ NEW FIELDS
    private String phone;
    private String avatar;

    // =====================
    // CONSTRUCTORS
    // =====================
    public Employee() {
    }

    public Employee(int employeeId, String fullName, String email,
            String passwordHash, String status,
            LocalDateTime createdAt, int roleId,
            String phone, String avatar) {
        this.employeeId = employeeId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.status = status;
        this.createdAt = createdAt;
        this.roleId = roleId;
        this.phone = phone;
        this.avatar = avatar;
    }

    // =====================
    // GETTER & SETTER
    // =====================
    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    // ===== NEW =====
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}
