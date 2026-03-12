<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý người dùng - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Quản lý người dùng</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/admin/user" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                <input type="hidden" name="action" value="list">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; align-items: end;">
                    <div>
                        <label>Từ khóa (Họ tên, Email, SĐT):</label>
                        <input type="text" name="keyword" value="${searchKeyword != null ? searchKeyword : ''}" placeholder="Nhập từ khóa..." style="width: 100%; padding: 0.5rem;">
                    </div>
                    <div>
                        <label>Vai trò:</label>
                        <select name="roleID" style="width: 100%; padding: 0.5rem;">
                            <option value="">Tất cả</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleID}" ${searchRoleID == role.roleID.toString() ? 'selected' : ''}>${role.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">🔍 Tìm kiếm</button>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/user?action=list" class="btn btn-secondary" style="width: 100%;">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.userID}</td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>${user.phone}</td>
                            <td>${user.role.roleName}</td>
                            <td>
                                <span class="status-badge ${user.active ? 'status-available' : 'status-maintenance'}">
                                    ${user.active ? 'Hoạt động' : 'Vô hiệu hóa'}
                                </span>
                            </td>
                            <td>${user.createdAt}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/user?action=edit&id=${user.userID}" class="btn btn-warning">Sửa</a>
                                <c:if test="${user.roleID != 1}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/user" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng này? Hành động này không thể hoàn tác!');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userID" value="${user.userID}">
                                        <button type="submit" class="btn btn-danger">Xóa</button>
                                    </form>
                                </c:if>
                                <c:if test="${user.roleID == 1}">
                                    <span class="btn btn-secondary" style="opacity: 0.5; cursor: not-allowed;" title="Không thể xóa tài khoản Admin">Xóa</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

