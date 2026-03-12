<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng ký - Bike Rental</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="max-width: 500px; margin-top: 3rem;">
        <div class="card">
            <h2 class="text-center" style="margin-bottom: 2rem;">Đăng ký tài khoản</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="register" method="POST">
                <div class="form-group">
                    <label>Họ và tên:</label>
                    <input type="text" name="fullName" required>
                </div>
                
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label>Mật khẩu:</label>
                    <input type="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" name="phone">
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%;">Đăng ký</button>
            </form>
            
            <p class="text-center" style="margin-top: 1.5rem;">
                Đã có tài khoản? <a href="login.jsp">Đăng nhập</a>
            </p>
        </div>
    </div>
</body>
</html>

