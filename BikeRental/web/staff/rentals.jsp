<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<%@page import="java.text.SimpleDateFormat" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý thuê xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Quản lý thuê xe</h2>
            
            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/staff/rental" style="margin-bottom: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                <input type="hidden" name="action" value="list">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; align-items: end;">
                    <div>
                        <label>Từ khóa (Mã thuê, Tên KH, Email, Số seri xe):</label>
                        <input type="text" name="keyword" value="${searchKeyword != null ? searchKeyword : ''}" placeholder="Nhập từ khóa..." style="width: 100%; padding: 0.5rem;">
                    </div>
                    <div>
                        <label>Trạng thái:</label>
                        <select name="status" style="width: 100%; padding: 0.5rem;">
                            <option value="">Tất cả</option>
                            <option value="ongoing" ${searchStatus == 'ongoing' ? 'selected' : ''}>Đang thuê</option>
                            <option value="completed" ${searchStatus == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="cancelled" ${searchStatus == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">🔍 Tìm kiếm</button>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/rental?action=list" class="btn btn-secondary" style="width: 100%;">🔄 Làm mới</a>
                    </div>
                </div>
            </form>
            
            <c:if test="${empty rentals}">
                <p class="text-center">Chưa có giao dịch thuê xe nào.</p>
            </c:if>
            
            <c:if test="${not empty rentals}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã thuê</th>
                            <th>Khách hàng</th>
                            <th>Xe</th>
                            <th>Gói giá</th>
                            <th>Trạm bắt đầu</th>
                            <th>Trạm kết thúc</th>
                            <th>Thời gian</th>
                            <th>Chi phí</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="rental" items="${rentals}">
                            <%
                                models.Rental r = (models.Rental)pageContext.getAttribute("rental");
                            %>
                            <tr>
                                <td>#${rental.rentalID}</td>
                                <td>${rental.customer.fullName}<br><small>${rental.customer.email}</small></td>
                                <td>${rental.bike.serialNumber}</td>
                                <td>
                                    <c:if test="${rental.plan != null}">
                                        ${rental.plan.planName}
                                    </c:if>
                                    <c:if test="${rental.plan == null}">
                                        N/A
                                    </c:if>
                                </td>
                                <td>${rental.startStation.name}</td>
                                <td>${rental.endStation != null ? rental.endStation.name : 'Chưa kết thúc'}</td>
                                <td>
                                    <%
                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                        if (r != null && r.getStartTime() != null) {
                                            out.print(sdf.format(r.getStartTime()));
                                        }
                                        if (r != null && r.getEndTime() != null) {
                                            out.print(" → " + sdf.format(r.getEndTime()));
                                        }
                                    %>
                                </td>
                                <td>
                                    <c:if test="${rental.costAmount != null}">
                                        <%
                                            if (r != null && r.getCostAmount() != null) {
                                                NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                out.print(nf.format(r.getCostAmount().longValue()) + " VND");
                                            }
                                        %>
                                    </c:if>
                                    <c:if test="${rental.costAmount == null}">
                                        <c:if test="${rental.endTime == null}">
                                            <span style="color: #f39c12;">Đang tính...</span>
                                        </c:if>
                                        <c:if test="${rental.endTime != null}">
                                            Chưa tính
                                        </c:if>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="status-badge ${rental.status == 'ongoing' ? 'status-in-use' : rental.status == 'completed' ? 'status-available' : 'status-maintenance'}">
                                        ${rental.status == 'ongoing' ? 'Đang thuê' : rental.status == 'completed' ? 'Hoàn thành' : 'Đã hủy'}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/staff/rental?action=view&id=${rental.rentalID}" class="btn btn-primary">Xem chi tiết</a>
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

