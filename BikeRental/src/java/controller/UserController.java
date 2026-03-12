package controller;

import dao.UserDAO;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class UserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("list".equals(action) || action == null) {
            // Admin xem tất cả users, Staff chỉ xem customers
            if ("Admin".equals(role)) {
                String keyword = request.getParameter("keyword");
                String roleIDStr = request.getParameter("roleID");
                
                Integer roleID = (roleIDStr != null && !roleIDStr.isEmpty()) ? Integer.parseInt(roleIDStr) : null;
                
                // Lấy danh sách roles để hiển thị trong dropdown
                dao.RoleDAO roleDAO = new dao.RoleDAO();
                request.setAttribute("roles", roleDAO.getAllRoles());
                
                if ((keyword != null && !keyword.trim().isEmpty()) || (roleID != null && roleID > 0)) {
                    request.setAttribute("users", userDAO.searchUsers(keyword, roleID));
                    request.setAttribute("searchKeyword", keyword);
                    request.setAttribute("searchRoleID", roleIDStr);
                } else {
                    request.setAttribute("users", userDAO.getAllUsers());
                }
                request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            } else if ("Staff".equals(role)) {
                String keyword = request.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    request.setAttribute("customers", userDAO.searchCustomers(keyword));
                    request.setAttribute("searchKeyword", keyword);
                } else {
                    request.setAttribute("customers", userDAO.getCustomers());
                }
                request.getRequestDispatcher("/staff/customers.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/customer-bikes");
            }
        } else if ("edit".equals(action)) {
            int userID = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(userID);
            
            // Staff chỉ có thể sửa Customer (RoleID = 3)
            if ("Staff".equals(role) && user != null && user.getRoleID() != 3) {
                response.sendRedirect(request.getContextPath() + "/staff/customer?action=list");
                return;
            }
            
            request.setAttribute("user", user);
            if ("Staff".equals(role)) {
                request.getRequestDispatcher("/staff/customer-edit.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/user-edit.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("update".equals(action)) {
            int userID = Integer.parseInt(request.getParameter("userID"));
            User existingUser = userDAO.getUserById(userID);
            
            // Staff chỉ có thể sửa Customer (RoleID = 3) và không được đổi RoleID
            if ("Staff".equals(role)) {
                if (existingUser == null || existingUser.getRoleID() != 3) {
                    response.sendRedirect(request.getContextPath() + "/staff/customer?action=list");
                    return;
                }
                
                // Staff chỉ cập nhật thông tin cơ bản, không đổi RoleID và IsActive
                User user = new User();
                user.setUserID(userID);
                user.setFullName(request.getParameter("fullName"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                user.setRoleID(3); // Giữ nguyên RoleID = Customer
                user.setIsActive(existingUser.isActive()); // Giữ nguyên trạng thái

                if (userDAO.updateUser(user)) {
                    response.sendRedirect(request.getContextPath() + "/staff/customer?action=list");
                } else {
                    request.setAttribute("error", "Cập nhật khách hàng thất bại!");
                    request.setAttribute("user", existingUser);
                    request.getRequestDispatcher("/staff/customer-edit.jsp").forward(request, response);
                }
            } else {
                // Admin có thể sửa tất cả
                User user = new User();
                user.setUserID(userID);
                user.setFullName(request.getParameter("fullName"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                user.setRoleID(Integer.parseInt(request.getParameter("roleID")));
                user.setIsActive(Boolean.parseBoolean(request.getParameter("isActive")));

                if (userDAO.updateUser(user)) {
                    response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                } else {
                    request.setAttribute("error", "Cập nhật người dùng thất bại!");
                    request.setAttribute("user", existingUser);
                    request.getRequestDispatcher("/admin/user-edit.jsp").forward(request, response);
                }
            }
        } else if ("delete".equals(action)) {
            int userID = Integer.parseInt(request.getParameter("userID"));
            User userToDelete = userDAO.getUserById(userID);
            
            // Staff chỉ có thể xóa Customer (RoleID = 3)
            if ("Staff".equals(role)) {
                if (userToDelete == null || userToDelete.getRoleID() != 3) {
                    response.sendRedirect(request.getContextPath() + "/staff/customer?action=list");
                    return;
                }
            }
            
            // Admin không thể xóa Admin (RoleID = 1)
            if ("Admin".equals(role)) {
                if (userToDelete == null || userToDelete.getRoleID() == 1) {
                    request.setAttribute("error", "Không thể xóa tài khoản Admin!");
                    dao.RoleDAO roleDAO = new dao.RoleDAO();
                    request.setAttribute("roles", roleDAO.getAllRoles());
                    request.setAttribute("users", userDAO.getAllUsers());
                    request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
                    return;
                }
            }
            
            if (userDAO.deleteUser(userID)) {
                if ("Staff".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/staff/customer?action=list");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
                }
            } else {
                request.setAttribute("error", "Xóa người dùng thất bại!");
                if ("Staff".equals(role)) {
                    request.setAttribute("customers", userDAO.getCustomers());
                    request.getRequestDispatcher("/staff/customers.jsp").forward(request, response);
                } else {
                    request.setAttribute("users", userDAO.getAllUsers());
                    request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
                }
            }
        }
    }
}

