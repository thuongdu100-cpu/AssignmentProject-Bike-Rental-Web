<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bắt đầu thuê xe - Bike Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .rental-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }
        
        .page-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        
        .main-content {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 2rem;
            margin-top: 2rem;
        }
        
        @media (max-width: 968px) {
            .main-content {
                grid-template-columns: 1fr;
            }
        }
        
        .bike-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 2rem;
            color: white;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            position: relative;
            overflow: hidden;
        }
        
        .bike-info-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: pulse 3s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 0.8; }
        }
        
        .bike-image-container {
            text-align: center;
            margin-bottom: 1.5rem;
            position: relative;
            z-index: 1;
        }
        
        .bike-image-container img {
            width: 100%;
            max-width: 400px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            transition: transform 0.3s;
        }
        
        .bike-image-container img:hover {
            transform: scale(1.05);
        }
        
        .bike-details {
            position: relative;
            z-index: 1;
        }
        
        .bike-details h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
            padding: 0.5rem;
            background: rgba(255,255,255,0.1);
            border-radius: 8px;
            backdrop-filter: blur(10px);
        }
        
        .detail-item strong {
            min-width: 120px;
            font-size: 0.9rem;
        }
        
        .detail-item span {
            flex: 1;
        }
        
        .battery-indicator {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.25rem 0.75rem;
            background: rgba(255,255,255,0.2);
            border-radius: 20px;
            font-weight: 600;
        }
        
        .battery-bar {
            width: 60px;
            height: 8px;
            background: rgba(255,255,255,0.3);
            border-radius: 4px;
            overflow: hidden;
        }
        
        .battery-fill {
            height: 100%;
            background: linear-gradient(90deg, #4caf50, #8bc34a);
            transition: width 0.3s;
        }
        
        .form-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .form-section {
            margin-bottom: 2rem;
        }
        
        .form-section h3 {
            color: #2c3e50;
            margin-bottom: 1rem;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #34495e;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .form-group select,
        .form-group input[type="number"] {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            background: #f8f9fa;
        }
        
        .form-group select:focus,
        .form-group input[type="number"]:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group small {
            display: block;
            margin-top: 0.5rem;
            color: #7f8c8d;
            font-size: 0.85rem;
        }
        
        .plans-container {
            display: grid;
            gap: 1rem;
        }
        
        .plan-item {
            padding: 1.5rem;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
            position: relative;
            overflow: hidden;
        }
        
        .plan-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: #667eea;
            transform: scaleY(0);
            transition: transform 0.3s;
        }
        
        .plan-item:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
        }
        
        .plan-item:hover::before {
            transform: scaleY(1);
        }
        
        .plan-item.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }
        
        .plan-item.selected::before {
            transform: scaleY(1);
        }
        
        .plan-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .plan-radio {
            width: 24px;
            height: 24px;
            cursor: pointer;
        }
        
        .plan-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
            flex: 1;
        }
        
        .plan-badge {
            padding: 0.25rem 0.75rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .plan-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e0e0e0;
        }
        
        .plan-detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        
        .plan-detail-label {
            font-size: 0.85rem;
            color: #7f8c8d;
            font-weight: 500;
        }
        
        .plan-detail-value {
            font-size: 1rem;
            color: #2c3e50;
            font-weight: 700;
        }
        
        .cost-estimate-card {
            background: linear-gradient(135deg, #fff3cd 0%, #ffe69c 100%);
            border-radius: 15px;
            padding: 1.5rem;
            margin-top: 1.5rem;
            border: 2px solid #ffc107;
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.2);
        }
        
        .cost-estimate-card h4 {
            color: #856404;
            margin-bottom: 1rem;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        #costExample {
            color: #856404;
            line-height: 1.8;
            font-size: 0.95rem;
        }
        
        .action-buttons {
            display: grid;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .btn-primary-large {
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 12px;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.3);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(17, 153, 142, 0.4);
        }
        
        .btn-warning {
            background: white;
            color: #f39c12;
            border: 2px solid #f39c12;
        }
        
        .btn-warning:hover {
            background: #f39c12;
            color: white;
        }
        
        .alert-error {
            background: #fee;
            color: #c33;
            padding: 1rem;
            border-radius: 10px;
            border-left: 4px solid #c33;
            margin-bottom: 1.5rem;
        }
        
        .icon {
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="rental-container">
        <div class="page-header">
            <h1>🚴 Bắt đầu thuê xe</h1>
            <p>Chọn gói giá và thời gian thuê phù hợp với bạn</p>
        </div>
        
        <c:if test="${error != null}">
            <div class="alert-error">
                <strong>⚠️ Lỗi:</strong> ${error}
            </div>
        </c:if>
        
        <div class="main-content">
            <!-- Bike Info Card -->
            <div class="bike-info-card">
                <div class="bike-image-container">
                    <c:if test="${bike.imageURL != null && !empty bike.imageURL}">
                        <img src="${bike.imageURL}" alt="${bike.model.modelName}" 
                             onerror="this.src='${pageContext.request.contextPath}/images/no-image.png'">
                    </c:if>
                    <c:if test="${bike.imageURL == null || empty bike.imageURL}">
                        <div style="background: rgba(255,255,255,0.2); padding: 3rem; border-radius: 15px; font-size: 4rem;">
                            🚴
                        </div>
                    </c:if>
                </div>
                
                <div class="bike-details">
                    <h3>📋 Thông tin xe</h3>
                    
                    <div class="detail-item">
                        <strong>Model:</strong>
                        <span>${bike.model.modelName}</span>
                    </div>
                    
                    <div class="detail-item">
                        <strong>Thương hiệu:</strong>
                        <span>${bike.model.brand != null ? bike.model.brand : 'N/A'}</span>
                    </div>
                    
                    <div class="detail-item">
                        <strong>Loại:</strong>
                        <span>
                            <c:choose>
                                <c:when test="${bike.model.typeName == 'standard'}">Xe đạp thường</c:when>
                                <c:when test="${bike.model.typeName == 'ebike'}">Xe đạp điện</c:when>
                                <c:when test="${bike.model.typeName == 'cargo'}">Xe đạp hàng</c:when>
                                <c:otherwise>${bike.model.typeName}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <div class="detail-item">
                        <strong>Số seri:</strong>
                        <span>${bike.serialNumber}</span>
                    </div>
                    
                    <c:if test="${bike.batteryPercent != null}">
                        <div class="detail-item">
                            <strong>Pin:</strong>
                            <span class="battery-indicator">
                                <span>${bike.batteryPercent}%</span>
                                <div class="battery-bar">
                                    <div class="battery-fill" style="width: ${bike.batteryPercent}%"></div>
                                </div>
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Form Card -->
            <div class="form-card">
                <form action="rental" method="POST" id="rentalForm">
                    <input type="hidden" name="action" value="start">
                    <input type="hidden" name="bikeID" value="${bike.bikeID}">
                    
                    <div class="form-section">
                        <h3>📍 Trạm bắt đầu</h3>
                        <div class="form-group">
                            <label>Chọn trạm:</label>
                            <select name="startStationID" required>
                                <c:forEach var="station" items="${stations}">
                                    <option value="${station.stationID}" ${bike.currentStationID == station.stationID ? 'selected' : ''}>
                                        ${station.name} - ${station.stationCode}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3>⏱️ Thời gian thuê</h3>
                        <div class="form-group">
                            <label>Thời gian thuê (phút):</label>
                            <input type="number" name="rentalMinutes" id="rentalMinutes" min="30" max="1440" step="30" value="30" required>
                            <small>Thời gian thuê từ 30 phút đến 1440 phút (24 giờ), tăng theo bước 30 phút (30, 60, 90, 120...)</small>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h3>💰 Chọn gói giá</h3>
                        <div class="plans-container">
                            <c:forEach var="plan" items="${plans}" varStatus="planStatus">
                                <%
                                    models.PricingPlan planObj = (models.PricingPlan)pageContext.getAttribute("plan");
                                    int planIdForHtml = planObj.getPlanID();
                                    String planNameForHtml = planObj.getPlanName();
                                %>
                                <div class="plan-item" onclick="selectPlan(<%= planIdForHtml %>)">
                                    <div class="plan-header">
                                        <input type="radio" name="planID" value="<%= planIdForHtml %>" 
                                               id="plan<%= planIdForHtml %>" class="plan-radio" required 
                                               ${planStatus.first ? 'checked' : ''}>
                                        <label for="plan<%= planIdForHtml %>" class="plan-name">
                                            <%= planNameForHtml %>
                                        </label>
                                        <c:if test="${planStatus.first}">
                                            <span class="plan-badge">Khuyến nghị</span>
                                        </c:if>
                                    </div>
                                    <div class="plan-details">
                                        <%
                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                            models.PricingPlan p = (models.PricingPlan)pageContext.getAttribute("plan");
                                            String unlockFeeFormatted = "0";
                                            String pricePerMinFormatted = "0";
                                            if (p.getUnlockFee() != null) {
                                                unlockFeeFormatted = nf.format(p.getUnlockFee().longValue());
                                            }
                                            if (p.getPricePerMin() != null) {
                                                pricePerMinFormatted = nf.format(p.getPricePerMin().longValue());
                                            }
                                            String dailyCapFormatted = null;
                                            if (p.getDailyCap() != null) {
                                                dailyCapFormatted = nf.format(p.getDailyCap().longValue());
                                            }
                                        %>
                                        <div class="plan-detail-item">
                                            <span class="plan-detail-label">Phí mở khóa</span>
                                            <span class="plan-detail-value"><%= unlockFeeFormatted %> VND</span>
                                        </div>
                                        <div class="plan-detail-item">
                                            <span class="plan-detail-label">Giá/phút</span>
                                            <span class="plan-detail-value"><%= pricePerMinFormatted %> VND</span>
                                        </div>
                                        <div class="plan-detail-item">
                                            <span class="plan-detail-label">Phút miễn phí</span>
                                            <span class="plan-detail-value"><%= p.getFreeMinutes() %> phút</span>
                                        </div>
                                        <div class="plan-detail-item">
                                            <span class="plan-detail-label">Giới hạn ngày</span>
                                            <span class="plan-detail-value">
                                                <% if (dailyCapFormatted != null) { %>
                                                    <%= dailyCapFormatted %> VND
                                                <% } else { %>
                                                    Không giới hạn
                                                <% } %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="cost-estimate-card">
                        <h4>💵 Chi phí ước tính</h4>
                        <div id="costExample">Chọn gói giá và thời gian thuê để xem chi phí</div>
                    </div>
                    
                    <div class="action-buttons">
                        <button type="submit" class="btn-primary-large btn-success">
                            <span class="icon">🚀</span>
                            Bắt đầu thuê xe
                        </button>
                        <a href="${pageContext.request.contextPath}/customer-bikes" class="btn-primary-large btn-warning">
                            <span class="icon">❌</span>
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        const plans = {
            <c:forEach var="plan" items="${plans}" varStatus="status">
            <%
                models.PricingPlan p = (models.PricingPlan)pageContext.getAttribute("plan");
                int planId = p.getPlanID();
                String planName = p.getPlanName();
                double unlockFee = p.getUnlockFee() != null ? p.getUnlockFee().doubleValue() : 0.0;
                double pricePerMin = p.getPricePerMin() != null ? p.getPricePerMin().doubleValue() : 0.0;
                int freeMinutes = p.getFreeMinutes();
                Double dailyCap = p.getDailyCap() != null ? p.getDailyCap().doubleValue() : null;
            %>
            <%= planId %>: {
                name: "<%= planName %>",
                unlockFee: <%= unlockFee %>,
                pricePerMin: <%= pricePerMin %>,
                freeMinutes: <%= freeMinutes %>,
                dailyCap: <%= dailyCap != null ? dailyCap : "null" %>
            }${!status.last ? ',' : ''}
            </c:forEach>
        };
        
        function selectPlan(planId) {
            document.querySelectorAll('.plan-item').forEach(item => {
                item.classList.remove('selected');
            });
            const planItem = document.getElementById('plan' + planId).closest('.plan-item');
            if (planItem) {
                planItem.classList.add('selected');
            }
            document.getElementById('plan' + planId).checked = true;
            updateCostExample(planId);
        }
        
        function updateCostExample(planId) {
            const plan = plans[planId];
            if (!plan) return;
            
            const rentalMinutes = parseInt(document.getElementById('rentalMinutes').value) || 30;
            const billableMinutes = Math.max(0, rentalMinutes - plan.freeMinutes);
            let cost = plan.unlockFee + (billableMinutes * plan.pricePerMin);
            if (plan.dailyCap !== null && cost > plan.dailyCap) {
                cost = plan.dailyCap;
            }
            
            let example = '<div style="font-size: 1.1rem; margin-bottom: 0.75rem;"><strong>' + plan.name + '</strong></div>';
            example += '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.5rem; margin-bottom: 0.75rem;">';
            example += '<div><strong>• Phí mở khóa:</strong> ' + formatNumber(plan.unlockFee) + ' VND</div>';
            example += '<div><strong>• Thời gian thuê:</strong> ' + rentalMinutes + ' phút</div>';
            if (billableMinutes > 0) {
                example += '<div><strong>• Phút tính phí:</strong> ' + billableMinutes + ' phút</div>';
                example += '<div><strong>• (Sau ' + plan.freeMinutes + ' phút miễn phí)</strong></div>';
            } else {
                example += '<div colspan="2"><strong>• Miễn phí trong ' + plan.freeMinutes + ' phút đầu</strong></div>';
            }
            example += '</div>';
            example += '<div style="padding-top: 0.75rem; border-top: 2px solid #856404; margin-top: 0.75rem;">';
            example += '<div style="font-size: 1.3rem; font-weight: 700; color: #d32f2f;">💰 Tổng chi phí: ' + formatNumber(cost) + ' VND</div>';
            if (plan.dailyCap !== null && cost >= plan.dailyCap) {
                example += '<div style="margin-top: 0.5rem; font-size: 0.9rem; color: #856404;">(Đã đạt giới hạn ngày: ' + formatNumber(plan.dailyCap) + ' VND)</div>';
            }
            example += '</div>';
            
            document.getElementById('costExample').innerHTML = example;
        }
        
        function formatNumber(num) {
            return new Intl.NumberFormat('vi-VN').format(Math.round(num));
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('input[name="planID"]').forEach(radio => {
                if (radio.checked) {
                    selectPlan(radio.value);
                }
                radio.addEventListener('change', function() {
                    if (this.checked) {
                        selectPlan(this.value);
                    }
                });
            });
            
            // Update cost when rental minutes change
            const MAX_MINUTES_PER_DAY = 1440; // 24 giờ
            const MIN_MINUTES = 30;
            const STEP_MINUTES = 30;
            
            document.getElementById('rentalMinutes').addEventListener('input', function() {
                let value = parseInt(this.value) || MIN_MINUTES;
                
                // Đảm bảo giá trị tối thiểu là 30
                if (value < MIN_MINUTES) {
                    value = MIN_MINUTES;
                    this.value = MIN_MINUTES;
                }
                
                // Đảm bảo giá trị tối đa là 1440 (24 giờ)
                if (value > MAX_MINUTES_PER_DAY) {
                    value = MAX_MINUTES_PER_DAY;
                    this.value = MAX_MINUTES_PER_DAY;
                    alert('Thời gian thuê tối đa là ' + MAX_MINUTES_PER_DAY + ' phút (24 giờ) trong một ngày!');
                }
                
                // Làm tròn về bước 30 gần nhất
                value = Math.round(value / STEP_MINUTES) * STEP_MINUTES;
                this.value = value;
                
                const selectedPlan = document.querySelector('input[name="planID"]:checked');
                if (selectedPlan) {
                    updateCostExample(parseInt(selectedPlan.value));
                }
            });
            
            // Validate on form submit
            document.getElementById('rentalForm').addEventListener('submit', function(e) {
                const rentalMinutes = parseInt(document.getElementById('rentalMinutes').value) || 0;
                
                if (rentalMinutes < MIN_MINUTES) {
                    e.preventDefault();
                    alert('Thời gian thuê tối thiểu là ' + MIN_MINUTES + ' phút!');
                    document.getElementById('rentalMinutes').value = MIN_MINUTES;
                    return false;
                }
                
                if (rentalMinutes > MAX_MINUTES_PER_DAY) {
                    e.preventDefault();
                    alert('Thời gian thuê tối đa là ' + MAX_MINUTES_PER_DAY + ' phút (24 giờ) trong một ngày!');
                    document.getElementById('rentalMinutes').value = MAX_MINUTES_PER_DAY;
                    return false;
                }
                
                if (rentalMinutes % STEP_MINUTES !== 0) {
                    e.preventDefault();
                    const roundedValue = Math.round(rentalMinutes / STEP_MINUTES) * STEP_MINUTES;
                    if (roundedValue > MAX_MINUTES_PER_DAY) {
                        alert('Thời gian thuê phải là bội số của ' + STEP_MINUTES + ' phút và không vượt quá ' + MAX_MINUTES_PER_DAY + ' phút!');
                        document.getElementById('rentalMinutes').value = MAX_MINUTES_PER_DAY;
                    } else {
                        alert('Thời gian thuê phải là bội số của ' + STEP_MINUTES + ' phút! Đã tự động điều chỉnh thành ' + roundedValue + ' phút.');
                        document.getElementById('rentalMinutes').value = roundedValue;
                    }
                    return false;
                }
            });
        });
    </script>
</body>
</html>
