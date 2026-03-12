<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Hóa đơn thanh toán - Bike Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .invoice-container {
            max-width: 900px;
            margin: 2rem auto;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }
        .invoice-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .invoice-header h1 {
            margin: 0;
            font-size: 2rem;
            font-weight: 600;
        }
        .invoice-header .status-badge {
            display: inline-block;
            margin-top: 1rem;
            padding: 0.5rem 1.5rem;
            background: rgba(255,255,255,0.2);
            border-radius: 20px;
            font-weight: 500;
        }
        .invoice-body {
            padding: 2rem;
        }
        .invoice-section {
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .invoice-section h3 {
            margin-top: 0;
            margin-bottom: 1rem;
            color: #333;
            font-size: 1.2rem;
            border-bottom: 2px solid #667eea;
            padding-bottom: 0.5rem;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .info-item {
            display: flex;
            flex-direction: column;
        }
        .info-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
        }
        .info-value {
            color: #333;
            font-size: 1rem;
        }
        .bike-image {
            width: 100%;
            max-width: 300px;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
            margin: 1rem 0;
        }
        .amount-highlight {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
        }
        .invoice-footer {
            padding: 1.5rem 2rem;
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .btn-group {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        @media print {
            .invoice-footer {
                display: none;
            }
            .btn-group {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="invoice-container">
            <c:choose>
                <c:when test="${isValid && isSuccess && rental != null}">
                    <!-- Invoice Header -->
                    <div class="invoice-header">
                        <h1>HÓA ĐƠN THANH TOÁN</h1>
                        <div class="status-badge">✓ Thanh toán thành công</div>
                    </div>
                    
                    <!-- Invoice Body -->
                    <div class="invoice-body">
                        <!-- Alert Success -->
                        <div class="alert alert-success">
                            <strong>✓ Thanh toán thành công!</strong> Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi.
                        </div>
                        
                        <!-- Thông tin khách hàng -->
                        <div class="invoice-section">
                            <h3>Thông tin khách hàng</h3>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Họ và tên</span>
                                    <span class="info-value">${rental.customer.fullName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Email</span>
                                    <span class="info-value">${rental.customer.email}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Mã thuê xe</span>
                                    <span class="info-value">#${rental.rentalID}</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Thông tin xe -->
                        <div class="invoice-section">
                            <h3>Thông tin xe</h3>
                            <div class="info-grid">
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
                                        <span class="info-label">Hãng</span>
                                        <span class="info-value">${rental.bike.model.brand}</span>
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
                                </c:if>
                                <c:if test="${rental.bike.batteryPercent != null}">
                                    <div class="info-item">
                                        <span class="info-label">Pin</span>
                                        <span class="info-value">${rental.bike.batteryPercent}%</span>
                                    </div>
                                </c:if>
                            </div>
                            <c:if test="${rental.bike.imageURL != null && !empty rental.bike.imageURL}">
                                <img src="${rental.bike.imageURL}" alt="Xe đạp" class="bike-image" onerror="this.style.display='none'">
                            </c:if>
                        </div>
                        
                        <!-- Thông tin thuê xe -->
                        <div class="invoice-section">
                            <h3>Thông tin thuê xe</h3>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Trạm bắt đầu</span>
                                    <span class="info-value">${rental.startStation.name}</span>
                                </div>
                                <c:if test="${rental.endStation != null}">
                                    <div class="info-item">
                                        <span class="info-label">Trạm kết thúc</span>
                                        <span class="info-value">${rental.endStation.name}</span>
                                    </div>
                                </c:if>
                                <div class="info-item">
                                    <span class="info-label">Thời gian bắt đầu</span>
                                    <span class="info-value">
                                        <%
                                            if (request.getAttribute("rental") != null) {
                                                models.Rental r = (models.Rental) request.getAttribute("rental");
                                                if (r.getStartTime() != null) {
                                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                                    out.print(sdf.format(r.getStartTime()));
                                                }
                                            }
                                        %>
                                    </span>
                                </div>
                                <c:if test="${rental.endTime != null}">
                                    <div class="info-item">
                                        <span class="info-label">Thời gian kết thúc</span>
                                        <span class="info-value">
                                            <%
                                                if (request.getAttribute("rental") != null) {
                                                    models.Rental r = (models.Rental) request.getAttribute("rental");
                                                    if (r.getEndTime() != null) {
                                                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                                        out.print(sdf.format(r.getEndTime()));
                                                    }
                                                }
                                            %>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Thời gian thuê</span>
                                        <span class="info-value">
                                            <%
                                                if (request.getAttribute("rental") != null) {
                                                    models.Rental r = (models.Rental) request.getAttribute("rental");
                                                    if (r.getStartTime() != null && r.getEndTime() != null) {
                                                        long diff = r.getEndTime().getTime() - r.getStartTime().getTime();
                                                        long minutes = diff / (1000 * 60);
                                                        long hours = minutes / 60;
                                                        minutes = minutes % 60;
                                                        if (hours > 0) {
                                                            out.print(hours + " giờ " + minutes + " phút");
                                                        } else {
                                                            out.print(minutes + " phút");
                                                        }
                                                    }
                                                }
                                            %>
                                        </span>
                                    </div>
                                </c:if>
                                <c:if test="${rental.plan != null}">
                                    <div class="info-item">
                                        <span class="info-label">Gói giá</span>
                                        <span class="info-value">${rental.plan.planName}</span>
                                    </div>
                                    <c:if test="${rental.plan.unlockFee != null}">
                                        <div class="info-item">
                                            <span class="info-label">Phí mở khóa</span>
                                            <span class="info-value">
                                                <%
                                                    if (request.getAttribute("rental") != null) {
                                                        models.Rental r = (models.Rental) request.getAttribute("rental");
                                                        if (r.getPlan() != null && r.getPlan().getUnlockFee() != null) {
                                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                            out.print(nf.format(r.getPlan().getUnlockFee().longValue()) + " VND");
                                                        }
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
                                                    if (request.getAttribute("rental") != null) {
                                                        models.Rental r = (models.Rental) request.getAttribute("rental");
                                                        if (r.getPlan() != null && r.getPlan().getPricePerMin() != null) {
                                                            NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                            out.print(nf.format(r.getPlan().getPricePerMin().longValue()) + " VND/phút");
                                                        }
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
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Thông tin thanh toán -->
                        <div class="invoice-section">
                            <h3>Thông tin thanh toán</h3>
                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Mã giao dịch</span>
                                    <span class="info-value">${vnp_TxnRef != null && !empty vnp_TxnRef ? vnp_TxnRef : (payment != null ? payment.transactionRef : 'N/A')}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Mã giao dịch VNPay</span>
                                    <span class="info-value">${vnp_TransactionNo != null && !empty vnp_TransactionNo ? vnp_TransactionNo : 'N/A'}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Phương thức thanh toán</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${payment.method == 'ewallet'}">Ví điện tử (VNPay)</c:when>
                                            <c:when test="${payment.method == 'card'}">Thẻ</c:when>
                                            <c:when test="${payment.method == 'cash'}">Tiền mặt</c:when>
                                            <c:otherwise>${payment.method}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <c:if test="${vnp_BankCode != null && !empty vnp_BankCode}">
                                    <div class="info-item">
                                        <span class="info-label">Ngân hàng</span>
                                        <span class="info-value">${vnp_BankCode}</span>
                                    </div>
                                </c:if>
                                <div class="info-item">
                                    <span class="info-label">Trạng thái</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${payment.status == 'success' || payment.status == 'paid'}">Đã thanh toán</c:when>
                                            <c:when test="${payment.status == 'pending'}">Đang chờ</c:when>
                                            <c:when test="${payment.status == 'failed'}">Thất bại</c:when>
                                            <c:otherwise>${payment.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Ngày thanh toán</span>
                                    <span class="info-value">
                                        <%
                                            if (request.getAttribute("payment") != null) {
                                                models.Payment p = (models.Payment) request.getAttribute("payment");
                                                if (p.getCreatedAt() != null) {
                                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                                    out.print(sdf.format(p.getCreatedAt()));
                                                }
                                            }
                                        %>
                                    </span>
                                </div>
                            </div>
                            <div style="margin-top: 1.5rem; padding: 1.5rem; background: white; border-radius: 8px; border: 2px solid #667eea;">
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-size: 1.2rem; font-weight: 600; color: #333;">Tổng tiền:</span>
                                    <span class="amount-highlight">
                                        <%
                                            String amountStr = (String)request.getAttribute("vnp_Amount");
                                            if (amountStr != null && !amountStr.isEmpty()) {
                                                try {
                                                    long amountInXu = Long.parseLong(amountStr);
                                                    long amountInVND = amountInXu / 100;
                                                    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                    out.print(nf.format(amountInVND) + " VND");
                                                } catch (NumberFormatException e) {
                                                    out.print(amountStr);
                                                }
                                            } else {
                                                // Lấy từ payment nếu không có vnp_Amount
                                                models.Payment p = (models.Payment) request.getAttribute("payment");
                                                if (p != null && p.getAmount() != null) {
                                                    NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                    out.print(nf.format(p.getAmount().longValue()) + " VND");
                                                } else if (request.getAttribute("rental") != null) {
                                                    models.Rental r = (models.Rental) request.getAttribute("rental");
                                                    if (r.getCostAmount() != null) {
                                                        NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                                        out.print(nf.format(r.getCostAmount().longValue()) + " VND");
                                                    }
                                                }
                                            }
                                        %>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Invoice Footer -->
                    <div class="invoice-footer">
                        <div>
                            <p style="margin: 0; color: #666; font-size: 0.9rem;">Cảm ơn bạn đã sử dụng dịch vụ!</p>
                        </div>
                        <div class="btn-group">
                            <button onclick="window.print()" class="btn btn-secondary">In hóa đơn</button>
                            <a href="${pageContext.request.contextPath}/rental?action=list" class="btn btn-primary">Xem lịch sử thuê xe</a>
                            <a href="${pageContext.request.contextPath}/customer-bikes" class="btn btn-secondary">Về trang chủ</a>
                        </div>
                    </div>
                </c:when>
                <c:when test="${isValid && !isSuccess}">
                    <div class="invoice-container">
                        <div class="invoice-header" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                            <h1>THANH TOÁN KHÔNG THÀNH CÔNG</h1>
                        </div>
                        <div class="invoice-body">
                            <div class="alert alert-error">
                                <h3>✗ Thanh toán không thành công</h3>
                                <c:if test="${errorMessage != null}">
                                    <p>${errorMessage}</p>
                                </c:if>
                                <c:if test="${errorMessage == null}">
                                    <p>Giao dịch của bạn không được xử lý thành công.</p>
                                </c:if>
                                
                                <div style="background: #fff; padding: 1rem; border-radius: 4px; margin-top: 1rem;">
                                    <p><strong>Mã giao dịch:</strong> ${vnp_TxnRef}</p>
                                    <c:if test="${vnp_ResponseCode != null && !empty vnp_ResponseCode}">
                                        <p><strong>Mã phản hồi:</strong> ${vnp_ResponseCode}</p>
                                    </c:if>
                                    <c:if test="${vnp_TransactionStatus != null && !empty vnp_TransactionStatus}">
                                        <p><strong>Trạng thái giao dịch:</strong> ${vnp_TransactionStatus}</p>
                                    </c:if>
                                    <c:if test="${vnp_BankCode != null && !empty vnp_BankCode}">
                                        <p><strong>Ngân hàng:</strong> ${vnp_BankCode}</p>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div style="margin-top: 2rem;">
                                <a href="${pageContext.request.contextPath}/rental?action=list" class="btn btn-primary">Xem lịch sử thuê xe</a>
                                <a href="${pageContext.request.contextPath}/customer-bikes" class="btn btn-secondary">Về trang chủ</a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="invoice-container">
                        <div class="invoice-header" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                            <h1>LỖI XÁC THỰC</h1>
                        </div>
                        <div class="invoice-body">
                            <div class="alert alert-error">
                                <h3>✗ Lỗi xác thực</h3>
                                <p>Không thể xác thực thông tin giao dịch. Vui lòng liên hệ hỗ trợ.</p>
                            </div>
                            
                            <div style="margin-top: 2rem;">
                                <a href="${pageContext.request.contextPath}/rental?action=list" class="btn btn-primary">Về danh sách thuê xe</a>
                                <a href="${pageContext.request.contextPath}/customer-bikes" class="btn btn-secondary">Về trang chủ</a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
