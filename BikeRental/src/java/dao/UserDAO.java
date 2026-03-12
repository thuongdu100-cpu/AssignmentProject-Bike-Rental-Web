package dao;

import models.Role;
import models.User;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {

    public User login(String email, String password) {
        String sql = "SELECT u.*, r.RoleName, r.RoleDescription "
                + "FROM Users u "
                + "INNER JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE u.Email = ? AND u.PasswordHash = ? AND u.IsActive = 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getNString("FullName"));
                user.setEmail(rs.getNString("Email"));
                user.setPasswordHash(rs.getNString("PasswordHash"));
                user.setPhone(rs.getNString("Phone"));
                user.setRoleID(rs.getInt("RoleID"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                user.setIsActive(rs.getBoolean("IsActive"));

                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                role.setRoleDescription(rs.getNString("RoleDescription"));
                user.setRole(role);

                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, user.getFullName());
            ps.setNString(2, user.getEmail());
            ps.setNString(3, user.getPasswordHash());
            ps.setNString(4, user.getPhone());
            ps.setInt(5, user.getRoleID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.RoleName FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID ORDER BY u.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getNString("FullName"));
                user.setEmail(rs.getNString("Email"));
                user.setPhone(rs.getNString("Phone"));
                user.setRoleID(rs.getInt("RoleID"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                user.setIsActive(rs.getBoolean("IsActive"));

                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                user.setRole(role);

                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getCustomers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.RoleName FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE u.RoleID = 3 ORDER BY u.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getNString("FullName"));
                user.setEmail(rs.getNString("Email"));
                user.setPhone(rs.getNString("Phone"));
                user.setRoleID(rs.getInt("RoleID"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                user.setIsActive(rs.getBoolean("IsActive"));

                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                user.setRole(role);

                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserById(int userID) {
        String sql = "SELECT u.*, r.RoleName FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE u.UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getNString("FullName"));
                user.setEmail(rs.getNString("Email"));
                user.setPhone(rs.getNString("Phone"));
                user.setRoleID(rs.getInt("RoleID"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                user.setIsActive(rs.getBoolean("IsActive"));

                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                user.setRole(role);

                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, RoleID = ?, IsActive = ? WHERE UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, user.getFullName());
            ps.setNString(2, user.getEmail());
            ps.setNString(3, user.getPhone());
            ps.setInt(4, user.getRoleID());
            ps.setBoolean(5, user.isActive());
            ps.setInt(6, user.getUserID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProfile(int userID, String fullName, String email, String phone) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ? WHERE UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, fullName);
            ps.setNString(2, email);
            ps.setNString(3, phone);
            ps.setInt(4, userID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkEmailExistsExcludingUser(String email, int excludeUserID) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ? AND UserID != ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setInt(2, excludeUserID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> searchCustomers(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.RoleName FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE u.RoleID = 3";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u.FullName LIKE ? OR u.Email LIKE ? OR u.Phone LIKE ?)";
        }
        sql += " ORDER BY u.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setNString(1, searchPattern);
                ps.setNString(2, searchPattern);
                ps.setNString(3, searchPattern);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getNString("FullName"));
                user.setEmail(rs.getNString("Email"));
                user.setPhone(rs.getNString("Phone"));
                user.setRoleID(rs.getInt("RoleID"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                user.setIsActive(rs.getBoolean("IsActive"));
                
                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                user.setRole(role);
                
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteUser(int userID) {
        String sql = "UPDATE Users SET IsActive = 0 WHERE UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> searchUsers(String keyword, Integer roleID) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT u.*, r.RoleName FROM Users u INNER JOIN Roles r ON u.RoleID = r.RoleID WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.FullName LIKE ? OR u.Email LIKE ? OR u.Phone LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (roleID != null && roleID > 0) {
            sql.append(" AND u.RoleID = ?");
            params.add(roleID);
        }
        sql.append(" ORDER BY u.CreatedAt DESC");
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setNString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setFullName(rs.getNString("FullName"));
                user.setEmail(rs.getNString("Email"));
                user.setPhone(rs.getNString("Phone"));
                user.setRoleID(rs.getInt("RoleID"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                user.setIsActive(rs.getBoolean("IsActive"));
                
                Role role = new Role();
                role.setRoleID(rs.getInt("RoleID"));
                role.setRoleName(rs.getNString("RoleName"));
                user.setRole(role);
                
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCustomersCount() {
        String sql = "SELECT COUNT(*) FROM Users WHERE RoleID = 3";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

