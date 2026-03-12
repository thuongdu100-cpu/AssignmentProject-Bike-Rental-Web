<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sửa thông tin xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Sửa thông tin xe đạp</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/staff/bike" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="bikeID" value="${bike.bikeID}">
                
                <div class="form-group">
                    <label>Số seri:</label>
                    <input type="text" name="serialNumber" value="${bike.serialNumber}" required>
                </div>
                
                <div class="form-group">
                    <label>Model:</label>
                    <select name="modelID" required>
                        <c:forEach var="model" items="${models}">
                            <option value="${model.modelID}" ${bike.modelID == model.modelID ? 'selected' : ''}>
                                ${model.modelName} - ${model.brand}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Trạm hiện tại:</label>
                    <select name="currentStationID">
                        <option value="">Không có</option>
                        <c:forEach var="station" items="${stations}">
                            <option value="${station.stationID}" ${bike.currentStationID == station.stationID ? 'selected' : ''}>
                                ${station.name} - ${station.stationCode}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select name="status" required>
                        <option value="available" ${bike.status == 'available' ? 'selected' : ''}>Có sẵn</option>
                        <option value="in_use" ${bike.status == 'in_use' ? 'selected' : ''}>Đang thuê</option>
                        <option value="maintenance" ${bike.status == 'maintenance' ? 'selected' : ''}>Bảo trì</option>
                        <option value="lost" ${bike.status == 'lost' ? 'selected' : ''}>Mất</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Pin (%):</label>
                    <input type="number" name="batteryPercent" min="0" max="100" value="${bike.batteryPercent}">
                </div>
                
                <div class="form-group">
                    <label>URL ảnh:</label>
                    <input type="url" name="imageURL" value="${bike.imageURL}">
                </div>
                
                <button type="submit" class="btn btn-success">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/staff/bike?action=list" class="btn btn-warning">Hủy</a>
            </form>
        </div>
    </div>
</body>
</html>

