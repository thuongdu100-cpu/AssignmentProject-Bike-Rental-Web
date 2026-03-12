<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    models.User user = (models.User) userObj;
    String role = (String) session.getAttribute("role");
    String contextPath = request.getContextPath();
%>
<nav class="navbar">
    <div class="navbar-content">
        <a href="<%= role.equals("Admin") ? contextPath + "/admin/dashboard" : role.equals("Staff") ? contextPath + "/staff/dashboard.jsp" : contextPath + "/customer-bikes" %>" class="navbar-brand">🚴 Bike Rental</a>
        <ul class="navbar-menu">
            <li><a href="<%= role.equals("Admin") ? contextPath + "/admin/dashboard" : role.equals("Staff") ? contextPath + "/staff/dashboard.jsp" : contextPath + "/customer-bikes" %>">Trang chủ</a></li>
            <% if ("Customer".equals(role)) { %>
                <li><a href="<%= contextPath %>/customer-bikes">Xem xe</a></li>
                <li><a href="<%= contextPath %>/rental?action=list">Lịch sử thuê</a></li>
                <li><a href="<%= contextPath %>/profile">Hồ sơ</a></li>
            <% } else if ("Staff".equals(role)) { %>
                <li><a href="<%= contextPath %>/staff/bike?action=list">Quản lý xe</a></li>
                <li><a href="<%= contextPath %>/staff/station?action=list">Quản lý trạm</a></li>
                <li><a href="<%= contextPath %>/staff/customer?action=list">Quản lý khách hàng</a></li>
                <li><a href="<%= contextPath %>/staff/bike-model?action=list">Quản lý model</a></li>
                <li><a href="<%= contextPath %>/staff/pricing-plan?action=list">Quản lý gói giá</a></li>
                <li><a href="<%= contextPath %>/staff/rental?action=list">Quản lý thuê xe</a></li>
                <li><a href="<%= contextPath %>/profile">Hồ sơ</a></li>
            <% } else if ("Admin".equals(role)) { %>
                <li><a href="<%= contextPath %>/admin/user?action=list">Quản lý người dùng</a></li>
                <li><a href="<%= contextPath %>/admin/pricing-plan?action=list">Quản lý gói giá</a></li>
                <li><a href="<%= contextPath %>/profile">Hồ sơ</a></li>
            <% } %>
            <li><a href="<%= contextPath %>/logout">Đăng xuất (<%= user.getFullName() %>)</a></li>
        </ul>
    </div>
</nav>

<!-- Chatbot Widget -->
<link rel="stylesheet" href="<%= contextPath %>/css/chatbot.css">
<jsp:include page="../chatbot/chatbot-widget.jsp"/>

