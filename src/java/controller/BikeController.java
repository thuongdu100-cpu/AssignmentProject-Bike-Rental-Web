package controller;

import dao.BikeDAO;
import dao.BikeModelDAO;
import dao.StationDAO;
import models.Bike;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class BikeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        BikeDAO bikeDAO = new BikeDAO();
        BikeModelDAO modelDAO = new BikeModelDAO();
        StationDAO stationDAO = new StationDAO();

        if ("list".equals(action) || action == null) {
            String keyword = request.getParameter("keyword");
            String modelIDStr = request.getParameter("modelID");
            String stationIDStr = request.getParameter("stationID");
            String status = request.getParameter("status");
            
            Integer modelID = (modelIDStr != null && !modelIDStr.isEmpty()) ? Integer.parseInt(modelIDStr) : null;
            Integer stationID = (stationIDStr != null && !stationIDStr.isEmpty()) ? Integer.parseInt(stationIDStr) : null;
            
            if (keyword != null || modelID != null || stationID != null || (status != null && !status.isEmpty())) {
                request.setAttribute("bikes", bikeDAO.searchBikes(keyword, modelID, stationID, status));
            } else {
                request.setAttribute("bikes", bikeDAO.getAllBikes());
            }
            request.setAttribute("models", modelDAO.getAllModels());
            request.setAttribute("stations", stationDAO.getAllStations());
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("searchModelID", modelIDStr);
            request.setAttribute("searchStationID", stationIDStr);
            request.setAttribute("searchStatus", status);
            request.getRequestDispatcher("/staff/bikes.jsp").forward(request, response);
        } else if ("view".equals(action)) {
            int bikeID = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("bike", bikeDAO.getBikeById(bikeID));
            request.setAttribute("models", modelDAO.getAllModels());
            request.setAttribute("stations", stationDAO.getAllStations());
            request.getRequestDispatcher("/staff/bike-detail.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            request.setAttribute("models", modelDAO.getAllModels());
            request.setAttribute("stations", stationDAO.getAllStations());
            request.getRequestDispatcher("/staff/bike-add.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int bikeID = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("bike", bikeDAO.getBikeById(bikeID));
            request.setAttribute("models", modelDAO.getAllModels());
            request.setAttribute("stations", stationDAO.getAllStations());
            request.getRequestDispatcher("/staff/bike-edit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        BikeDAO bikeDAO = new BikeDAO();

        if ("add".equals(action)) {
            String serialNumber = request.getParameter("serialNumber");
            
            // Kiểm tra SerialNumber đã tồn tại chưa
            if (serialNumber != null && !serialNumber.trim().isEmpty()) {
                if (bikeDAO.checkSerialNumberExists(serialNumber.trim())) {
                    request.setAttribute("error", "Số seri \"" + serialNumber.trim() + "\" đã tồn tại trong hệ thống. Vui lòng sử dụng số seri khác!");
                    BikeModelDAO modelDAO = new BikeModelDAO();
                    StationDAO stationDAO = new StationDAO();
                    request.setAttribute("models", modelDAO.getAllModels());
                    request.setAttribute("stations", stationDAO.getAllStations());
                    // Giữ lại giá trị đã nhập
                    request.setAttribute("serialNumber", serialNumber.trim());
                    request.setAttribute("modelID", request.getParameter("modelID"));
                    request.setAttribute("currentStationID", request.getParameter("currentStationID"));
                    request.setAttribute("status", request.getParameter("status"));
                    request.setAttribute("batteryPercent", request.getParameter("batteryPercent"));
                    request.setAttribute("imageURL", request.getParameter("imageURL"));
                    request.getRequestDispatcher("/staff/bike-add.jsp").forward(request, response);
                    return;
                }
            }
            
            Bike bike = new Bike();
            bike.setSerialNumber(serialNumber != null ? serialNumber.trim() : null);
            bike.setModelID(Integer.parseInt(request.getParameter("modelID")));
            String stationIDStr = request.getParameter("currentStationID");
            if (stationIDStr != null && !stationIDStr.isEmpty()) {
                bike.setCurrentStationID(Integer.parseInt(stationIDStr));
            }
            bike.setStatus(request.getParameter("status"));
            String batteryStr = request.getParameter("batteryPercent");
            if (batteryStr != null && !batteryStr.isEmpty()) {
                bike.setBatteryPercent(Integer.parseInt(batteryStr));
            }
            bike.setImageURL(request.getParameter("imageURL"));

            if (bikeDAO.addBike(bike)) {
                response.sendRedirect(request.getContextPath() + "/staff/bike?action=list");
            } else {
                request.setAttribute("error", "Thêm xe thất bại!");
                BikeModelDAO modelDAO = new BikeModelDAO();
                StationDAO stationDAO = new StationDAO();
                request.setAttribute("models", modelDAO.getAllModels());
                request.setAttribute("stations", stationDAO.getAllStations());
                request.getRequestDispatcher("/staff/bike-add.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            int bikeID = Integer.parseInt(request.getParameter("bikeID"));
            String serialNumber = request.getParameter("serialNumber");
            
            // Kiểm tra SerialNumber đã tồn tại chưa (trừ xe hiện tại)
            if (serialNumber != null && !serialNumber.trim().isEmpty()) {
                if (bikeDAO.checkSerialNumberExistsExcludingBike(serialNumber.trim(), bikeID)) {
                    request.setAttribute("error", "Số seri \"" + serialNumber.trim() + "\" đã được sử dụng bởi xe khác. Vui lòng sử dụng số seri khác!");
                    BikeModelDAO modelDAO = new BikeModelDAO();
                    StationDAO stationDAO = new StationDAO();
                    request.setAttribute("bike", bikeDAO.getBikeById(bikeID));
                    request.setAttribute("models", modelDAO.getAllModels());
                    request.setAttribute("stations", stationDAO.getAllStations());
                    request.getRequestDispatcher("/staff/bike-edit.jsp").forward(request, response);
                    return;
                }
            }
            
            Bike bike = new Bike();
            bike.setBikeID(bikeID);
            bike.setSerialNumber(serialNumber != null ? serialNumber.trim() : null);
            bike.setModelID(Integer.parseInt(request.getParameter("modelID")));
            String stationIDStr = request.getParameter("currentStationID");
            if (stationIDStr != null && !stationIDStr.isEmpty()) {
                bike.setCurrentStationID(Integer.parseInt(stationIDStr));
            } else {
                bike.setCurrentStationID(null);
            }
            bike.setStatus(request.getParameter("status"));
            String batteryStr = request.getParameter("batteryPercent");
            if (batteryStr != null && !batteryStr.isEmpty()) {
                bike.setBatteryPercent(Integer.parseInt(batteryStr));
            } else {
                bike.setBatteryPercent(null);
            }
            bike.setImageURL(request.getParameter("imageURL"));

            if (bikeDAO.updateBike(bike)) {
                response.sendRedirect(request.getContextPath() + "/staff/bike?action=list");
            } else {
                request.setAttribute("error", "Cập nhật xe thất bại!");
                BikeModelDAO modelDAO = new BikeModelDAO();
                StationDAO stationDAO = new StationDAO();
                request.setAttribute("bike", bikeDAO.getBikeById(bikeID));
                request.setAttribute("models", modelDAO.getAllModels());
                request.setAttribute("stations", stationDAO.getAllStations());
                request.getRequestDispatcher("/staff/bike-edit.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            int bikeID = Integer.parseInt(request.getParameter("bikeID"));
            if (bikeDAO.deleteBike(bikeID)) {
                response.sendRedirect(request.getContextPath() + "/staff/bike?action=list");
            } else {
                request.setAttribute("error", "Xóa xe thất bại!");
                request.setAttribute("bikes", bikeDAO.getAllBikes());
                BikeModelDAO modelDAO = new BikeModelDAO();
                StationDAO stationDAO = new StationDAO();
                request.setAttribute("models", modelDAO.getAllModels());
                request.setAttribute("stations", stationDAO.getAllStations());
                request.getRequestDispatcher("/staff/bikes.jsp").forward(request, response);
            }
        }
    }
}

