package controller;

import dao.StationDAO;
import models.Station;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class StationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        StationDAO stationDAO = new StationDAO();

        if ("list".equals(action) || action == null) {
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                request.setAttribute("stations", stationDAO.searchStations(keyword));
                request.setAttribute("searchKeyword", keyword);
            } else {
                request.setAttribute("stations", stationDAO.getAllStations());
            }
            request.getRequestDispatcher("/staff/stations.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            request.getRequestDispatcher("/staff/station-add.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int stationID = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("station", stationDAO.getStationById(stationID));
            request.getRequestDispatcher("/staff/station-edit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        StationDAO stationDAO = new StationDAO();

        if ("add".equals(action)) {
            Station station = new Station();
            station.setStationCode(request.getParameter("stationCode"));
            station.setName(request.getParameter("name"));
            station.setAddress(request.getParameter("address"));
            station.setCapacity(Integer.parseInt(request.getParameter("capacity")));

            if (stationDAO.addStation(station)) {
                response.sendRedirect(request.getContextPath() + "/staff/station?action=list");
            } else {
                request.setAttribute("error", "Thêm trạm thất bại!");
                request.getRequestDispatcher("/staff/station-add.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            Station station = new Station();
            station.setStationID(Integer.parseInt(request.getParameter("stationID")));
            station.setStationCode(request.getParameter("stationCode"));
            station.setName(request.getParameter("name"));
            station.setAddress(request.getParameter("address"));
            station.setCapacity(Integer.parseInt(request.getParameter("capacity")));
            station.setIsActive(Boolean.parseBoolean(request.getParameter("isActive")));

            if (stationDAO.updateStation(station)) {
                response.sendRedirect(request.getContextPath() + "/staff/station?action=list");
            } else {
                request.setAttribute("error", "Cập nhật trạm thất bại!");
                request.getRequestDispatcher("/staff/station-edit.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            int stationID = Integer.parseInt(request.getParameter("stationID"));
            if (stationDAO.deleteStation(stationID)) {
                response.sendRedirect(request.getContextPath() + "/staff/station?action=list");
            } else {
                request.setAttribute("error", "Xóa trạm thất bại!");
                request.getRequestDispatcher("/staff/stations.jsp").forward(request, response);
            }
        }
    }
}

