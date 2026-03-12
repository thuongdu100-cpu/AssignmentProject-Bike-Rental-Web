package dao;

import models.PricingPlan;
import util.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PricingPlanDAO extends DBContext {

    public List<PricingPlan> getAllPlans() {
        List<PricingPlan> list = new ArrayList<>();
        String sql = "SELECT * FROM PricingPlans ORDER BY PlanName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PricingPlan plan = mapPlanFromResultSet(rs);
                list.add(plan);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PricingPlan> getActivePlans() {
        List<PricingPlan> list = new ArrayList<>();
        String sql = "SELECT * FROM PricingPlans WHERE IsActive = 1 ORDER BY PlanName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PricingPlan plan = mapPlanFromResultSet(rs);
                list.add(plan);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public PricingPlan getPlanById(int planID) {
        String sql = "SELECT * FROM PricingPlans WHERE PlanID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, planID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapPlanFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private PricingPlan mapPlanFromResultSet(ResultSet rs) throws SQLException {
        PricingPlan plan = new PricingPlan();
        plan.setPlanID(rs.getInt("PlanID"));
        plan.setPlanName(rs.getNString("PlanName"));
        plan.setUnlockFee(rs.getBigDecimal("UnlockFee"));
        plan.setPricePerMin(rs.getBigDecimal("PricePerMin"));
        plan.setFreeMinutes(rs.getInt("FreeMinutes"));
        plan.setDailyCap(rs.getBigDecimal("DailyCap"));
        plan.setIsActive(rs.getBoolean("IsActive"));
        plan.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return plan;
    }

    public boolean addPlan(PricingPlan plan) {
        String sql = "INSERT INTO PricingPlans (PlanName, UnlockFee, PricePerMin, FreeMinutes, DailyCap, IsActive) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, plan.getPlanName());
            ps.setBigDecimal(2, plan.getUnlockFee());
            ps.setBigDecimal(3, plan.getPricePerMin());
            ps.setInt(4, plan.getFreeMinutes());
            ps.setBigDecimal(5, plan.getDailyCap());
            ps.setBoolean(6, plan.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePlan(PricingPlan plan) {
        String sql = "UPDATE PricingPlans SET PlanName = ?, UnlockFee = ?, PricePerMin = ?, FreeMinutes = ?, DailyCap = ?, IsActive = ? WHERE PlanID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, plan.getPlanName());
            ps.setBigDecimal(2, plan.getUnlockFee());
            ps.setBigDecimal(3, plan.getPricePerMin());
            ps.setInt(4, plan.getFreeMinutes());
            ps.setBigDecimal(5, plan.getDailyCap());
            ps.setBoolean(6, plan.isActive());
            ps.setInt(7, plan.getPlanID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<PricingPlan> searchPlans(String keyword) {
        List<PricingPlan> list = new ArrayList<>();
        String sql = "SELECT * FROM PricingPlans";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE PlanName LIKE ?";
        }
        sql += " ORDER BY PlanName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setNString(1, searchPattern);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPlanFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deletePlan(int planID) {
        String sql = "DELETE FROM PricingPlans WHERE PlanID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, planID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

