package controller;

import dao.PaymentDAO;
import dao.RentalDAO;
import dao.BikeDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"Admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/customer-bikes");
            return;
        }
        
        try {
            PaymentDAO paymentDAO = new PaymentDAO();
            RentalDAO rentalDAO = new RentalDAO();
            BikeDAO bikeDAO = new BikeDAO();
            UserDAO userDAO = new UserDAO();
            
            // Tổng doanh thu
            java.math.BigDecimal totalRevenue = paymentDAO.getTotalRevenue();
            request.setAttribute("totalRevenue", totalRevenue);
            System.out.println("DashboardController - Total Revenue: " + totalRevenue);
            
            // Doanh thu hôm nay
            java.math.BigDecimal todayRevenue = paymentDAO.getTodayRevenue();
            request.setAttribute("todayRevenue", todayRevenue);
            System.out.println("DashboardController - Today Revenue: " + todayRevenue);
            
            // Doanh thu tháng này
            java.math.BigDecimal monthRevenue = paymentDAO.getMonthRevenue();
            request.setAttribute("monthRevenue", monthRevenue);
            System.out.println("DashboardController - Month Revenue: " + monthRevenue);
            
            // Doanh thu theo 7 ngày gần nhất
            java.util.List<Object[]> revenueLast7Days = paymentDAO.getRevenueLast7Days();
            request.setAttribute("revenueLast7Days", revenueLast7Days);
            System.out.println("DashboardController - Revenue Last 7 Days: " + (revenueLast7Days != null ? revenueLast7Days.size() : 0) + " records");
            
            // Doanh thu theo 12 tháng gần nhất
            java.util.List<Object[]> revenueLast12Months = paymentDAO.getRevenueLast12Months();
            request.setAttribute("revenueLast12Months", revenueLast12Months);
            System.out.println("DashboardController - Revenue Last 12 Months: " + (revenueLast12Months != null ? revenueLast12Months.size() : 0) + " records");
            
            // Số lượng thuê xe hôm nay
            int todayRentals = rentalDAO.getTodayRentalsCount();
            request.setAttribute("todayRentals", todayRentals);
            System.out.println("DashboardController - Today Rentals: " + todayRentals);
            
            // Tổng số thuê xe
            int totalRentals = rentalDAO.getTotalRentalsCount();
            request.setAttribute("totalRentals", totalRentals);
            System.out.println("DashboardController - Total Rentals: " + totalRentals);
            
            // Số lượng thuê xe theo 7 ngày gần nhất
            java.util.List<Object[]> rentalsLast7Days = rentalDAO.getRentalsLast7Days();
            request.setAttribute("rentalsLast7Days", rentalsLast7Days);
            System.out.println("DashboardController - Rentals Last 7 Days: " + (rentalsLast7Days != null ? rentalsLast7Days.size() : 0) + " records");
            
            // Doanh thu theo phương thức thanh toán
            java.util.List<Object[]> revenueByMethod = paymentDAO.getRevenueByPaymentMethod();
            request.setAttribute("revenueByMethod", revenueByMethod);
            System.out.println("DashboardController - Revenue By Method: " + (revenueByMethod != null ? revenueByMethod.size() : 0) + " records");
            
            // Số lượng xe
            int totalBikes = bikeDAO.getTotalBikesCount();
            request.setAttribute("totalBikes", totalBikes);
            System.out.println("DashboardController - Total Bikes: " + totalBikes);
            
            int availableBikes = bikeDAO.getAvailableBikesCount();
            request.setAttribute("availableBikes", availableBikes);
            System.out.println("DashboardController - Available Bikes: " + availableBikes);
            
            int inUseBikes = bikeDAO.getInUseBikesCount();
            request.setAttribute("inUseBikes", inUseBikes);
            System.out.println("DashboardController - In Use Bikes: " + inUseBikes);
            
            // Số lượng khách hàng
            int totalCustomers = userDAO.getTotalCustomersCount();
            request.setAttribute("totalCustomers", totalCustomers);
            System.out.println("DashboardController - Total Customers: " + totalCustomers);
            
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard data: " + e.getMessage());
        }
    }
}

