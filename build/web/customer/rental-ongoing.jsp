<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đang thuê xe - Bike Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .cost-display {
            background: #e3f2fd;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 1rem 0;
            border: 2px solid #2196f3;
        }
        .cost-amount {
            font-size: 2rem;
            font-weight: bold;
            color: #1976d2;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Đang thuê xe</h2>
            
            <c:if test="${error != null}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <c:if test="${rental != null}">
                <div style="margin-top: 2rem;">
                    <p><strong>Mã thuê:</strong> #${rental.rentalID}</p>
                    <p><strong>Xe:</strong> ${rental.bike.serialNumber} - ${rental.bike.model.modelName}</p>
                    <p><strong>Trạm bắt đầu:</strong> ${rental.startStation.name}</p>
                    <p><strong>Thời gian bắt đầu:</strong> ${rental.startTime}</p>
                    <p><strong>Gói giá:</strong> ${rental.plan != null ? rental.plan.planName : 'Không có'}</p>
                    
                    <div class="form-group" style="margin-top: 1rem;">
                        <label><strong>Thời gian thuê (phút):</strong></label>
                        <input type="number" name="rentalMinutes" id="rentalMinutes" min="1" 
                               value="${rentalMinutes != null ? rentalMinutes : 30}" required 
                               style="width: 200px; padding: 0.5rem; border: 1px solid #ddd; border-radius: 4px; font-size: 1.1rem;">
                        <small style="color: #666; display: block; margin-top: 0.5rem;">Thay đổi số phút để xem chi phí cập nhật</small>
                    </div>
                    
                    <%
                        // Get rental minutes from request attribute (set by controller)
                        Integer rentalMinutes = (Integer)request.getAttribute("rentalMinutes");
                        if (rentalMinutes == null) {
                            rentalMinutes = 30; // Default
                        }
                        long duration = rentalMinutes.longValue();
                        request.setAttribute("duration", duration);
                        
                        // Calculate estimated cost based on selected minutes
                        models.Rental rental = (models.Rental)request.getAttribute("rental");
                        models.PricingPlan plan = rental.getPlan();
                        double estimatedCost = 0.0;
                        int billableMinutes = 0;
                        
                        if (plan != null) {
                            double unlockFee = plan.getUnlockFee() != null ? plan.getUnlockFee().doubleValue() : 0.0;
                            double pricePerMin = plan.getPricePerMin() != null ? plan.getPricePerMin().doubleValue() : 0.0;
                            int freeMinutes = plan.getFreeMinutes();
                            billableMinutes = (int)Math.max(0, duration - freeMinutes);
                            estimatedCost = unlockFee + (billableMinutes * pricePerMin);
                            if (plan.getDailyCap() != null && estimatedCost > plan.getDailyCap().doubleValue()) {
                                estimatedCost = plan.getDailyCap().doubleValue();
                            }
                        }
                        request.setAttribute("estimatedCost", estimatedCost);
                        request.setAttribute("billableMinutes", billableMinutes);
                    %>
                    
                    <div class="cost-display">
                        <p><strong>Thời gian thuê:</strong> <span id="duration">${duration}</span> phút</p>
                        <p><strong>Chi phí ước tính:</strong></p>
                        <%
                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                            pageContext.setAttribute("estimatedCostFormatted", nf.format(Math.round((Double)request.getAttribute("estimatedCost"))));
                            models.Rental r = (models.Rental)request.getAttribute("rental");
                            if (r.getPlan() != null) {
                                if (r.getPlan().getUnlockFee() != null) {
                                    pageContext.setAttribute("unlockFeeFormatted", nf.format(r.getPlan().getUnlockFee().longValue()));
                                } else {
                                    pageContext.setAttribute("unlockFeeFormatted", "0");
                                }
                                if (r.getPlan().getPricePerMin() != null) {
                                    pageContext.setAttribute("pricePerMinFormatted", nf.format(r.getPlan().getPricePerMin().longValue()));
                                } else {
                                    pageContext.setAttribute("pricePerMinFormatted", "0");
                                }
                                if (r.getPlan().getDailyCap() != null) {
                                    pageContext.setAttribute("dailyCapFormatted", nf.format(r.getPlan().getDailyCap().longValue()));
                                }
                            } else {
                                pageContext.setAttribute("unlockFeeFormatted", "0");
                                pageContext.setAttribute("pricePerMinFormatted", "0");
                            }
                        %>
                        <div class="cost-amount" id="costAmount">${estimatedCostFormatted} VND</div>
                        <small>
                            Phí mở khóa: ${unlockFeeFormatted} VND + 
                            (<span id="billableMinutes">${billableMinutes}</span> phút × 
                            ${pricePerMinFormatted} VND/phút)
                            <c:if test="${rental.plan.dailyCap != null}">
                                <br><span id="dailyCapInfo">Giới hạn ngày: ${dailyCapFormatted} VND</span>
                            </c:if>
                        </small>
                    </div>
                    
                    <form action="rental" method="POST" style="margin-top: 2rem;" id="endRentalForm">
                        <input type="hidden" name="action" value="end">
                        <input type="hidden" name="rentalID" value="${rental.rentalID}">
                        <input type="hidden" name="rentalMinutes" id="rentalMinutesHidden" value="${rentalMinutes != null ? rentalMinutes : 30}">
                        
                        <div class="form-group">
                            <label>Trạm kết thúc:</label>
                            <select name="endStationID" required>
                                <c:forEach var="station" items="${stations}">
                                    <option value="${station.stationID}">
                                        ${station.name} - ${station.stationCode}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-danger">Kết thúc thuê</button>
                    </form>
                </div>
            </c:if>
        </div>
    </div>
    
    <script>
        <%
            models.Rental r = (models.Rental)request.getAttribute("rental");
            double unlockFeeJs = 0.0;
            double pricePerMinJs = 0.0;
            int freeMinutesJs = 0;
            Double dailyCapJs = null;
            if (r != null && r.getPlan() != null) {
                models.PricingPlan plan = r.getPlan();
                unlockFeeJs = plan.getUnlockFee() != null ? plan.getUnlockFee().doubleValue() : 0.0;
                pricePerMinJs = plan.getPricePerMin() != null ? plan.getPricePerMin().doubleValue() : 0.0;
                freeMinutesJs = plan.getFreeMinutes();
                dailyCapJs = plan.getDailyCap() != null ? plan.getDailyCap().doubleValue() : null;
            }
        %>
        const unlockFee = <%= unlockFeeJs %>;
        const pricePerMin = <%= pricePerMinJs %>;
        const freeMinutes = <%= freeMinutesJs %>;
        const dailyCap = <%= dailyCapJs != null ? dailyCapJs : "null" %>;
        
        function updateCost() {
            const durationMinutes = parseInt(document.getElementById('rentalMinutes').value) || 30;
            document.getElementById('duration').textContent = durationMinutes;
            
            const billableMinutes = Math.max(0, durationMinutes - freeMinutes);
            document.getElementById('billableMinutes').textContent = billableMinutes;
            
            let estimatedCost = unlockFee + (billableMinutes * pricePerMin);
            if (dailyCap !== null && estimatedCost > dailyCap) {
                estimatedCost = dailyCap;
                if (document.getElementById('dailyCapInfo')) {
                    document.getElementById('dailyCapInfo').innerHTML = 
                        '<strong>Đã đạt giới hạn ngày: ' + formatNumber(dailyCap) + ' VND</strong>';
                }
            } else {
                if (document.getElementById('dailyCapInfo')) {
                    <%
                        if (r.getPlan() != null && r.getPlan().getDailyCap() != null) {
                    %>
                    document.getElementById('dailyCapInfo').innerHTML = 
                        'Giới hạn ngày: ' + formatNumber(dailyCap) + ' VND';
                    <%
                        }
                    %>
                }
            }
            
            document.getElementById('costAmount').textContent = formatNumber(estimatedCost) + ' VND';
            
            // Update hidden field for form submission
            document.getElementById('rentalMinutesHidden').value = durationMinutes;
        }
        
        function formatNumber(num) {
            return new Intl.NumberFormat('vi-VN').format(Math.round(num));
        }
        
        // Update cost when rental minutes input changes
        document.getElementById('rentalMinutes').addEventListener('input', updateCost);
        
        // Initialize cost display
        updateCost();
    </script>
</body>
</html>
