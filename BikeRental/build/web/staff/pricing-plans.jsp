<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý gói giá - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <h2>Quản lý gói giá</h2>
                <a href="${pageContext.request.contextPath}/staff/pricing-plan?action=add" class="btn btn-success">Thêm gói giá mới</a>
            </div>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/staff/pricing-plan" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
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
                        <a href="${pageContext.request.contextPath}/staff/pricing-plan?action=list" class="btn btn-secondary">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <c:if test="${empty plans}">
                <p class="text-center">Chưa có gói giá nào trong hệ thống.</p>
            </c:if>
            
            <c:if test="${not empty plans}">
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
                                <td>
                                    <%
                                        models.PricingPlan p = (models.PricingPlan)pageContext.getAttribute("plan");
                                        if (p.getUnlockFee() != null) {
                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                            out.print(nf.format(p.getUnlockFee().longValue()) + " VND");
                                        } else {
                                            out.print("0 VND");
                                        }
                                    %>
                                </td>
                                <td>
                                    <%
                                        if (p.getPricePerMin() != null) {
                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                            out.print(nf.format(p.getPricePerMin().longValue()) + " VND");
                                        } else {
                                            out.print("0 VND");
                                        }
                                    %>
                                </td>
                                <td>${plan.freeMinutes} phút</td>
                                <td>
                                    <%
                                        if (p.getDailyCap() != null) {
                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                            out.print(nf.format(p.getDailyCap().longValue()) + " VND");
                                        } else {
                                            out.print("Không giới hạn");
                                        }
                                    %>
                                </td>
                                <td>
                                    <%
                                        String statusClass = (p != null && p.isActive()) ? "status-available" : "status-maintenance";
                                        String statusText = (p != null && p.isActive()) ? "Hoạt động" : "Ngừng hoạt động";
                                    %>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= statusText %>
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/staff/pricing-plan?action=edit&id=${plan.planID}" class="btn btn-warning">Sửa</a>
                                    <form method="post" action="${pageContext.request.contextPath}/staff/pricing-plan" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa gói giá này? Hành động này không thể hoàn tác!');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="planID" value="${plan.planID}">
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

