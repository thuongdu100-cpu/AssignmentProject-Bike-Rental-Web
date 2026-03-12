package dao;

import models.Bike;
import models.BikeModel;
import models.Station;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BikeDAO extends DBContext {

    public List<Bike> getAllBikes() {
        List<Bike> list = new ArrayList<>();
        String sql = "SELECT b.*, bm.ModelName, bm.Brand, bm.TypeName, s.Name as StationName, s.StationCode "
                + "FROM Bikes b "
                + "LEFT JOIN BikeModels bm ON b.ModelID = bm.ModelID "
                + "LEFT JOIN Stations s ON b.CurrentStationID = s.StationID "
                + "ORDER BY b.BikeID DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bike bike = mapBikeFromResultSet(rs);
                list.add(bike);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Bike> getAvailableBikesByStation(int stationID) {
        List<Bike> list = new ArrayList<>();
        String sql = "SELECT b.*, bm.ModelName, bm.Brand, bm.TypeName, s.Name as StationName, s.StationCode "
                + "FROM Bikes b "
                + "LEFT JOIN BikeModels bm ON b.ModelID = bm.ModelID "
                + "LEFT JOIN Stations s ON b.CurrentStationID = s.StationID "
                + "WHERE b.CurrentStationID = ? AND b.Status = 'available' "
                + "ORDER BY b.BikeID";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, stationID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bike bike = mapBikeFromResultSet(rs);
                list.add(bike);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Bike> getAvailableBikes() {
        List<Bike> list = new ArrayList<>();
        String sql = "SELECT b.*, bm.ModelName, bm.Brand, bm.TypeName, s.Name as StationName, s.StationCode "
                + "FROM Bikes b "
                + "LEFT JOIN BikeModels bm ON b.ModelID = bm.ModelID "
                + "LEFT JOIN Stations s ON b.CurrentStationID = s.StationID "
                + "WHERE b.Status = 'available' "
                + "ORDER BY b.BikeID";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bike bike = mapBikeFromResultSet(rs);
                list.add(bike);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Bike> searchAvailableBikes(String keyword, Integer stationID) {
        List<Bike> list = new ArrayList<>();
        String sql = "SELECT b.*, bm.ModelName, bm.Brand, bm.TypeName, s.Name as StationName, s.StationCode "
                + "FROM Bikes b "
                + "LEFT JOIN BikeModels bm ON b.ModelID = bm.ModelID "
                + "LEFT JOIN Stations s ON b.CurrentStationID = s.StationID "
                + "WHERE b.Status = 'available' ";
        
        // Thêm điều kiện tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND (bm.ModelName LIKE ? OR bm.Brand LIKE ? OR b.SerialNumber LIKE ? OR s.Name LIKE ? OR s.StationCode LIKE ?) ";
        }
        
        // Thêm điều kiện lọc theo trạm
        if (stationID != null) {
            sql += "AND b.CurrentStationID = ? ";
        }
        
        sql += "ORDER BY b.BikeID";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int paramIndex = 1;
            
            // Set parameters cho keyword search
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setNString(paramIndex++, searchPattern);
                ps.setNString(paramIndex++, searchPattern);
                ps.setNString(paramIndex++, searchPattern);
                ps.setNString(paramIndex++, searchPattern);
                ps.setNString(paramIndex++, searchPattern);
            }
            
            // Set parameter cho stationID
            if (stationID != null) {
                ps.setInt(paramIndex++, stationID);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bike bike = mapBikeFromResultSet(rs);
                list.add(bike);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Bike getBikeById(int bikeID) {
        String sql = "SELECT b.*, bm.ModelName, bm.Brand, bm.TypeName, s.Name as StationName, s.StationCode "
                + "FROM Bikes b "
                + "LEFT JOIN BikeModels bm ON b.ModelID = bm.ModelID "
                + "LEFT JOIN Stations s ON b.CurrentStationID = s.StationID "
                + "WHERE b.BikeID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bikeID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapBikeFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Bike mapBikeFromResultSet(ResultSet rs) throws SQLException {
        Bike bike = new Bike();
        bike.setBikeID(rs.getInt("BikeID"));
        bike.setSerialNumber(rs.getNString("SerialNumber"));
        bike.setModelID(rs.getInt("ModelID"));
        bike.setCurrentStationID(rs.getObject("CurrentStationID") != null ? rs.getInt("CurrentStationID") : null);
        bike.setStatus(rs.getNString("Status"));
        bike.setBatteryPercent(rs.getObject("BatteryPercent") != null ? rs.getInt("BatteryPercent") : null);
        bike.setImageURL(rs.getNString("ImageURL"));
        bike.setCreatedAt(rs.getTimestamp("CreatedAt"));

        BikeModel model = new BikeModel();
        model.setModelID(rs.getInt("ModelID"));
        model.setModelName(rs.getNString("ModelName"));
        model.setBrand(rs.getNString("Brand"));
        model.setTypeName(rs.getNString("TypeName"));
        bike.setModel(model);

        if (bike.getCurrentStationID() != null) {
            Station station = new Station();
            station.setStationID(bike.getCurrentStationID());
            station.setName(rs.getNString("StationName"));
            station.setStationCode(rs.getNString("StationCode"));
            bike.setStation(station);
        }

        return bike;
    }

    public boolean checkSerialNumberExists(String serialNumber) {
        String sql = "SELECT COUNT(*) FROM Bikes WHERE SerialNumber = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, serialNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkSerialNumberExistsExcludingBike(String serialNumber, int excludeBikeID) {
        String sql = "SELECT COUNT(*) FROM Bikes WHERE SerialNumber = ? AND BikeID != ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, serialNumber);
            ps.setInt(2, excludeBikeID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addBike(Bike bike) {
        String sql = "INSERT INTO Bikes (SerialNumber, ModelID, CurrentStationID, Status, BatteryPercent, ImageURL) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, bike.getSerialNumber());
            ps.setInt(2, bike.getModelID());
            if (bike.getCurrentStationID() != null) {
                ps.setInt(3, bike.getCurrentStationID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setNString(4, bike.getStatus());
            if (bike.getBatteryPercent() != null) {
                ps.setInt(5, bike.getBatteryPercent());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setNString(6, bike.getImageURL());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBike(Bike bike) {
        String sql = "UPDATE Bikes SET SerialNumber = ?, ModelID = ?, CurrentStationID = ?, Status = ?, BatteryPercent = ?, ImageURL = ? WHERE BikeID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, bike.getSerialNumber());
            ps.setInt(2, bike.getModelID());
            if (bike.getCurrentStationID() != null) {
                ps.setInt(3, bike.getCurrentStationID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setNString(4, bike.getStatus());
            if (bike.getBatteryPercent() != null) {
                ps.setInt(5, bike.getBatteryPercent());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setNString(6, bike.getImageURL());
            ps.setInt(7, bike.getBikeID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBikeStatus(int bikeID, String status) {
        String sql = "UPDATE Bikes SET Status = ? WHERE BikeID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, status);
            ps.setInt(2, bikeID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBikeStation(int bikeID, Integer stationID) {
        String sql = "UPDATE Bikes SET CurrentStationID = ? WHERE BikeID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (stationID != null) {
                ps.setInt(1, stationID);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, bikeID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Bike> searchBikes(String keyword, Integer modelID, Integer stationID, String status) {
        List<Bike> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.*, bm.ModelName, bm.Brand, bm.TypeName, s.Name as StationName, s.StationCode "
                + "FROM Bikes b "
                + "LEFT JOIN BikeModels bm ON b.ModelID = bm.ModelID "
                + "LEFT JOIN Stations s ON b.CurrentStationID = s.StationID "
                + "WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (b.SerialNumber LIKE ? OR bm.ModelName LIKE ? OR bm.Brand LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (modelID != null && modelID > 0) {
            sql.append(" AND b.ModelID = ?");
            params.add(modelID);
        }
        if (stationID != null && stationID > 0) {
            sql.append(" AND b.CurrentStationID = ?");
            params.add(stationID);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND b.Status = ?");
            params.add(status.trim());
        }
        sql.append(" ORDER BY b.BikeID DESC");
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setNString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapBikeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteBike(int bikeID) {
        String sql = "DELETE FROM Bikes WHERE BikeID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bikeID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalBikesCount() {
        String sql = "SELECT COUNT(*) FROM Bikes";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getAvailableBikesCount() {
        String sql = "SELECT COUNT(*) FROM Bikes WHERE Status = 'available'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getInUseBikesCount() {
        String sql = "SELECT COUNT(*) FROM Bikes WHERE Status = 'in_use'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

