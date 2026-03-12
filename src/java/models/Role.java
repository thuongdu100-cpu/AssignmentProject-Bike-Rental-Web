package models;

import java.io.Serializable;

public class Role implements Serializable {
    private int roleID;
    private String roleName;
    private String roleDescription;

    public Role() {
    }

    public Role(int roleID, String roleName, String roleDescription) {
        this.roleID = roleID;
        this.roleName = roleName;
        this.roleDescription = roleDescription;
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getRoleDescription() {
        return roleDescription;
    }

    public void setRoleDescription(String roleDescription) {
        this.roleDescription = roleDescription;
    }
}

