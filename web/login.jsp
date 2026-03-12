<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng nhập - Bike Rental</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="max-width: 400px; margin-top: 5rem;">
        <div class="card">
            <h2 class="text-center" style="margin-bottom: 2rem;">Đăng nhập</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>
            
            <form action="login" method="POST">
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label>Mật khẩu:</label>
                    <input type="password" name="password" required>
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%;">Đăng nhập</button>
            </form>
            
            <p class="text-center" style="margin-top: 1.5rem;">
                Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
            </p>
        </div>
    </div>
</body>
</html>

