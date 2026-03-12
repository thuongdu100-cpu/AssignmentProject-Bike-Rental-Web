<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sửa trạm - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Sửa thông tin trạm</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/staff/station" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="stationID" value="${station.stationID}">
                
                <div class="form-group">
                    <label>Mã trạm:</label>
                    <input type="text" name="stationCode" value="${station.stationCode}" required>
                </div>
                
                <div class="form-group">
                    <label>Tên trạm:</label>
                    <input type="text" name="name" value="${station.name}" required>
                </div>
                
                <div class="form-group">
                    <label>Địa chỉ:</label>
                    <textarea name="address" rows="3">${station.address}</textarea>
                </div>
                
                <div class="form-group">
                    <label>Sức chứa:</label>
                    <input type="number" name="capacity" min="0" value="${station.capacity}" required>
                </div>
                
                <div class="form-group">
                    <label>Trạng thái:</label>
                    <select name="isActive">
                        <option value="true" ${station.active ? 'selected' : ''}>Hoạt động</option>
                        <option value="false" ${!station.active ? 'selected' : ''}>Ngừng hoạt động</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-success">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/staff/station?action=list" class="btn btn-warning">Hủy</a>
            </form>
        </div>
    </div>
</body>
</html>

