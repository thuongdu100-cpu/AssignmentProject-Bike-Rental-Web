<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sửa người dùng - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Sửa thông tin người dùng</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/user" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="userID" value="${user.userID}">
                
                <div class="form-group">
                    <label>Họ và tên:</label>
                    <input type="text" name="fullName" value="${user.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" value="${user.email}" required>
                </div>
                
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="tel" name="phone" value="${user.phone}">
                </div>
                
                <div class="form-group">
                    <label>Vai trò:</label>
                    <select name="roleID" required>
                        <option value="1" ${user.roleID == 1 ? 'selected' : ''}>Admin</option>
                        <option value="2" ${user.roleID == 2 ? 'selected' : ''}>Staff</option>
                        <option value="3" ${user.roleID == 3 ? 'selected' : ''}>Customer</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select name="isActive">
                        <option value="true" ${user.active ? 'selected' : ''}>Hoạt động</option>
                        <option value="false" ${!user.active ? 'selected' : ''}>Vô hiệu hóa</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-success">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/user?action=list" class="btn btn-warning">Hủy</a>
            </form>
        </div>
    </div>
</body>
</html>

