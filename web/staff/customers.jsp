<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.SimpleDateFormat" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý khách hàng - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Quản lý khách hàng</h2>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/staff/customer" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                <input type="hidden" name="action" value="list">
                <div style="display: flex; gap: 1rem; align-items: end;">
                    <div style="flex: 1;">
                        <label>Từ khóa (Họ tên, Email, SĐT):</label>
                        <input type="text" name="keyword" value="${searchKeyword != null ? searchKeyword : ''}" placeholder="Nhập từ khóa..." style="width: 100%; padding: 0.5rem;">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/customer?action=list" class="btn btn-secondary">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <c:if test="${empty customers}">
                <p class="text-center">Chưa có khách hàng nào trong hệ thống.</p>
            </c:if>
            
            <c:if test="${not empty customers}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th>Ngày đăng ký</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="customer" items="${customers}">
                            <tr>
                                <td>${customer.userID}</td>
                                <td>${customer.fullName}</td>
                                <td>${customer.email}</td>
                                <td>${customer.phone != null && !empty customer.phone ? customer.phone : 'Chưa cập nhật'}</td>
                                <td>
                                    <%
                                        models.User u = (models.User)pageContext.getAttribute("customer");
                                        String statusClass = (u != null && u.isActive()) ? "status-available" : "status-maintenance";
                                        String statusText = (u != null && u.isActive()) ? "Hoạt động" : "Vô hiệu hóa";
                                    %>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= statusText %>
                                    </span>
                                </td>
                                <td>
                                    <%
                                        if (u != null && u.getCreatedAt() != null) {
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                            out.print(sdf.format(u.getCreatedAt()));
                                        } else {
                                            out.print("N/A");
                                        }
                                    %>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/staff/customer?action=edit&id=${customer.userID}" class="btn btn-warning">Sửa</a>
                                    <form method="post" action="${pageContext.request.contextPath}/staff/customer" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa khách hàng này? Hành động này không thể hoàn tác!');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userID" value="${customer.userID}">
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

