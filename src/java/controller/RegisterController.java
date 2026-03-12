package controller;

import dao.UserDAO;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        UserDAO userDAO = new UserDAO();
        if (userDAO.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(password);
        user.setPhone(phone);
        user.setRoleID(3); // Customer role

        if (userDAO.register(user)) {
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đăng ký thất bại!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}

