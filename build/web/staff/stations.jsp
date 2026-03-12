<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý trạm - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="d-flex justify-content-between">
                <h2>Quản lý trạm</h2>
                <a href="${pageContext.request.contextPath}/staff/station?action=add" class="btn btn-success">Thêm trạm mới</a>
            </div>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/staff/station" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                <input type="hidden" name="action" value="list">
                <div style="display: flex; gap: 1rem; align-items: end;">
                    <div style="flex: 1;">
                        <label>Từ khóa (Mã trạm, Tên, Địa chỉ):</label>
                        <input type="text" name="keyword" value="${searchKeyword != null ? searchKeyword : ''}" placeholder="Nhập từ khóa..." style="width: 100%; padding: 0.5rem;">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/station?action=list" class="btn btn-secondary">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Mã trạm</th>
                        <th>Tên trạm</th>
                        <th>Địa chỉ</th>
                        <th>Sức chứa</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="station" items="${stations}">
                        <tr>
                            <td>${station.stationID}</td>
                            <td>${station.stationCode}</td>
                            <td>${station.name}</td>
                            <td>${station.address}</td>
                            <td>${station.capacity}</td>
                            <td>
                                <span class="status-badge ${station.active ? 'status-available' : 'status-maintenance'}">
                                    ${station.active ? 'Hoạt động' : 'Ngừng hoạt động'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/staff/station?action=edit&id=${station.stationID}" class="btn btn-warning">Sửa</a>
                                <form method="post" action="${pageContext.request.contextPath}/staff/station" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa trạm này? Hành động này không thể hoàn tác!');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="stationID" value="${station.stationID}">
                                    <button type="submit" class="btn btn-danger">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

