<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sửa thông tin khách hàng - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Sửa thông tin khách hàng</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/staff/customer" method="POST">
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
                    <input type="tel" name="phone" value="${user.phone != null ? user.phone : ''}">
                </div>
                
                <div class="form-group">
                    <label>Vai trò:</label>
                    <input type="text" value="Customer" disabled style="background: #f0f0f0; cursor: not-allowed;">
                    <small style="display: block; color: #666; margin-top: 0.25rem;">Staff không thể thay đổi vai trò</small>
                </div>
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <%
                        models.User u = (models.User) request.getAttribute("user");
                        String statusText = (u != null && u.isActive()) ? "Hoạt động" : "Vô hiệu hóa";
                    %>
                    <input type="text" value="<%= statusText %>" disabled style="background: #f0f0f0; cursor: not-allowed;">
                    <small style="display: block; color: #666; margin-top: 0.25rem;">Staff không thể thay đổi trạng thái</small>
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                    <button type="submit" class="btn btn-success">Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/staff/customer?action=list" class="btn btn-warning">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

