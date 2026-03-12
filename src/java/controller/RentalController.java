package controller;

import dao.BikeDAO;
import dao.PaymentDAO;
import dao.PricingPlanDAO;
import dao.RentalDAO;
import dao.StationDAO;
import models.Rental;
import models.PricingPlan;
import models.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class RentalController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        RentalDAO rentalDAO = new RentalDAO();
        int userID = (Integer) session.getAttribute("userID");

        if ("start".equals(action)) {
            BikeDAO bikeDAO = new BikeDAO();
            StationDAO stationDAO = new StationDAO();
            PricingPlanDAO planDAO = new PricingPlanDAO();

            int bikeID = Integer.parseInt(request.getParameter("bikeID"));
            request.setAttribute("bike", bikeDAO.getBikeById(bikeID));
            request.setAttribute("stations", stationDAO.getAllStations());
            request.setAttribute("plans", planDAO.getActivePlans());
            request.getRequestDispatcher("/customer/rental-start.jsp").forward(request, response);
        } else if ("ongoing".equals(action)) {
            Rental ongoingRental = rentalDAO.getOngoingRentalByCustomer(userID);
            if (ongoingRental != null) {
                request.setAttribute("rental", ongoingRental);
                request.setAttribute("stations", new StationDAO().getAllStations());
                // Get rental minutes from session, default to 30 if not set
                Integer rentalMinutes = (Integer) session.getAttribute("rentalMinutes");
                if (rentalMinutes == null) {
                    rentalMinutes = 30;
                    session.setAttribute("rentalMinutes", rentalMinutes);
                }
                request.setAttribute("rentalMinutes", rentalMinutes);
                request.getRequestDispatcher("/customer/rental-ongoing.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/rental?action=list");
            }
        } else if ("list".equals(action) || action == null) {
            request.setAttribute("rentals", rentalDAO.getRentalsByCustomer(userID));
            request.getRequestDispatcher("/customer/rentals.jsp").forward(request, response);
        } else if ("invoice".equals(action)) {
            // Hiển thị invoice cho rental đã hoàn thành
            String rentalIDStr = request.getParameter("rentalID");
            if (rentalIDStr == null || rentalIDStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/rental?action=list");
                return;
            }
            
            long rentalID = Long.parseLong(rentalIDStr);
            Rental rental = rentalDAO.getRentalById(rentalID);
            
            // Kiểm tra rental có thuộc về user hiện tại và đã hoàn thành
            if (rental == null || rental.getCustomerID() != userID || !"completed".equals(rental.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/rental?action=list");
                return;
            }
            
            // Lấy thông tin bike đầy đủ (model, image)
            if (rental.getBike() != null) {
                BikeDAO bikeDAO = new BikeDAO();
                models.Bike fullBike = bikeDAO.getBikeById(rental.getBikeID());
                if (fullBike != null) {
                    rental.setBike(fullBike);
                }
            }
            
            // Lấy payment information
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment payment = paymentDAO.getPaymentByRentalId(rentalID);
            
            // Set attributes để hiển thị invoice
            request.setAttribute("rental", rental);
            request.setAttribute("payment", payment);
            request.setAttribute("isValid", true);
            request.setAttribute("isSuccess", payment != null && "paid".equals(payment.getStatus()));
            
            // Set VNPay transaction info nếu có
            if (payment != null && payment.getTransactionRef() != null) {
                request.setAttribute("vnp_TxnRef", payment.getTransactionRef());
                request.setAttribute("vnp_Amount", payment.getAmount() != null ? String.valueOf(payment.getAmount().longValue() * 100) : "");
            }
            
            request.getRequestDispatcher("/customer/payment-result.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        RentalDAO rentalDAO = new RentalDAO();
        BikeDAO bikeDAO = new BikeDAO();
        int userID = (Integer) session.getAttribute("userID");

        if ("start".equals(action)) {
            Rental rental = new Rental();
            rental.setCustomerID(userID);
            rental.setBikeID(Integer.parseInt(request.getParameter("bikeID")));
            String planIDStr = request.getParameter("planID");
            if (planIDStr != null && !planIDStr.isEmpty()) {
                rental.setPlanID(Integer.parseInt(planIDStr));
            }
            rental.setStartStationID(Integer.parseInt(request.getParameter("startStationID")));
            rental.setStartTime(new Timestamp(System.currentTimeMillis()));
            rental.setStatus("ongoing");
            
            // Save rental minutes to session
            String rentalMinutesStr = request.getParameter("rentalMinutes");
            if (rentalMinutesStr != null && !rentalMinutesStr.isEmpty()) {
                try {
                    int rentalMinutes = Integer.parseInt(rentalMinutesStr);
                    session.setAttribute("rentalMinutes", rentalMinutes);
                } catch (NumberFormatException e) {
                    // Default to 30 minutes if invalid
                    session.setAttribute("rentalMinutes", 30);
                }
            } else {
                session.setAttribute("rentalMinutes", 30);
            }

            if (rentalDAO.startRental(rental)) {
                bikeDAO.updateBikeStatus(rental.getBikeID(), "in_use");
                bikeDAO.updateBikeStation(rental.getBikeID(), null);
                response.sendRedirect(request.getContextPath() + "/rental?action=ongoing");
            } else {
                request.setAttribute("error", "Bắt đầu thuê xe thất bại!");
                BikeDAO bikeDAO2 = new BikeDAO();
                StationDAO stationDAO2 = new StationDAO();
                PricingPlanDAO planDAO2 = new PricingPlanDAO();
                int bikeID = Integer.parseInt(request.getParameter("bikeID"));
                request.setAttribute("bike", bikeDAO2.getBikeById(bikeID));
                request.setAttribute("stations", stationDAO2.getAllStations());
                request.setAttribute("plans", planDAO2.getActivePlans());
                request.getRequestDispatcher("/customer/rental-start.jsp").forward(request, response);
            }
        } else if ("end".equals(action)) {
            long rentalID = Long.parseLong(request.getParameter("rentalID"));
            Rental rental = rentalDAO.getRentalById(rentalID);
            
            if (rental != null && rental.getStatus().equals("ongoing")) {
                int endStationID = Integer.parseInt(request.getParameter("endStationID"));
                Timestamp endTime = new Timestamp(System.currentTimeMillis());
                
                // Get rental minutes from session or request parameter
                Integer rentalMinutes = (Integer) session.getAttribute("rentalMinutes");
                String rentalMinutesStr = request.getParameter("rentalMinutes");
                if (rentalMinutesStr != null && !rentalMinutesStr.isEmpty()) {
                    try {
                        rentalMinutes = Integer.parseInt(rentalMinutesStr);
                        session.setAttribute("rentalMinutes", rentalMinutes);
                    } catch (NumberFormatException e) {
                        // Keep existing value from session
                    }
                }
                if (rentalMinutes == null) {
                    rentalMinutes = 30; // Default
                }
                
                // Calculate end time based on rental minutes
                long endTimeMillis = rental.getStartTime().getTime() + (rentalMinutes * 60 * 1000);
                endTime = new Timestamp(endTimeMillis);
                
                // Update rental with end time for cost calculation
                rental.setEndTime(endTime);
                
                PricingPlanDAO planDAO = new PricingPlanDAO();
                PricingPlan plan = planDAO.getPlanById(rental.getPlanID());
                BigDecimal costAmount = rentalDAO.calculateRentalCost(rental, plan);
                
                if (rentalDAO.endRental(rentalID, endStationID, endTime, costAmount)) {
                    // Clear rental minutes from session
                    session.removeAttribute("rentalMinutes");
                    bikeDAO.updateBikeStatus(rental.getBikeID(), "available");
                    bikeDAO.updateBikeStation(rental.getBikeID(), endStationID);
                    // Redirect to payment page
                    response.sendRedirect(request.getContextPath() + "/payment?action=create&rentalID=" + rentalID);
                } else {
                    request.setAttribute("error", "Kết thúc thuê xe thất bại!");
                    Rental ongoingRental = rentalDAO.getOngoingRentalByCustomer(userID);
                    if (ongoingRental != null) {
                        request.setAttribute("rental", ongoingRental);
                        request.setAttribute("stations", new StationDAO().getAllStations());
                    }
                    request.getRequestDispatcher("/customer/rental-ongoing.jsp").forward(request, response);
                }
            }
        }
    }
}

