package dao;

import models.BikeModel;
import util.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BikeModelDAO extends DBContext {

    public List<BikeModel> getAllModels() {
        List<BikeModel> list = new ArrayList<>();
        String sql = "SELECT * FROM BikeModels ORDER BY ModelName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BikeModel model = new BikeModel();
                model.setModelID(rs.getInt("ModelID"));
                model.setModelName(rs.getNString("ModelName"));
                model.setBrand(rs.getNString("Brand"));
                model.setTypeName(rs.getNString("TypeName"));
                model.setWeightKg(rs.getBigDecimal("WeightKg"));
                model.setHasBattery(rs.getBoolean("HasBattery"));
                list.add(model);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public BikeModel getModelById(int modelID) {
        String sql = "SELECT * FROM BikeModels WHERE ModelID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, modelID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BikeModel model = new BikeModel();
                model.setModelID(rs.getInt("ModelID"));
                model.setModelName(rs.getNString("ModelName"));
                model.setBrand(rs.getNString("Brand"));
                model.setTypeName(rs.getNString("TypeName"));
                model.setWeightKg(rs.getBigDecimal("WeightKg"));
                model.setHasBattery(rs.getBoolean("HasBattery"));
                return model;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addModel(BikeModel model) {
        String sql = "INSERT INTO BikeModels (ModelName, Brand, TypeName, WeightKg, HasBattery) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, model.getModelName());
            ps.setNString(2, model.getBrand());
            ps.setNString(3, model.getTypeName());
            ps.setBigDecimal(4, model.getWeightKg());
            ps.setBoolean(5, model.isHasBattery());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateModel(BikeModel model) {
        String sql = "UPDATE BikeModels SET ModelName = ?, Brand = ?, TypeName = ?, WeightKg = ?, HasBattery = ? WHERE ModelID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, model.getModelName());
            ps.setNString(2, model.getBrand());
            ps.setNString(3, model.getTypeName());
            ps.setBigDecimal(4, model.getWeightKg());
            ps.setBoolean(5, model.isHasBattery());
            ps.setInt(6, model.getModelID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<BikeModel> searchModels(String keyword) {
        List<BikeModel> list = new ArrayList<>();
        String sql = "SELECT * FROM BikeModels";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE ModelName LIKE ? OR Brand LIKE ? OR TypeName LIKE ?";
        }
        sql += " ORDER BY ModelName";
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
                BikeModel model = new BikeModel();
                model.setModelID(rs.getInt("ModelID"));
                model.setModelName(rs.getNString("ModelName"));
                model.setBrand(rs.getNString("Brand"));
                model.setTypeName(rs.getNString("TypeName"));
                model.setWeightKg(rs.getBigDecimal("WeightKg"));
                model.setHasBattery(rs.getBoolean("HasBattery"));
                list.add(model);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteModel(int modelID) {
        String sql = "DELETE FROM BikeModels WHERE ModelID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, modelID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

