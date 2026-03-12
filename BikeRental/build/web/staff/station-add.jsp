<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm trạm mới - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Thêm trạm mới</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/staff/station" method="POST">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label>Mã trạm:</label>
                    <input type="text" name="stationCode" required>
                </div>
                
                <div class="form-group">
                    <label>Tên trạm:</label>
                    <input type="text" name="name" required>
                </div>
                
                <div class="form-group">
                    <label>Địa chỉ:</label>
                    <textarea name="address" rows="3"></textarea>
                </div>
                
                <div class="form-group">
                    <label>Sức chứa:</label>
                    <input type="number" name="capacity" min="0" required>
                </div>
                
                <button type="submit" class="btn btn-success">Thêm trạm</button>
                <a href="${pageContext.request.contextPath}/staff/station?action=list" class="btn btn-warning">Hủy</a>
            </form>
        </div>
    </div>
</body>
</html>

