<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Lịch sử thuê xe - Bike Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Lịch sử thuê xe</h2>
            
            <c:if test="${empty rentals}">
                <p class="text-center">Bạn chưa có lịch sử thuê xe nào.</p>
            </c:if>
            
            <c:if test="${not empty rentals}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã thuê</th>
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
                            <tr>
                                <td>#${rental.rentalID}</td>
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
                                    <c:if test="${rental.endTime != null}">
                                        <%
                                            models.Rental r = (models.Rental)pageContext.getAttribute("rental");
                                            if (r.getEndTime() != null && r.getStartTime() != null) {
                                                long duration = (r.getEndTime().getTime() - r.getStartTime().getTime()) / (1000 * 60);
                                                pageContext.setAttribute("rentalDuration", duration);
                                            }
                                        %>
                                        ${rentalDuration} phút
                                        <br><small>${rental.startTime} → ${rental.endTime}</small>
                                    </c:if>
                                    <c:if test="${rental.endTime == null}">
                                        Đang thuê
                                        <br><small>Bắt đầu: ${rental.startTime}</small>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${rental.costAmount != null}">
                                        <%
                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                            models.Rental r = (models.Rental)pageContext.getAttribute("rental");
                                            pageContext.setAttribute("costFormatted", nf.format(r.getCostAmount().longValue()));
                                            if (r.getPlan() != null) {
                                                pageContext.setAttribute("planUnlockFeeFormatted", nf.format(r.getPlan().getUnlockFee().longValue()));
                                                pageContext.setAttribute("planPricePerMinFormatted", nf.format(r.getPlan().getPricePerMin().longValue()));
                                            }
                                        %>
                                        <strong style="color: #1976d2; font-size: 1.1rem;">
                                            ${costFormatted} VND
                                        </strong>
                                        <c:if test="${rental.plan != null}">
                                            <br><small style="color: #666;">
                                                (Mở khóa: ${planUnlockFeeFormatted} + 
                                                <c:if test="${rentalDuration != null && rentalDuration > rental.plan.freeMinutes}">
                                                    ${rentalDuration - rental.plan.freeMinutes} phút × 
                                                    ${planPricePerMinFormatted})
                                                </c:if>
                                                <c:if test="${rentalDuration == null || rentalDuration <= rental.plan.freeMinutes}">
                                                    Miễn phí)
                                                </c:if>
                                            </small>
                                        </c:if>
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
                                    <span class="status-badge ${rental.status == 'ongoing' ? 'status-in-use' : rental.status == 'completed' ? 'status-available' : ''}">
                                        ${rental.status == 'ongoing' ? 'Đang thuê' : rental.status == 'completed' ? 'Hoàn thành' : 'Đã hủy'}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${rental.status == 'ongoing' || rental.endTime == null}">
                                        <a href="${pageContext.request.contextPath}/rental?action=ongoing" class="btn btn-danger" style="padding: 0.5rem 1rem; font-size: 0.9rem;">
                                            Trả xe
                                        </a>
                                    </c:if>
                                    <c:if test="${rental.status == 'completed' && rental.endTime != null}">
                                        <a href="${pageContext.request.contextPath}/rental?action=invoice&rentalID=${rental.rentalID}" class="btn btn-primary" style="padding: 0.5rem 1rem; font-size: 0.9rem;">
                                            Xem hóa đơn
                                        </a>
                                    </c:if>
                                    <c:if test="${rental.status != 'ongoing' && rental.status != 'completed' && rental.endTime != null}">
                                        <span style="color: #999;">-</span>
                                    </c:if>
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
