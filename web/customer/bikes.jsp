<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="models.Bike" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh sách xe - Bike Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .bikes-page-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: -50px;
            left: 50%;
            transform: translateX(-50%);
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            animation: pulse 3s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: translateX(-50%) scale(1); opacity: 0.5; }
            50% { transform: translateX(-50%) scale(1.2); opacity: 0.8; }
        }
        
        .page-header h1 {
            font-size: 3rem;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-weight: 700;
            position: relative;
            z-index: 1;
        }
        
        .page-header p {
            color: #7f8c8d;
            font-size: 1.2rem;
            position: relative;
            z-index: 1;
        }
        
        .search-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }
        
        .search-form {
            display: grid;
            grid-template-columns: 2fr 1.5fr auto;
            gap: 1rem;
            align-items: end;
        }
        
        @media (max-width: 768px) {
            .search-form {
                grid-template-columns: 1fr;
            }
        }
        
        .search-input-group {
            position: relative;
        }
        
        .search-input-group label {
            display: block;
            color: white;
            margin-bottom: 0.5rem;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .search-input-group input,
        .search-input-group select {
            width: 100%;
            padding: 0.875rem 1rem 0.875rem 2.5rem;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 12px;
            font-size: 1rem;
            background: rgba(255,255,255,0.95);
            transition: all 0.3s;
        }
        
        .search-input-group input:focus,
        .search-input-group select:focus {
            outline: none;
            border-color: white;
            background: white;
            box-shadow: 0 0 0 3px rgba(255,255,255,0.3);
        }
        
        .search-icon {
            position: absolute;
            left: 0.875rem;
            top: 2.5rem;
            color: #667eea;
            font-size: 1.2rem;
        }
        
        .search-buttons {
            display: flex;
            gap: 0.75rem;
        }
        
        .btn-search {
            padding: 0.875rem 2rem;
            background: white;
            color: #667eea;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,255,255,0.3);
        }
        
        .btn-clear {
            padding: 0.875rem 1.5rem;
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-clear:hover {
            background: rgba(255,255,255,0.3);
            border-color: white;
        }
        
        .filter-info {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border-left: 5px solid #1976d2;
            box-shadow: 0 5px 15px rgba(25, 118, 210, 0.1);
        }
        
        .filter-info p {
            margin: 0.5rem 0;
            color: #1565c0;
            font-weight: 500;
        }
        
        .filter-info .result-count {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1976d2;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
            border-radius: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .empty-state-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .empty-state p {
            font-size: 1.2rem;
            color: #7f8c8d;
            margin-bottom: 1.5rem;
        }
        
        .bike-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }
        
        .bike-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s;
            position: relative;
            display: flex;
            flex-direction: column;
        }
        
        .bike-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s;
        }
        
        .bike-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.3);
        }
        
        .bike-card:hover::before {
            transform: scaleX(1);
        }
        
        .bike-card-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
            transition: transform 0.3s;
        }
        
        .bike-card:hover .bike-card-image {
            transform: scale(1.05);
        }
        
        .bike-card-body {
            padding: 1.5rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .bike-card-title {
            font-size: 1.4rem;
            color: #2c3e50;
            margin: 0 0 1rem 0;
            font-weight: 700;
        }
        
        .bike-card-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            color: #555;
            font-size: 0.95rem;
        }
        
        .bike-card-info strong {
            color: #2c3e50;
            min-width: 100px;
            font-weight: 600;
        }
        
        .bike-card-info .icon {
            color: #667eea;
            font-size: 1.1rem;
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-top: 0.5rem;
        }
        
        .status-available {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .bike-card-actions {
            margin-top: auto;
            padding-top: 1rem;
            display: flex;
            gap: 0.75rem;
        }
        
        .btn-detail {
            flex: 1;
            padding: 0.75rem 1rem;
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        
        .btn-detail:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-rent {
            flex: 1;
            padding: 0.75rem 1rem;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            box-shadow: 0 5px 15px rgba(17, 153, 142, 0.3);
        }
        
        .btn-rent:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(17, 153, 142, 0.4);
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6);
            backdrop-filter: blur(5px);
            animation: fadeIn 0.3s;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .modal-content {
            background: white;
            margin: 5% auto;
            padding: 0;
            border: none;
            width: 90%;
            max-width: 700px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideDown 0.3s;
            overflow: hidden;
        }
        
        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h2 {
            margin: 0;
            font-size: 1.5rem;
        }
        
        .close {
            color: white;
            font-size: 2rem;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.3s;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
        }
        
        .close:hover {
            transform: rotate(90deg);
            background: rgba(255,255,255,0.3);
        }
        
        .modal-body {
            padding: 2rem;
        }
        
        .bike-detail-image {
            width: 100%;
            max-width: 500px;
            height: auto;
            border-radius: 15px;
            margin: 0 auto 1.5rem;
            display: block;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .bike-detail-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        @media (max-width: 600px) {
            .bike-detail-info {
                grid-template-columns: 1fr;
            }
        }
        
        .bike-detail-item {
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 3px solid #667eea;
        }
        
        .bike-detail-item strong {
            display: block;
            color: #667eea;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        
        .bike-detail-item span {
            color: #2c3e50;
            font-size: 1rem;
            font-weight: 600;
        }
        
        .modal-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .modal-actions .btn {
            flex: 1;
            padding: 1rem;
            border-radius: 12px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
        }
    </style>
</head>
<body>
    <div class="bikes-page-container">
        <div class="page-header">
            <h1>🚴 Khám phá xe đạp</h1>
            <p>Tìm kiếm và thuê xe đạp phù hợp với bạn</p>
        </div>
        
        <!-- Search Section -->
        <div class="search-section">
            <form method="GET" action="customer-bikes" class="search-form">
                <div class="search-input-group">
                    <label>🔍 Tìm kiếm</label>
                    <span class="search-icon">🔍</span>
                    <input type="text" id="search" name="search" 
                           placeholder="Tên model, thương hiệu, số seri, trạm..." 
                           value="${searchKeyword != null ? searchKeyword : param.search}">
                </div>
                <div class="search-input-group">
                    <label>📍 Lọc theo trạm</label>
                    <select id="stationID" name="stationID">
                        <option value="">Tất cả trạm</option>
                        <c:forEach var="station" items="${stations}">
                            <option value="${station.stationID}" ${param.stationID == station.stationID ? 'selected' : ''}>
                                ${station.name} - ${station.stationCode}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="search-buttons">
                    <button type="submit" class="btn-search">
                        <span>🔍</span>
                        Tìm kiếm
                    </button>
                    <a href="customer-bikes" class="btn-clear">
                        <span>🔄</span>
                        Xóa bộ lọc
                    </a>
                </div>
            </form>
        </div>
        
        <!-- Filter Info -->
        <c:if test="${selectedStation != null || (searchKeyword != null && !empty searchKeyword)}">
            <div class="filter-info">
                <c:if test="${selectedStation != null}">
                    <p><strong>📍 Trạm đã chọn:</strong> ${selectedStation.name} (${selectedStation.stationCode})</p>
                </c:if>
                <c:if test="${searchKeyword != null && !empty searchKeyword}">
                    <p><strong>🔍 Từ khóa:</strong> "${searchKeyword}"</p>
                </c:if>
                <c:if test="${not empty bikes}">
                    <p class="result-count">✨ Tìm thấy ${bikes.size()} kết quả</p>
                </c:if>
            </div>
        </c:if>
        
        <!-- Empty State -->
        <c:if test="${empty bikes}">
            <div class="empty-state">
                <div class="empty-state-icon">🚴</div>
                <p>
                    <c:choose>
                        <c:when test="${searchKeyword != null && !empty searchKeyword || selectedStation != null}">
                            Không tìm thấy xe nào phù hợp với tiêu chí tìm kiếm.
                        </c:when>
                        <c:otherwise>
                            Không có xe nào có sẵn tại thời điểm này.
                        </c:otherwise>
                    </c:choose>
                </p>
                <c:if test="${searchKeyword != null && !empty searchKeyword || selectedStation != null}">
                    <a href="customer-bikes" class="btn btn-primary" style="display: inline-block; padding: 0.875rem 2rem; text-decoration: none;">
                        Xem tất cả xe
                    </a>
                </c:if>
            </div>
        </c:if>
        
        <!-- Bike Grid -->
        <div class="bike-grid">
            <c:forEach var="bike" items="${bikes}">
                <div class="bike-card">
                    <c:if test="${bike.imageURL != null && !empty bike.imageURL}">
                        <img src="${bike.imageURL}" alt="${bike.model.modelName}" class="bike-card-image"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/no-image.png';">
                    </c:if>
                    <c:if test="${bike.imageURL == null || empty bike.imageURL}">
                        <div class="bike-card-image" style="display: flex; align-items: center; justify-content: center; font-size: 4rem; color: #ccc;">
                            🚴
                        </div>
                    </c:if>
                    <div class="bike-card-body">
                        <h3 class="bike-card-title">${bike.model.modelName}</h3>
                        
                        <div class="bike-card-info">
                            <span class="icon">🏷️</span>
                            <strong>Thương hiệu:</strong>
                            <span>${bike.model.brand != null ? bike.model.brand : 'N/A'}</span>
                        </div>
                        
                        <div class="bike-card-info">
                            <span class="icon">🚲</span>
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
                        
                        <div class="bike-card-info">
                            <span class="icon">🔢</span>
                            <strong>Số seri:</strong>
                            <span>${bike.serialNumber}</span>
                        </div>
                        
                        <c:if test="${bike.station != null}">
                            <div class="bike-card-info">
                                <span class="icon">📍</span>
                                <strong>Trạm:</strong>
                                <span>${bike.station.name}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${bike.batteryPercent != null}">
                            <div class="bike-card-info">
                                <span class="icon">🔋</span>
                                <strong>Pin:</strong>
                                <span>${bike.batteryPercent}%</span>
                            </div>
                        </c:if>
                        
                        <span class="status-badge status-available">✓ Có sẵn</span>
                        
                        <div class="bike-card-actions">
                            <button onclick="showBikeDetail(${bike.bikeID})" class="btn-detail">
                                <span>👁️</span>
                                Chi tiết
                            </button>
                            <a href="rental?action=start&bikeID=${bike.bikeID}" class="btn-rent">
                                <span>🚀</span>
                                Thuê ngay
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <!-- Modal for bike details -->
    <div id="bikeDetailModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>📋 Chi tiết xe đạp</h2>
                <span class="close" onclick="closeBikeDetail()">&times;</span>
            </div>
            <div class="modal-body">
                <div id="bikeDetailContent">
                    <!-- Content will be loaded here -->
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Store bike data
        const bikesData = {
            <c:forEach var="bike" items="${bikes}" varStatus="status">
            <%
                models.Bike b = (models.Bike)pageContext.getAttribute("bike");
                String serialNumber = b.getSerialNumber() != null ? b.getSerialNumber().replace("\"", "\\\"").replace("\n", "\\n") : "";
                String modelName = b.getModel().getModelName() != null ? b.getModel().getModelName().replace("\"", "\\\"").replace("\n", "\\n") : "";
                String brand = b.getModel().getBrand() != null ? b.getModel().getBrand().replace("\"", "\\\"").replace("\n", "\\n") : "N/A";
                String typeName = b.getModel().getTypeName() != null ? b.getModel().getTypeName().replace("\"", "\\\"").replace("\n", "\\n") : "";
                String imageURL = b.getImageURL() != null ? b.getImageURL().replace("\"", "\\\"").replace("\n", "\\n") : "";
                String stationName = b.getStation() != null && b.getStation().getName() != null ? b.getStation().getName().replace("\"", "\\\"").replace("\n", "\\n") : "N/A";
                String stationCode = b.getStation() != null && b.getStation().getStationCode() != null ? b.getStation().getStationCode().replace("\"", "\\\"").replace("\n", "\\n") : "N/A";
                String createdAt = b.getCreatedAt() != null ? b.getCreatedAt().toString() : "";
                String typeNameDisplay = "";
                if ("standard".equals(typeName)) typeNameDisplay = "Xe đạp thường";
                else if ("ebike".equals(typeName)) typeNameDisplay = "Xe đạp điện";
                else if ("cargo".equals(typeName)) typeNameDisplay = "Xe đạp hàng";
                else typeNameDisplay = typeName;
            %>
            ${bike.bikeID}: {
                bikeID: ${bike.bikeID},
                serialNumber: "<%= serialNumber %>",
                modelName: "<%= modelName %>",
                brand: "<%= brand %>",
                typeName: "<%= typeName %>",
                typeNameDisplay: "<%= typeNameDisplay %>",
                weightKg: ${bike.model.weightKg != null ? bike.model.weightKg : 'null'},
                hasBattery: ${bike.model.hasBattery},
                imageURL: "<%= imageURL %>",
                stationName: "<%= stationName %>",
                stationCode: "<%= stationCode %>",
                batteryPercent: ${bike.batteryPercent != null ? bike.batteryPercent : 'null'},
                status: "${bike.status}",
                createdAt: "<%= createdAt %>"
            }${!status.last ? ',' : ''}
            </c:forEach>
        };
        
        function showBikeDetail(bikeID) {
            const bike = bikesData[bikeID];
            if (!bike) return;
            
            let html = '';
            
            // Image
            if (bike.imageURL) {
                html += '<img src="' + bike.imageURL + '" alt="' + bike.modelName + '" class="bike-detail-image" onerror="this.style.display=\'none\'">';
            }
            
            // Details Grid
            html += '<div class="bike-detail-info">';
            html += '<div class="bike-detail-item"><strong>Mã xe</strong><span>#' + bike.bikeID + '</span></div>';
            html += '<div class="bike-detail-item"><strong>Số seri</strong><span>' + bike.serialNumber + '</span></div>';
            html += '<div class="bike-detail-item"><strong>Model</strong><span>' + bike.modelName + '</span></div>';
            html += '<div class="bike-detail-item"><strong>Thương hiệu</strong><span>' + bike.brand + '</span></div>';
            html += '<div class="bike-detail-item"><strong>Loại</strong><span>' + bike.typeNameDisplay + '</span></div>';
            
            if (bike.weightKg !== null) {
                html += '<div class="bike-detail-item"><strong>Trọng lượng</strong><span>' + bike.weightKg + ' kg</span></div>';
            }
            
            html += '<div class="bike-detail-item"><strong>Trạm</strong><span>' + bike.stationName + ' (' + bike.stationCode + ')</span></div>';
            
            if (bike.hasBattery) {
                if (bike.batteryPercent !== null) {
                    html += '<div class="bike-detail-item"><strong>Pin</strong><span>' + bike.batteryPercent + '%</span></div>';
                } else {
                    html += '<div class="bike-detail-item"><strong>Pin</strong><span>N/A</span></div>';
                }
            }
            
            html += '<div class="bike-detail-item"><strong>Trạng thái</strong><span class="status-badge status-available">Có sẵn</span></div>';
            
            if (bike.createdAt) {
                html += '<div class="bike-detail-item"><strong>Ngày tạo</strong><span>' + bike.createdAt + '</span></div>';
            }
            
            html += '</div>';
            
            // Action buttons
            html += '<div class="modal-actions">';
            html += '<button onclick="closeBikeDetail()" class="btn btn-secondary" style="background: #e0e0e0; color: #333; border: none;">Đóng</button>';
            html += '<a href="rental?action=start&bikeID=' + bike.bikeID + '" class="btn btn-primary" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; border: none;">🚀 Thuê ngay</a>';
            html += '</div>';
            
            document.getElementById('bikeDetailContent').innerHTML = html;
            document.getElementById('bikeDetailModal').style.display = 'block';
        }
        
        function closeBikeDetail() {
            document.getElementById('bikeDetailModal').style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('bikeDetailModal');
            if (event.target == modal) {
                closeBikeDetail();
            }
        }
        
        // Close modal with ESC key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeBikeDetail();
            }
        });
    </script>
</body>
</html>
