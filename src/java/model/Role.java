package model;

import java.io.Serializable;

public class Role implements Serializable {

    private int roleId;
    private String roleName;
    private String description;

    // Constructor rỗng (bắt buộc cho JDBC / JavaBean)
    public Role() {
    }

    // Constructor đầy đủ (tiện khi map dữ liệu)
    public Role(int roleId, String roleName, String description) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.description = description;
    }

    // Getter & Setter
    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
