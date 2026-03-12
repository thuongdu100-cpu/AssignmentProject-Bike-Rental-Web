<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm model xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Thêm model xe mới</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/staff/bike-model" method="POST">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label>Tên model *</label>
                    <input type="text" name="modelName" required>
                </div>
                
                <div class="form-group">
                    <label>Thương hiệu</label>
                    <input type="text" name="brand">
                </div>
                
                <div class="form-group">
                    <label>Loại xe *</label>
                    <select name="typeName" required>
                        <option value="standard">Xe đạp thường</option>
                        <option value="ebike">Xe đạp điện</option>
                        <option value="cargo">Xe đạp hàng</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Trọng lượng (kg)</label>
                    <input type="number" name="weightKg" step="0.01" min="0">
                </div>
                
                <div class="form-group">
                    <label>Có pin</label>
                    <select name="hasBattery">
                        <option value="false">Không</option>
                        <option value="true">Có</option>
                    </select>
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                    <button type="submit" class="btn btn-success">Thêm</button>
                    <a href="${pageContext.request.contextPath}/staff/bike-model?action=list" class="btn btn-warning">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

