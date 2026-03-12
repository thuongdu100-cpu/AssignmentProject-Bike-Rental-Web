package dao;

import models.Station;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StationDAO extends DBContext {

    public List<Station> getAllStations() {
        List<Station> list = new ArrayList<>();
        String sql = "SELECT * FROM Stations WHERE IsActive = 1 ORDER BY Name";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Station station = new Station();
                station.setStationID(rs.getInt("StationID"));
                station.setStationCode(rs.getNString("StationCode"));
                station.setName(rs.getNString("Name"));
                station.setAddress(rs.getNString("Address"));
                station.setCapacity(rs.getInt("Capacity"));
                station.setCreatedAt(rs.getTimestamp("CreatedAt"));
                station.setIsActive(rs.getBoolean("IsActive"));
                list.add(station);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Station getStationById(int stationID) {
        String sql = "SELECT * FROM Stations WHERE StationID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, stationID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Station station = new Station();
                station.setStationID(rs.getInt("StationID"));
                station.setStationCode(rs.getNString("StationCode"));
                station.setName(rs.getNString("Name"));
                station.setAddress(rs.getNString("Address"));
                station.setCapacity(rs.getInt("Capacity"));
                station.setCreatedAt(rs.getTimestamp("CreatedAt"));
                station.setIsActive(rs.getBoolean("IsActive"));
                return station;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addStation(Station station) {
        String sql = "INSERT INTO Stations (StationCode, Name, Address, Capacity) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, station.getStationCode());
            ps.setNString(2, station.getName());
            ps.setNString(3, station.getAddress());
            ps.setInt(4, station.getCapacity());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStation(Station station) {
        String sql = "UPDATE Stations SET StationCode = ?, Name = ?, Address = ?, Capacity = ?, IsActive = ? WHERE StationID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, station.getStationCode());
            ps.setNString(2, station.getName());
            ps.setNString(3, station.getAddress());
            ps.setInt(4, station.getCapacity());
            ps.setBoolean(5, station.isActive());
            ps.setInt(6, station.getStationID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteStation(int stationID) {
        String sql = "UPDATE Stations SET IsActive = 0 WHERE StationID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, stationID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getAvailableBikesCount(int stationID) {
        String sql = "SELECT COUNT(*) FROM Bikes WHERE CurrentStationID = ? AND Status = 'available'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, stationID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Station> searchStations(String keyword) {
        List<Station> list = new ArrayList<>();
        String sql = "SELECT * FROM Stations WHERE IsActive = 1";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (StationCode LIKE ? OR Name LIKE ? OR Address LIKE ?)";
        }
        sql += " ORDER BY Name";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setNString(1, searchPattern);
                ps.setNString(2, searchPattern);
                ps.setNString(3, searchPattern);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Station station = new Station();
                station.setStationID(rs.getInt("StationID"));
                station.setStationCode(rs.getNString("StationCode"));
                station.setName(rs.getNString("Name"));
                station.setAddress(rs.getNString("Address"));
                station.setCapacity(rs.getInt("Capacity"));
                station.setCreatedAt(rs.getTimestamp("CreatedAt"));
                station.setIsActive(rs.getBoolean("IsActive"));
                list.add(station);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

