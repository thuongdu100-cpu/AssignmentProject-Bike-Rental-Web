<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.SimpleDateFormat" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Hồ sơ của tôi - Bike Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .profile-container {
            max-width: 800px;
            margin: 2rem auto;
        }
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px 12px 0 0;
            text-align: center;
        }
        .profile-header h2 {
            margin: 0;
            font-size: 2rem;
        }
        .profile-body {
            background: white;
            padding: 2rem;
            border-radius: 0 0 12px 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .profile-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .info-item {
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .info-label {
            display: block;
            font-weight: 600;
            color: #666;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .info-value {
            display: block;
            font-size: 1.1rem;
            color: #333;
        }
        .form-section {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e0e0e0;
        }
        .form-section h3 {
            margin-bottom: 1.5rem;
            color: #333;
        }
        @media (max-width: 768px) {
            .profile-info {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="profile-container">
            <div class="profile-header">
                <h2>👤 Hồ sơ của tôi</h2>
            </div>
            
            <div class="profile-body">
                <c:if test="${error != null}">
                    <div class="alert alert-error" style="margin-bottom: 1.5rem;">${error}</div>
                </c:if>
                
                <c:if test="${success != null}">
                    <div class="alert alert-success" style="margin-bottom: 1.5rem; background: #d4edda; color: #155724; border-color: #c3e6cb;">${success}</div>
                </c:if>
                
                <!-- Thông tin hiện tại -->
                <%
                    models.User u = (models.User) request.getAttribute("user");
                %>
                <div class="profile-info">
                    <div class="info-item">
                        <span class="info-label">Họ và tên</span>
                        <span class="info-value">${user.fullName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value">${user.email}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Số điện thoại</span>
                        <span class="info-value">${user.phone != null && !empty user.phone ? user.phone : 'Chưa cập nhật'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Vai trò</span>
                        <span class="info-value">${user.role.roleName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái</span>
                        <span class="info-value">
                            <%
                                String statusClass = (u != null && u.isActive()) ? "status-available" : "status-unavailable";
                                String statusText = (u != null && u.isActive()) ? "Hoạt động" : "Không hoạt động";
                            %>
                            <span class="status-badge <%= statusClass %>">
                                <%= statusText %>
                            </span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày đăng ký</span>
                        <span class="info-value">
                            <%
                                if (u != null && u.getCreatedAt() != null) {
                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                    out.print(sdf.format(u.getCreatedAt()));
                                } else {
                                    out.print("N/A");
                                }
                            %>
                        </span>
                    </div>
                </div>
                
                <!-- Form chỉnh sửa -->
                <div class="form-section">
                    <h3>Chỉnh sửa thông tin</h3>
                    <form method="POST" action="${pageContext.request.contextPath}/profile">
                        <input type="hidden" name="action" value="update">
                        
                        <div class="form-group">
                            <label for="fullName">Họ và tên *</label>
                            <input type="text" id="fullName" name="fullName" 
                                   value="${user.fullName}" 
                                   required 
                                   style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; font-size: 1rem;">
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" id="email" name="email" 
                                   value="${user.email}" 
                                   required 
                                   style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; font-size: 1rem;">
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" 
                                   value="${user.phone != null ? user.phone : ''}" 
                                   placeholder="Nhập số điện thoại"
                                   style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; font-size: 1rem;">
                        </div>
                        
                        <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1; padding: 0.75rem; font-size: 1rem;">
                                💾 Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/customer-bikes" class="btn btn-secondary" style="flex: 1; padding: 0.75rem; font-size: 1rem; text-align: center; text-decoration: none; display: inline-block;">
                                🔙 Quay lại
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

