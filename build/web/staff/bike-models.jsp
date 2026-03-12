<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý model xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <h2>Quản lý model xe</h2>
                <a href="${pageContext.request.contextPath}/staff/bike-model?action=add" class="btn btn-success">Thêm model mới</a>
            </div>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/staff/bike-model" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                <input type="hidden" name="action" value="list">
                <div style="display: flex; gap: 1rem; align-items: end;">
                    <div style="flex: 1;">
                        <label>Từ khóa (Tên model, Brand, Loại):</label>
                        <input type="text" name="keyword" value="${searchKeyword != null ? searchKeyword : ''}" placeholder="Nhập từ khóa..." style="width: 100%; padding: 0.5rem;">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/bike-model?action=list" class="btn btn-secondary">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <c:if test="${empty models}">
                <p class="text-center">Chưa có model nào trong hệ thống.</p>
            </c:if>
            
            <c:if test="${not empty models}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên model</th>
                            <th>Thương hiệu</th>
                            <th>Loại</th>
                            <th>Trọng lượng (kg)</th>
                            <th>Có pin</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="model" items="${models}">
                            <tr>
                                <td>${model.modelID}</td>
                                <td>${model.modelName}</td>
                                <td>${model.brand != null ? model.brand : 'N/A'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${model.typeName == 'standard'}">Xe đạp thường</c:when>
                                        <c:when test="${model.typeName == 'ebike'}">Xe đạp điện</c:when>
                                        <c:when test="${model.typeName == 'cargo'}">Xe đạp hàng</c:when>
                                        <c:otherwise>${model.typeName}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${model.weightKg != null ? model.weightKg : 'N/A'}</td>
                                <td>
                                    <span class="status-badge ${model.hasBattery ? 'status-available' : 'status-maintenance'}">
                                        ${model.hasBattery ? 'Có' : 'Không'}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/staff/bike-model?action=edit&id=${model.modelID}" class="btn btn-warning">Sửa</a>
                                    <form method="post" action="${pageContext.request.contextPath}/staff/bike-model" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa model này? Hành động này không thể hoàn tác!');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="modelID" value="${model.modelID}">
                                        <button type="submit" class="btn btn-danger">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
</body>
</html>

