<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sửa gói giá - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Sửa gói giá</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/staff/pricing-plan" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="planID" value="${plan.planID}">
                
                <div class="form-group">
                    <label>Tên gói:</label>
                    <input type="text" name="planName" value="${plan.planName}" required>
                </div>
                
                <div class="form-group">
                    <label>Phí mở khóa (VND):</label>
                    <input type="number" name="unlockFee" min="0" step="0.01" 
                           value="${plan.unlockFee != null ? plan.unlockFee : 0}" required>
                </div>
                
                <div class="form-group">
                    <label>Giá mỗi phút (VND):</label>
                    <input type="number" name="pricePerMin" min="0" step="0.01" 
                           value="${plan.pricePerMin != null ? plan.pricePerMin : 0}" required>
                </div>
                
                <div class="form-group">
                    <label>Phút miễn phí:</label>
                    <input type="number" name="freeMinutes" min="0" value="${plan.freeMinutes}" required>
                </div>
                
                <div class="form-group">
                    <label>Giới hạn ngày (VND) - để trống nếu không giới hạn:</label>
                    <input type="number" name="dailyCap" min="0" step="0.01" 
                           value="${plan.dailyCap != null ? plan.dailyCap : ''}">
                </div>
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <%
                        models.PricingPlan p = (models.PricingPlan) request.getAttribute("plan");
                        boolean isActive = (p != null && p.isActive());
                    %>
                    <select name="isActive">
                        <option value="true" <%= isActive ? "selected" : "" %>>Hoạt động</option>
                        <option value="false" <%= !isActive ? "selected" : "" %>>Ngừng hoạt động</option>
                    </select>
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                    <button type="submit" class="btn btn-success">Cập nhật</button>
                    <a href="${pageContext.request.contextPath}/staff/pricing-plan?action=list" class="btn btn-warning">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

