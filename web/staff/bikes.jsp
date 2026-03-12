<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="d-flex justify-content-between">
                <h2>Quản lý xe đạp</h2>
                <a href="${pageContext.request.contextPath}/staff/bike?action=add" class="btn btn-success">Thêm xe mới</a>
            </div>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/staff/bike" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                <input type="hidden" name="action" value="list">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; align-items: end;">
                    <div>
                        <label>Từ khóa (Số seri, Model, Brand):</label>
                        <input type="text" name="keyword" value="${searchKeyword != null ? searchKeyword : ''}" placeholder="Nhập từ khóa..." style="width: 100%; padding: 0.5rem;">
                    </div>
                    <div>
                        <label>Model:</label>
                        <select name="modelID" style="width: 100%; padding: 0.5rem;">
                            <option value="">Tất cả</option>
                            <c:forEach var="model" items="${models}">
                                <option value="${model.modelID}" ${searchModelID == model.modelID.toString() ? 'selected' : ''}>${model.modelName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label>Trạm:</label>
                        <select name="stationID" style="width: 100%; padding: 0.5rem;">
                            <option value="">Tất cả</option>
                            <c:forEach var="station" items="${stations}">
                                <option value="${station.stationID}" ${searchStationID == station.stationID.toString() ? 'selected' : ''}>${station.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label>Trạng thái:</label>
                        <select name="status" style="width: 100%; padding: 0.5rem;">
                            <option value="">Tất cả</option>
                            <option value="available" ${searchStatus == 'available' ? 'selected' : ''}>Có sẵn</option>
                            <option value="in_use" ${searchStatus == 'in_use' ? 'selected' : ''}>Đang thuê</option>
                            <option value="maintenance" ${searchStatus == 'maintenance' ? 'selected' : ''}>Bảo trì</option>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">🔍 Tìm kiếm</button>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/bike?action=list" class="btn btn-secondary" style="width: 100%;">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ảnh</th>
                        <th>Số seri</th>
                        <th>Model</th>
                        <th>Trạm</th>
                        <th>Trạng thái</th>
                        <th>Pin (%)</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bike" items="${bikes}">
                        <tr>
                            <td>${bike.bikeID}</td>
                            <td>
                                <c:if test="${bike.imageURL != null && !empty bike.imageURL}">
                                    <img src="${bike.imageURL}" alt="${bike.model.modelName}" style="width: 80px; height: 60px; object-fit: cover; border-radius: 4px;">
                                </c:if>
                            </td>
                            <td>${bike.serialNumber}</td>
                            <td>${bike.model.modelName}</td>
                            <td>${bike.station != null ? bike.station.name : 'N/A'}</td>
                            <td>
                                <span class="status-badge ${bike.status == 'available' ? 'status-available' : bike.status == 'in_use' ? 'status-in-use' : 'status-maintenance'}">
                                    ${bike.status == 'available' ? 'Có sẵn' : bike.status == 'in_use' ? 'Đang thuê' : 'Bảo trì'}
                                </span>
                            </td>
                            <td>${bike.batteryPercent != null ? bike.batteryPercent : 'N/A'}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/staff/bike?action=edit&id=${bike.bikeID}" class="btn btn-warning">Sửa</a>
                                <a href="${pageContext.request.contextPath}/staff/bike?action=delete&bikeID=${bike.bikeID}" 
                                   class="btn btn-danger" 
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa xe này? Hành động này không thể hoàn tác!');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

