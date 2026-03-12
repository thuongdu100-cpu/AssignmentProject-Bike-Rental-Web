<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Dashboard - Nhân viên</h2>
            <p>Chào mừng đến với hệ thống quản lý cho thuê xe đạp!</p>
            
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin-top: 2rem;">
                <div class="card">
                    <h3>🚴 Quản lý xe</h3>
                    <p>Quản lý danh sách xe đạp, thêm mới, cập nhật thông tin xe.</p>
                    <a href="${pageContext.request.contextPath}/staff/bike?action=list" class="btn btn-primary">Quản lý xe</a>
                </div>
                
                <div class="card">
                    <h3>📍 Quản lý trạm</h3>
                    <p>Quản lý các trạm cho thuê xe đạp.</p>
                    <a href="${pageContext.request.contextPath}/staff/station?action=list" class="btn btn-primary">Quản lý trạm</a>
                </div>
                
                <div class="card">
                    <h3>👥 Quản lý khách hàng</h3>
                    <p>Xem và quản lý thông tin khách hàng trong hệ thống.</p>
                    <a href="${pageContext.request.contextPath}/staff/customer?action=list" class="btn btn-primary">Quản lý khách hàng</a>
                </div>
                
                <div class="card">
                    <h3>🛠️ Quản lý model xe</h3>
                    <p>Quản lý các model xe đạp, thêm mới, cập nhật thông tin model.</p>
                    <a href="${pageContext.request.contextPath}/staff/bike-model?action=list" class="btn btn-primary">Quản lý model</a>
                </div>
                
                <div class="card">
                    <h3>💰 Quản lý gói giá</h3>
                    <p>Quản lý các gói giá cho thuê xe, thêm mới, cập nhật giá.</p>
                    <a href="${pageContext.request.contextPath}/staff/pricing-plan?action=list" class="btn btn-primary">Quản lý gói giá</a>
                </div>
                
                <div class="card">
                    <h3>📋 Quản lý thuê xe</h3>
                    <p>Xem và quản lý tất cả giao dịch thuê xe trong hệ thống.</p>
                    <a href="${pageContext.request.contextPath}/staff/rental?action=list" class="btn btn-primary">Quản lý thuê xe</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

