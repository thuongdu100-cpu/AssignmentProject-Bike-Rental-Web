package dao;

import models.Role;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBContext {

    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM Roles ORDER BY RoleID";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                role.setRoleDescription(rs.getNString("RoleDescription"));
                list.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Role getRoleById(int roleID) {
        String sql = "SELECT * FROM Roles WHERE RoleID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, roleID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                role.setRoleDescription(rs.getNString("RoleDescription"));
                return role;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

