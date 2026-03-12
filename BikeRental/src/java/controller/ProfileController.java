package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        int userID = (Integer) session.getAttribute("userID");
        
        // Lấy thông tin user mới nhất từ database
        models.User user = userDAO.getUserById(userID);
        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Không tìm thấy thông tin người dùng!");
            response.sendRedirect(request.getContextPath() + "/customer-bikes");
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

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();
        int userID = (Integer) session.getAttribute("userID");

        if ("update".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Validate
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ và tên không được để trống!");
                models.User user = userDAO.getUserById(userID);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email không được để trống!");
                models.User user = userDAO.getUserById(userID);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
                return;
            }

            // Kiểm tra email đã tồn tại chưa (trừ user hiện tại)
            if (userDAO.checkEmailExistsExcludingUser(email, userID)) {
                request.setAttribute("error", "Email này đã được sử dụng bởi người dùng khác!");
                models.User user = userDAO.getUserById(userID);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
                return;
            }

            // Cập nhật profile
            if (userDAO.updateProfile(userID, fullName.trim(), email.trim(), phone != null ? phone.trim() : null)) {
                // Cập nhật lại thông tin user trong session
                models.User updatedUser = userDAO.getUserById(userID);
                if (updatedUser != null) {
                    session.setAttribute("user", updatedUser);
                }
                request.setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thông tin thất bại!");
            }

            // Lấy lại thông tin user để hiển thị
            models.User user = userDAO.getUserById(userID);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
        }
    }
}

