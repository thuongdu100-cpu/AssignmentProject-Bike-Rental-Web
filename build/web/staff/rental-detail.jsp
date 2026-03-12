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
    <title>Chi tiết thuê xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .rental-detail-container {
            max-width: 1200px;
            margin: 2rem auto;
        }
        .rental-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px 12px 0 0;
            text-align: center;
        }
        .rental-header h1 {
            margin: 0;
            font-size: 2.5rem;
            font-weight: 600;
        }
        .rental-header .rental-id {
            font-size: 1.2rem;
            margin-top: 0.5rem;
            opacity: 0.9;
        }
        .rental-body {
            background: white;
            padding: 2rem;
            border-radius: 0 0 12px 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .info-section {
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .info-section h3 {
            margin: 0 0 1.5rem 0;
            color: #333;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .info-item {
            padding: 1rem;
            background: white;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .info-label {
            display: block;
            font-weight: 600;
            color: #666;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        .info-value {
            display: block;
            font-size: 1.1rem;
            color: #333;
            word-break: break-word;
        }
        .bike-image-container {
            margin-top: 1rem;
            text-align: center;
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
        }
        .bike-image {
            max-width: 100%;
            max-height: 500px;
            width: auto;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            object-fit: contain;
        }
        .status-large {
            font-size: 1.2rem;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
        }
        .cost-highlight {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1976d2;
        }
        .timeline {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1rem 0;
            padding: 1rem;
            background: white;
            border-radius: 8px;
        }
        .timeline-icon {
            font-size: 2rem;
        }
        .timeline-content {
            flex: 1;
        }
        .timeline-time {
            font-size: 0.9rem;
            color: #666;
        }
        @media print {
            .no-print {
                display: none;
            }
        }
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
        models.Rental r = (models.Rental) request.getAttribute("rental");
        models.Payment payment = (models.Payment) request.getAttribute("payment");
    %>
    <div class="container">
        <div class="rental-detail-container">
            <div class="rental-header">
                <h1>📋 Chi tiết thuê xe</h1>
                <div class="rental-id">Mã thuê: #${rental.rentalID}</div>
            </div>
            
            <div class="rental-body">
                <!-- Trạng thái và chi phí nổi bật -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 2rem;">
                    <div style="padding: 1.5rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; color: white; text-align: center;">
                        <div style="font-size: 0.9rem; opacity: 0.9; margin-bottom: 0.5rem;">Trạng thái</div>
                        <div style="font-size: 1.5rem; font-weight: 600;">
                            <%
                                String statusText = "";
                                String statusClass = "";
                                if (r != null) {
                                    if ("ongoing".equals(r.getStatus())) {
                                        statusText = "Đang thuê";
                                        statusClass = "status-in-use";
                                    } else if ("completed".equals(r.getStatus())) {
                                        statusText = "Hoàn thành";
                                        statusClass = "status-available";
                                    } else {
                                        statusText = "Đã hủy";
                                        statusClass = "status-maintenance";
                                    }
                                }
                            %>
                            <%= statusText %>
                        </div>
                    </div>
                    <div style="padding: 1.5rem; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); border-radius: 8px; color: white; text-align: center;">
                        <div style="font-size: 0.9rem; opacity: 0.9; margin-bottom: 0.5rem;">Chi phí</div>
                        <div class="cost-highlight" style="color: white;">
                            <%
                                if (r != null && r.getCostAmount() != null) {
                                    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                    out.print(nf.format(r.getCostAmount().longValue()) + " VND");
                                } else {
                                    out.print("<span style='font-size: 1rem;'>Chưa tính</span>");
                                }
                            %>
                        </div>
                    </div>
                </div>
                
                <!-- Thông tin khách hàng -->
                <div class="info-section">
                    <h3>👤 Thông tin khách hàng</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Mã khách hàng</span>
                            <span class="info-value">#${rental.customerID}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Họ và tên</span>
                            <span class="info-value">${rental.customer.fullName}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Email</span>
                            <span class="info-value">${rental.customer.email}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Số điện thoại</span>
                            <span class="info-value">${rental.customer.phone != null && !empty rental.customer.phone ? rental.customer.phone : 'Chưa cập nhật'}</span>
                        </div>
                        <c:if test="${rental.customer.role != null}">
                            <div class="info-item">
                                <span class="info-label">Vai trò</span>
                                <span class="info-value">${rental.customer.role.roleName}</span>
                            </div>
                        </c:if>
                        <div class="info-item">
                            <span class="info-label">Trạng thái</span>
                            <span class="info-value">
                                <%
                                    String customerStatusText = "N/A";
                                    String customerStatusClass = "status-maintenance";
                                    if (r != null && r.getCustomer() != null) {
                                        if (r.getCustomer().isActive()) {
                                            customerStatusText = "Hoạt động";
                                            customerStatusClass = "status-available";
                                        } else {
                                            customerStatusText = "Vô hiệu hóa";
                                            customerStatusClass = "status-maintenance";
                                        }
                                    }
                                %>
                                <span class="status-badge <%= customerStatusClass %>">
                                    <%= customerStatusText %>
                                </span>
                            </span>
                        </div>
                        <c:if test="${rental.customer.createdAt != null}">
                            <div class="info-item">
                                <span class="info-label">Ngày tạo tài khoản</span>
                                <span class="info-value">
                                    <%
                                        if (r != null && r.getCustomer() != null && r.getCustomer().getCreatedAt() != null) {
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                            out.print(sdf.format(r.getCustomer().getCreatedAt()));
                                        }
                                    %>
                                </span>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Thông tin xe -->
                <div class="info-section">
                    <h3>🚴 Thông tin xe</h3>
                    
                    <!-- Hiển thị ảnh xe nổi bật -->
                    <c:if test="${rental.bike.imageURL != null && !empty rental.bike.imageURL}">
                        <div class="bike-image-container" style="margin-bottom: 1.5rem;">
                            <img src="${rental.bike.imageURL}" alt="Xe đạp ${rental.bike.serialNumber}" class="bike-image" 
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/no-image.png'; this.style.display='block';">
                        </div>
                    </c:if>
                    <c:if test="${rental.bike.imageURL == null || empty rental.bike.imageURL}">
                        <div class="bike-image-container" style="margin-bottom: 1.5rem; padding: 3rem; background: #f0f0f0; border-radius: 8px; text-align: center; color: #999;">
                            <div style="font-size: 3rem; margin-bottom: 0.5rem;">🚴</div>
                            <div>Chưa có ảnh xe</div>
                        </div>
                    </c:if>
                    
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Mã xe</span>
                            <span class="info-value">#${rental.bikeID}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Số seri</span>
                            <span class="info-value">${rental.bike.serialNumber}</span>
                        </div>
                        <c:if test="${rental.bike.model != null}">
                            <div class="info-item">
                                <span class="info-label">Model</span>
                                <span class="info-value">${rental.bike.model.modelName}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Thương hiệu</span>
                                <span class="info-value">${rental.bike.model.brand != null ? rental.bike.model.brand : 'N/A'}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Loại xe</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${rental.bike.model.typeName == 'standard'}">Xe đạp thường</c:when>
                                        <c:when test="${rental.bike.model.typeName == 'ebike'}">Xe đạp điện</c:when>
                                        <c:when test="${rental.bike.model.typeName == 'cargo'}">Xe đạp hàng</c:when>
                                        <c:otherwise>${rental.bike.model.typeName}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <c:if test="${rental.bike.model.weightKg != null}">
                                <div class="info-item">
                                    <span class="info-label">Trọng lượng</span>
                                    <span class="info-value">${rental.bike.model.weightKg} kg</span>
                                </div>
                            </c:if>
                            <div class="info-item">
                                <span class="info-label">Có pin</span>
                                <span class="info-value">
                                    <span class="status-badge ${rental.bike.model.hasBattery ? 'status-available' : 'status-maintenance'}">
                                        ${rental.bike.model.hasBattery ? 'Có' : 'Không'}
                                    </span>
                                </span>
                            </div>
                        </c:if>
                        <div class="info-item">
                            <span class="info-label">Trạng thái xe</span>
                            <span class="info-value">
                                <span class="status-badge ${rental.bike.status == 'available' ? 'status-available' : rental.bike.status == 'in_use' ? 'status-in-use' : 'status-maintenance'}">
                                    ${rental.bike.status == 'available' ? 'Có sẵn' : rental.bike.status == 'in_use' ? 'Đang thuê' : 'Bảo trì'}
                                </span>
                            </span>
                        </div>
                        <c:if test="${rental.bike.batteryPercent != null}">
                            <div class="info-item">
                                <span class="info-label">Pin</span>
                                <span class="info-value">${rental.bike.batteryPercent}%</span>
                            </div>
                        </c:if>
                        <c:if test="${rental.bike.station != null}">
                            <div class="info-item">
                                <span class="info-label">Trạm hiện tại</span>
                                <span class="info-value">${rental.bike.station.name != null ? rental.bike.station.name : 'N/A'}</span>
                            </div>
                        </c:if>
                        <c:if test="${rental.bike.createdAt != null}">
                            <div class="info-item">
                                <span class="info-label">Ngày tạo</span>
                                <span class="info-value">
                                    <%
                                        if (r != null && r.getBike() != null && r.getBike().getCreatedAt() != null) {
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                            out.print(sdf.format(r.getBike().getCreatedAt()));
                                        }
                                    %>
                                </span>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Thông tin thuê xe -->
                <div class="info-section">
                    <h3>📅 Thông tin thuê xe</h3>
                    
                    <!-- Timeline -->
                    <div class="timeline">
                        <div class="timeline-icon">📍</div>
                        <div class="timeline-content">
                            <div style="font-weight: 600; margin-bottom: 0.25rem;">Trạm bắt đầu</div>
                            <div>${rental.startStation.name}</div>
                            <c:if test="${rental.startStation.stationCode != null}">
                                <div class="timeline-time">Mã trạm: ${rental.startStation.stationCode}</div>
                            </c:if>
                            <c:if test="${rental.startStation.address != null}">
                                <div class="timeline-time">📍 ${rental.startStation.address}</div>
                            </c:if>
                            <c:if test="${rental.startStation.capacity > 0}">
                                <div class="timeline-time">Sức chứa: ${rental.startStation.capacity} xe</div>
                            </c:if>
                        </div>
                        <div class="timeline-time">
                            <%
                                if (r != null && r.getStartTime() != null) {
                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                    String formattedDate = sdf.format(r.getStartTime());
                                    formattedDate = formattedDate.replace(" ", "<br>");
                                    out.print(formattedDate);
                                }
                            %>
                        </div>
                    </div>
                    
                    <c:if test="${rental.endStation != null}">
                        <div class="timeline" style="border-top: 2px dashed #ddd; padding-top: 1rem; margin-top: 1rem;">
                            <div class="timeline-icon">🏁</div>
                            <div class="timeline-content">
                                <div style="font-weight: 600; margin-bottom: 0.25rem;">Trạm kết thúc</div>
                                <div>${rental.endStation.name}</div>
                                <c:if test="${rental.endStation.stationCode != null}">
                                    <div class="timeline-time">Mã trạm: ${rental.endStation.stationCode}</div>
                                </c:if>
                                <c:if test="${rental.endStation.address != null}">
                                    <div class="timeline-time">📍 ${rental.endStation.address}</div>
                                </c:if>
                                <c:if test="${rental.endStation.capacity > 0}">
                                    <div class="timeline-time">Sức chứa: ${rental.endStation.capacity} xe</div>
                                </c:if>
                            </div>
                            <div class="timeline-time">
                                <%
                                    if (r != null && r.getEndTime() != null) {
                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                        String formattedDate = sdf.format(r.getEndTime());
                                        formattedDate = formattedDate.replace(" ", "<br>");
                                        out.print(formattedDate);
                                    }
                                %>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="info-grid" style="margin-top: 1.5rem;">
                        <div class="info-item">
                            <span class="info-label">Thời gian bắt đầu</span>
                            <span class="info-value">
                                <%
                                    if (r != null && r.getStartTime() != null) {
                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                        out.print(sdf.format(r.getStartTime()));
                                    }
                                %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Thời gian kết thúc</span>
                            <span class="info-value">
                                <%
                                    if (r != null && r.getEndTime() != null) {
                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                        out.print(sdf.format(r.getEndTime()));
                                    } else {
                                        out.print("<span style='color: #f39c12;'>Chưa kết thúc</span>");
                                    }
                                %>
                            </span>
                        </div>
                        <c:if test="${rental.endTime != null && rental.startTime != null}">
                            <div class="info-item">
                                <span class="info-label">Thời lượng thuê</span>
                                <span class="info-value">
                                    <%
                                        if (r != null && r.getEndTime() != null && r.getStartTime() != null) {
                                            long duration = (r.getEndTime().getTime() - r.getStartTime().getTime()) / (1000 * 60);
                                            long hours = duration / 60;
                                            long minutes = duration % 60;
                                            if (hours > 0) {
                                                out.print(hours + " giờ " + minutes + " phút");
                                            } else {
                                                out.print(minutes + " phút");
                                            }
                                        }
                                    %>
                                </span>
                            </div>
                        </c:if>
                        <div class="info-item">
                            <span class="info-label">Ngày tạo</span>
                            <span class="info-value">
                                <%
                                    if (r != null && r.getCreatedAt() != null) {
                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                        out.print(sdf.format(r.getCreatedAt()));
                                    }
                                %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- Thông tin gói giá -->
                <c:if test="${rental.plan != null}">
                    <div class="info-section">
                        <h3>💰 Gói giá</h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Tên gói</span>
                                <span class="info-value">${rental.plan.planName}</span>
                            </div>
                            <c:if test="${rental.plan.unlockFee != null}">
                                <div class="info-item">
                                    <span class="info-label">Phí mở khóa</span>
                                    <span class="info-value">
                                        <%
                                            if (r != null && r.getPlan() != null && r.getPlan().getUnlockFee() != null) {
                                                NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                out.print(nf.format(r.getPlan().getUnlockFee().longValue()) + " VND");
                                            }
                                        %>
                                    </span>
                                </div>
                            </c:if>
                            <c:if test="${rental.plan.pricePerMin != null}">
                                <div class="info-item">
                                    <span class="info-label">Giá mỗi phút</span>
                                    <span class="info-value">
                                        <%
                                            if (r != null && r.getPlan() != null && r.getPlan().getPricePerMin() != null) {
                                                NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                out.print(nf.format(r.getPlan().getPricePerMin().longValue()) + " VND/phút");
                                            }
                                        %>
                                    </span>
                                </div>
                            </c:if>
                            <c:if test="${rental.plan.freeMinutes > 0}">
                                <div class="info-item">
                                    <span class="info-label">Phút miễn phí</span>
                                    <span class="info-value">${rental.plan.freeMinutes} phút</span>
                                </div>
                            </c:if>
                            <c:if test="${rental.plan.dailyCap != null}">
                                <div class="info-item">
                                    <span class="info-label">Giới hạn ngày</span>
                                    <span class="info-value">
                                        <%
                                            if (r != null && r.getPlan() != null && r.getPlan().getDailyCap() != null) {
                                                NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                out.print(nf.format(r.getPlan().getDailyCap().longValue()) + " VND");
                                            }
                                        %>
                                    </span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>
                
                <!-- Thông tin thanh toán -->
                <c:if test="${payment != null}">
                    <div class="info-section">
                        <h3>💳 Thông tin thanh toán</h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Mã thanh toán</span>
                                <span class="info-value">#${payment.paymentID}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Số tiền</span>
                                <span class="info-value">
                                    <%
                                        if (payment != null && payment.getAmount() != null) {
                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                            out.print(nf.format(payment.getAmount().longValue()) + " VND");
                                        }
                                    %>
                                </span>
                            </div>
                            <c:if test="${payment.currency != null}">
                                <div class="info-item">
                                    <span class="info-label">Loại tiền tệ</span>
                                    <span class="info-value">${payment.currency}</span>
                                </div>
                            </c:if>
                            <div class="info-item">
                                <span class="info-label">Phương thức</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${payment.method == 'cash'}">Tiền mặt</c:when>
                                        <c:when test="${payment.method == 'card'}">Thẻ</c:when>
                                        <c:when test="${payment.method == 'ewallet'}">Ví điện tử (VNPay)</c:when>
                                        <c:otherwise>${payment.method}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <c:if test="${payment.transactionRef != null && !empty payment.transactionRef}">
                                <div class="info-item">
                                    <span class="info-label">Mã giao dịch</span>
                                    <span class="info-value">${payment.transactionRef}</span>
                                </div>
                            </c:if>
                            <div class="info-item">
                                <span class="info-label">Trạng thái</span>
                                <span class="info-value">
                                    <%
                                        String paymentStatusText = "";
                                        String paymentStatusClass = "";
                                        if (payment != null) {
                                            String status = payment.getStatus();
                                            if ("paid".equals(status)) {
                                                paymentStatusText = "Đã thanh toán";
                                                paymentStatusClass = "status-available";
                                            } else if ("pending".equals(status)) {
                                                paymentStatusText = "Chờ thanh toán";
                                                paymentStatusClass = "status-in-use";
                                            } else if ("failed".equals(status)) {
                                                paymentStatusText = "Thất bại";
                                                paymentStatusClass = "status-maintenance";
                                            } else {
                                                paymentStatusText = status;
                                                paymentStatusClass = "status-maintenance";
                                            }
                                        }
                                    %>
                                    <span class="status-badge <%= paymentStatusClass %>">
                                        <%= paymentStatusText %>
                                    </span>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Ngày thanh toán</span>
                                <span class="info-value">
                                    <%
                                        if (payment != null && payment.getCreatedAt() != null) {
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                            out.print(sdf.format(payment.getCreatedAt()));
                                        }
                                    %>
                                </span>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Chi tiết tính toán chi phí -->
                <c:if test="${rental.costAmount != null && rental.plan != null && rental.endTime != null && rental.startTime != null}">
                    <div class="info-section">
                        <h3>🧮 Chi tiết tính toán</h3>
                        <div style="padding: 1.5rem; background: white; border-radius: 8px;">
                            <%
                                if (r != null && r.getEndTime() != null && r.getStartTime() != null && r.getPlan() != null) {
                                    long duration = (r.getEndTime().getTime() - r.getStartTime().getTime()) / (1000 * 60);
                                    long billableMinutes = Math.max(0, duration - r.getPlan().getFreeMinutes());
                                    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                    
                                    out.print("<div style='margin-bottom: 0.75rem;'><strong>Thời lượng:</strong> " + duration + " phút</div>");
                                    out.print("<div style='margin-bottom: 0.75rem;'><strong>Phút miễn phí:</strong> " + r.getPlan().getFreeMinutes() + " phút</div>");
                                    out.print("<div style='margin-bottom: 0.75rem;'><strong>Phút tính phí:</strong> " + billableMinutes + " phút</div>");
                                    
                                    if (r.getPlan().getUnlockFee() != null) {
                                        out.print("<div style='margin-bottom: 0.75rem;'><strong>Phí mở khóa:</strong> " + nf.format(r.getPlan().getUnlockFee().longValue()) + " VND</div>");
                                    }
                                    
                                    if (billableMinutes > 0 && r.getPlan().getPricePerMin() != null) {
                                        long timeCost = billableMinutes * r.getPlan().getPricePerMin().longValue();
                                        out.print("<div style='margin-bottom: 0.75rem;'><strong>Phí thời gian (" + billableMinutes + " phút):</strong> " + nf.format(timeCost) + " VND</div>");
                                    }
                                    
                                    if (r.getCostAmount() != null) {
                                        out.print("<div style='margin-top: 1rem; padding-top: 1rem; border-top: 2px solid #667eea;'><strong style='font-size: 1.2rem;'>Tổng cộng:</strong> <span style='color: #1976d2; font-size: 1.3rem; font-weight: 700;'>" + nf.format(r.getCostAmount().longValue()) + " VND</span></div>");
                                    }
                                }
                            %>
                        </div>
                    </div>
                </c:if>
                
                <!-- Actions -->
                <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: center;" class="no-print">
                    <a href="${pageContext.request.contextPath}/staff/rental?action=list" class="btn btn-secondary">← Quay lại danh sách</a>
                    <c:if test="${rental.status == 'completed' && payment != null && payment.status == 'paid'}">
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
