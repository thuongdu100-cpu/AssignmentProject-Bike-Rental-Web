<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%
    // Nếu truy cập trực tiếp JSP, redirect đến controller để load dữ liệu
    if (request.getAttribute("totalRevenue") == null && request.getAttribute("totalRentals") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
%>
<jsp:include page="../navbar/navbar.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stat-card.success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }
        .stat-card.warning {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .stat-card.info {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .stat-card h3 {
            margin: 0 0 0.5rem 0;
            font-size: 0.9rem;
            opacity: 0.9;
        }
        .stat-card .value {
            font-size: 2rem;
            font-weight: bold;
            margin: 0;
        }
        .chart-container {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .chart-container h3 {
            margin: 0 0 1rem 0;
            color: #333;
        }
        .charts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 2rem;
        }
        .quick-links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }
        .quick-link-card {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s;
        }
        .quick-link-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>📊 Dashboard - Quản trị viên</h2>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Tổng doanh thu</h3>
                    <p class="value">
                        <%
                            if (request.getAttribute("totalRevenue") != null) {
                                NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                out.print(nf.format(((java.math.BigDecimal)request.getAttribute("totalRevenue")).longValue()) + " VND");
                            } else {
                                out.print("0 VND");
                            }
                        %>
                    </p>
                </div>
                <div class="stat-card success">
                    <h3>Doanh thu hôm nay</h3>
                    <p class="value">
                        <%
                            if (request.getAttribute("todayRevenue") != null) {
                                NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                out.print(nf.format(((java.math.BigDecimal)request.getAttribute("todayRevenue")).longValue()) + " VND");
                            } else {
                                out.print("0 VND");
                            }
                        %>
                    </p>
                </div>
                <div class="stat-card info">
                    <h3>Doanh thu tháng này</h3>
                    <p class="value">
                        <%
                            if (request.getAttribute("monthRevenue") != null) {
                                NumberFormat nf = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                out.print(nf.format(((java.math.BigDecimal)request.getAttribute("monthRevenue")).longValue()) + " VND");
                            } else {
                                out.print("0 VND");
                            }
                        %>
                    </p>
                </div>
                <div class="stat-card warning">
                    <h3>Tổng số thuê xe</h3>
                    <p class="value">${totalRentals != null ? totalRentals : 0}</p>
                </div>
                <div class="stat-card">
                    <h3>Thuê xe hôm nay</h3>
                    <p class="value">${todayRentals != null ? todayRentals : 0}</p>
                </div>
                <div class="stat-card success">
                    <h3>Tổng số xe</h3>
                    <p class="value">${totalBikes != null ? totalBikes : 0}</p>
                </div>
                <div class="stat-card info">
                    <h3>Xe có sẵn</h3>
                    <p class="value">${availableBikes != null ? availableBikes : 0}</p>
                </div>
                <div class="stat-card warning">
                    <h3>Xe đang thuê</h3>
                    <p class="value">${inUseBikes != null ? inUseBikes : 0}</p>
                </div>
                <div class="stat-card">
                    <h3>Tổng khách hàng</h3>
                    <p class="value">${totalCustomers != null ? totalCustomers : 0}</p>
                </div>
            </div>
            
            <!-- Charts -->
            <div class="charts-grid">
                <!-- Doanh thu 7 ngày gần nhất -->
                <div class="chart-container">
                    <h3>📈 Doanh thu 7 ngày gần nhất</h3>
                    <canvas id="revenue7DaysChart"></canvas>
                </div>
                
                <!-- Số lượng thuê xe 7 ngày gần nhất -->
                <div class="chart-container">
                    <h3>🚴 Số lượng thuê xe 7 ngày gần nhất</h3>
                    <canvas id="rentals7DaysChart"></canvas>
                </div>
                
                <!-- Doanh thu theo phương thức thanh toán -->
                <div class="chart-container">
                    <h3>💳 Doanh thu theo phương thức thanh toán</h3>
                    <canvas id="revenueByMethodChart"></canvas>
                </div>
                
                <!-- Doanh thu 12 tháng gần nhất -->
                <div class="chart-container">
                    <h3>📊 Doanh thu 12 tháng gần nhất</h3>
                    <canvas id="revenue12MonthsChart"></canvas>
                </div>
            </div>
            
            <!-- Quick Links -->
            <div class="quick-links">
                <div class="quick-link-card">
                    <h3>👥 Quản lý người dùng</h3>
                    <a href="${pageContext.request.contextPath}/admin/user?action=list" class="btn btn-primary">Xem chi tiết</a>
                </div>
                <div class="quick-link-card">
                    <h3>💰 Quản lý gói giá</h3>
                    <a href="${pageContext.request.contextPath}/admin/pricing-plan?action=list" class="btn btn-primary">Xem chi tiết</a>
                </div>
                <div class="quick-link-card">
                    <h3>📋 Xem tất cả thuê xe</h3>
                    <a href="${pageContext.request.contextPath}/staff/rental?action=list" class="btn btn-primary">Xem chi tiết</a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Format số tiền
        function formatCurrency(value) {
            return new Intl.NumberFormat('vi-VN').format(value);
        }
        
        // Doanh thu 7 ngày gần nhất
        <%
            java.util.List<Object[]> revenue7Days = (java.util.List<Object[]>) request.getAttribute("revenueLast7Days");
            if (revenue7Days != null && !revenue7Days.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");
                out.print("const revenue7DaysLabels = [");
                for (int i = 0; i < revenue7Days.size(); i++) {
                    Object[] row = revenue7Days.get(i);
                    Date date = (Date) row[0];
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print("'" + sdf.format(date) + "'");
                }
                out.print("];");
                out.print("const revenue7DaysData = [");
                for (int i = 0; i < revenue7Days.size(); i++) {
                    Object[] row = revenue7Days.get(i);
                    java.math.BigDecimal revenue = (java.math.BigDecimal) row[1];
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print(revenue.longValue());
                }
                out.print("];");
            } else {
                out.print("const revenue7DaysLabels = [];");
                out.print("const revenue7DaysData = [];");
            }
        %>
        
        const revenue7DaysCtx = document.getElementById('revenue7DaysChart').getContext('2d');
        new Chart(revenue7DaysCtx, {
            type: 'line',
            data: {
                labels: revenue7DaysLabels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: revenue7DaysData,
                    borderColor: 'rgb(102, 126, 234)',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + formatCurrency(context.parsed.y) + ' VND';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return formatCurrency(value);
                            }
                        }
                    }
                }
            }
        });
        
        // Số lượng thuê xe 7 ngày gần nhất
        <%
            java.util.List<Object[]> rentals7Days = (java.util.List<Object[]>) request.getAttribute("rentalsLast7Days");
            if (rentals7Days != null && !rentals7Days.isEmpty()) {
                SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM");
                out.print("const rentals7DaysLabels = [");
                for (int i = 0; i < rentals7Days.size(); i++) {
                    Object[] row = rentals7Days.get(i);
                    Date date = (Date) row[0];
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print("'" + sdf2.format(date) + "'");
                }
                out.print("];");
                out.print("const rentals7DaysData = [");
                for (int i = 0; i < rentals7Days.size(); i++) {
                    Object[] row = rentals7Days.get(i);
                    Integer count = (Integer) row[1];
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print(count);
                }
                out.print("];");
            } else {
                out.print("const rentals7DaysLabels = [];");
                out.print("const rentals7DaysData = [];");
            }
        %>
        
        const rentals7DaysCtx = document.getElementById('rentals7DaysChart').getContext('2d');
        new Chart(rentals7DaysCtx, {
            type: 'bar',
            data: {
                labels: rentals7DaysLabels,
                datasets: [{
                    label: 'Số lượng thuê xe',
                    data: rentals7DaysData,
                    backgroundColor: 'rgba(17, 153, 142, 0.8)',
                    borderColor: 'rgb(17, 153, 142)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
        
        // Doanh thu theo phương thức thanh toán
        <%
            java.util.List<Object[]> revenueByMethod = (java.util.List<Object[]>) request.getAttribute("revenueByMethod");
            if (revenueByMethod != null && !revenueByMethod.isEmpty()) {
                out.print("const revenueByMethodLabels = [");
                for (int i = 0; i < revenueByMethod.size(); i++) {
                    Object[] row = revenueByMethod.get(i);
                    String method = (String) row[0];
                    String methodName = "";
                    if ("cash".equals(method)) methodName = "Tiền mặt";
                    else if ("card".equals(method)) methodName = "Thẻ";
                    else if ("ewallet".equals(method)) methodName = "Ví điện tử";
                    else methodName = method;
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print("'" + methodName + "'");
                }
                out.print("];");
                out.print("const revenueByMethodData = [");
                for (int i = 0; i < revenueByMethod.size(); i++) {
                    Object[] row = revenueByMethod.get(i);
                    java.math.BigDecimal revenue = (java.math.BigDecimal) row[1];
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print(revenue.longValue());
                }
                out.print("];");
            } else {
                out.print("const revenueByMethodLabels = [];");
                out.print("const revenueByMethodData = [];");
            }
        %>
        
        const revenueByMethodCtx = document.getElementById('revenueByMethodChart').getContext('2d');
        new Chart(revenueByMethodCtx, {
            type: 'doughnut',
            data: {
                labels: revenueByMethodLabels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: revenueByMethodData,
                    backgroundColor: [
                        'rgba(102, 126, 234, 0.8)',
                        'rgba(17, 153, 142, 0.8)',
                        'rgba(240, 147, 251, 0.8)'
                    ],
                    borderColor: [
                        'rgb(102, 126, 234)',
                        'rgb(17, 153, 142)',
                        'rgb(240, 147, 251)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + formatCurrency(context.parsed) + ' VND';
                            }
                        }
                    }
                }
            }
        });
        
        // Doanh thu 12 tháng gần nhất
        <%
            java.util.List<Object[]> revenue12Months = (java.util.List<Object[]>) request.getAttribute("revenueLast12Months");
            if (revenue12Months != null && !revenue12Months.isEmpty()) {
                out.print("const revenue12MonthsLabels = [");
                for (int i = 0; i < revenue12Months.size(); i++) {
                    Object[] row = revenue12Months.get(i);
                    String month = (String) row[0];
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print("'" + month + "'");
                }
                out.print("];");
                out.print("const revenue12MonthsData = [");
                for (int i = 0; i < revenue12Months.size(); i++) {
                    Object[] row = revenue12Months.get(i);
                    java.math.BigDecimal revenue = (java.math.BigDecimal) row[1];
                    if (i > 0) {
                        out.print(",");
                    }
                    out.print(revenue.longValue());
                }
                out.print("];");
            } else {
                out.print("const revenue12MonthsLabels = [];");
                out.print("const revenue12MonthsData = [];");
            }
        %>
        
        const revenue12MonthsCtx = document.getElementById('revenue12MonthsChart').getContext('2d');
        new Chart(revenue12MonthsCtx, {
            type: 'bar',
            data: {
                labels: revenue12MonthsLabels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: revenue12MonthsData,
                    backgroundColor: 'rgba(79, 172, 254, 0.8)',
                    borderColor: 'rgb(79, 172, 254)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + formatCurrency(context.parsed.y) + ' VND';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return formatCurrency(value);
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
