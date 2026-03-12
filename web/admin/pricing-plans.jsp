<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý gói giá - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="d-flex justify-content-between">
                <h2>Quản lý gói giá</h2>
                <a href="${pageContext.request.contextPath}/admin/pricing-plan?action=add" class="btn btn-success">Thêm gói giá mới</a>
            </div>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/admin/pricing-plan" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                <input type="hidden" name="action" value="list">
                <div style="display: flex; gap: 1rem; align-items: end;">
                    <div style="flex: 1;">
                        <label>Từ khóa (Tên gói):</label>
                        <input type="text" name="keyword" value="${searchKeyword != null ? searchKeyword : ''}" placeholder="Nhập từ khóa..." style="width: 100%; padding: 0.5rem;">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/pricing-plan?action=list" class="btn btn-secondary">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên gói</th>
                        <th>Phí mở khóa</th>
                        <th>Giá/phút</th>
                        <th>Phút miễn phí</th>
                        <th>Giới hạn ngày</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="plan" items="${plans}">
                        <tr>
                            <td>${plan.planID}</td>
                            <td>${plan.planName}</td>
                            <td>${plan.unlockFee} VND</td>
                            <td>${plan.pricePerMin} VND</td>
                            <td>${plan.freeMinutes} phút</td>
                            <td>${plan.dailyCap != null ? plan.dailyCap : 'Không giới hạn'} VND</td>
                            <td>
                                <span class="status-badge ${plan.active ? 'status-available' : 'status-maintenance'}">
                                    ${plan.active ? 'Hoạt động' : 'Ngừng hoạt động'}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/pricing-plan?action=edit&id=${plan.planID}" class="btn btn-warning">Sửa</a>
                                <form method="post" action="${pageContext.request.contextPath}/admin/pricing-plan" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa gói giá này? Hành động này không thể hoàn tác!');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="planID" value="${plan.planID}">
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

