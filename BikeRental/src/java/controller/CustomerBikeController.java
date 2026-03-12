package controller;

import dao.BikeDAO;
import dao.StationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class CustomerBikeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        BikeDAO bikeDAO = new BikeDAO();
        StationDAO stationDAO = new StationDAO();

        String stationIDStr = request.getParameter("stationID");
        String searchKeyword = request.getParameter("search");
        
        Integer stationID = null;
        if (stationIDStr != null && !stationIDStr.isEmpty()) {
            try {
                stationID = Integer.parseInt(stationIDStr);
            } catch (NumberFormatException e) {
                // Invalid stationID, ignore
            }
        }
        
        // Nếu có từ khóa tìm kiếm hoặc lọc theo trạm, sử dụng method search
        if ((searchKeyword != null && !searchKeyword.trim().isEmpty()) || stationID != null) {
            request.setAttribute("bikes", bikeDAO.searchAvailableBikes(searchKeyword, stationID));
            if (stationID != null) {
                request.setAttribute("selectedStation", stationDAO.getStationById(stationID));
            }
        } else {
            // Không có filter, lấy tất cả
            request.setAttribute("bikes", bikeDAO.getAvailableBikes());
        }
        
        // Giữ lại giá trị search keyword để hiển thị lại trong form
        if (searchKeyword != null) {
            request.setAttribute("searchKeyword", searchKeyword);
        }

        request.setAttribute("stations", stationDAO.getAllStations());
        request.getRequestDispatcher("/customer/bikes.jsp").forward(request, response);
    }
}

