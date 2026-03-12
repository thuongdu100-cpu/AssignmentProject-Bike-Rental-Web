package controller;

import dao.RentalDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class RentalManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"Staff".equals(role) && !"Admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/customer-bikes");
            return;
        }
        
        String action = request.getParameter("action");
        RentalDAO rentalDAO = new RentalDAO();

        if ("list".equals(action) || action == null) {
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            
            if ((keyword != null && !keyword.trim().isEmpty()) || (status != null && !status.trim().isEmpty())) {
                request.setAttribute("rentals", rentalDAO.searchRentals(keyword, status));
                request.setAttribute("searchKeyword", keyword);
                request.setAttribute("searchStatus", status);
            } else {
                request.setAttribute("rentals", rentalDAO.getAllRentals());
            }
            request.getRequestDispatcher("/staff/rentals.jsp").forward(request, response);
        } else if ("view".equals(action)) {
            long rentalID = Long.parseLong(request.getParameter("id"));
            models.Rental rental = rentalDAO.getRentalById(rentalID);
            
            if (rental == null) {
                response.sendRedirect(request.getContextPath() + "/staff/rental?action=list");
                return;
            }
            
            // Lấy thông tin customer đầy đủ (phone, role, status, createdAt)
            if (rental.getCustomer() != null) {
                dao.UserDAO userDAO = new dao.UserDAO();
                models.User fullCustomer = userDAO.getUserById(rental.getCustomerID());
                if (fullCustomer != null) {
                    rental.setCustomer(fullCustomer);
                }
            }
            
            // Lấy thông tin bike đầy đủ (model, image, status, battery)
            if (rental.getBike() != null) {
                dao.BikeDAO bikeDAO = new dao.BikeDAO();
                models.Bike fullBike = bikeDAO.getBikeById(rental.getBikeID());
                if (fullBike != null) {
                    rental.setBike(fullBike);
                }
            }
            
            // Lấy thông tin start station đầy đủ (address, stationCode, capacity)
            if (rental.getStartStation() != null) {
                dao.StationDAO stationDAO = new dao.StationDAO();
                models.Station fullStartStation = stationDAO.getStationById(rental.getStartStationID());
                if (fullStartStation != null) {
                    rental.setStartStation(fullStartStation);
                }
            }
            
            // Lấy thông tin end station đầy đủ (address, stationCode, capacity)
            if (rental.getEndStationID() != null && rental.getEndStation() != null) {
                dao.StationDAO stationDAO = new dao.StationDAO();
                models.Station fullEndStation = stationDAO.getStationById(rental.getEndStationID());
                if (fullEndStation != null) {
                    rental.setEndStation(fullEndStation);
                }
            }
            
            // Lấy payment information nếu có
            dao.PaymentDAO paymentDAO = new dao.PaymentDAO();
            models.Payment payment = paymentDAO.getPaymentByRentalId(rentalID);
            
            request.setAttribute("rental", rental);
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/staff/rental-detail.jsp").forward(request, response);
        }
    }
}

