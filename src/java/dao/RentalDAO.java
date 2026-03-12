package dao;

import models.Rental;
import models.User;
import models.Bike;
import models.PricingPlan;
import models.Station;
import util.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RentalDAO extends DBContext {

    public boolean startRental(Rental rental) {
        String sql = "INSERT INTO Rentals (CustomerID, BikeID, PlanID, StartStationID, StartTime, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, rental.getCustomerID());
            ps.setInt(2, rental.getBikeID());
            if (rental.getPlanID() != null) {
                ps.setInt(3, rental.getPlanID());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setInt(4, rental.getStartStationID());
            ps.setTimestamp(5, rental.getStartTime());
            ps.setNString(6, rental.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean endRental(long rentalID, int endStationID, Timestamp endTime, BigDecimal costAmount) {
        String sql = "UPDATE Rentals SET EndStationID = ?, EndTime = ?, CostAmount = ?, Status = 'completed' WHERE RentalID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, endStationID);
            ps.setTimestamp(2, endTime);
            ps.setBigDecimal(3, costAmount);
            ps.setLong(4, rentalID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Rental getOngoingRentalByCustomer(int customerID) {
        String sql = "SELECT r.*, u.FullName, u.Email, b.SerialNumber, "
                + "p.PlanID, p.PlanName, p.UnlockFee, p.PricePerMin, p.FreeMinutes, p.DailyCap, p.IsActive, "
                + "s1.Name as StartStationName, s2.Name as EndStationName "
                + "FROM Rentals r "
                + "INNER JOIN Users u ON r.CustomerID = u.UserID "
                + "INNER JOIN Bikes b ON r.BikeID = b.BikeID "
                + "LEFT JOIN PricingPlans p ON r.PlanID = p.PlanID "
                + "LEFT JOIN Stations s1 ON r.StartStationID = s1.StationID "
                + "LEFT JOIN Stations s2 ON r.EndStationID = s2.StationID "
                + "WHERE r.CustomerID = ? AND r.Status = 'ongoing' "
                + "ORDER BY r.StartTime DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRentalFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Rental getRentalById(long rentalID) {
        String sql = "SELECT r.*, u.FullName, u.Email, b.SerialNumber, "
                + "p.PlanID, p.PlanName, p.UnlockFee, p.PricePerMin, p.FreeMinutes, p.DailyCap, p.IsActive, "
                + "s1.Name as StartStationName, s2.Name as EndStationName "
                + "FROM Rentals r "
                + "INNER JOIN Users u ON r.CustomerID = u.UserID "
                + "INNER JOIN Bikes b ON r.BikeID = b.BikeID "
                + "LEFT JOIN PricingPlans p ON r.PlanID = p.PlanID "
                + "LEFT JOIN Stations s1 ON r.StartStationID = s1.StationID "
                + "LEFT JOIN Stations s2 ON r.EndStationID = s2.StationID "
                + "WHERE r.RentalID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, rentalID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRentalFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Rental> getRentalsByCustomer(int customerID) {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT r.*, u.FullName, u.Email, b.SerialNumber, "
                + "p.PlanID, p.PlanName, p.UnlockFee, p.PricePerMin, p.FreeMinutes, p.DailyCap, p.IsActive, "
                + "s1.Name as StartStationName, s2.Name as EndStationName "
                + "FROM Rentals r "
                + "INNER JOIN Users u ON r.CustomerID = u.UserID "
                + "INNER JOIN Bikes b ON r.BikeID = b.BikeID "
                + "LEFT JOIN PricingPlans p ON r.PlanID = p.PlanID "
                + "LEFT JOIN Stations s1 ON r.StartStationID = s1.StationID "
                + "LEFT JOIN Stations s2 ON r.EndStationID = s2.StationID "
                + "WHERE r.CustomerID = ? "
                + "ORDER BY r.StartTime DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRentalFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Rental> getAllRentals() {
        List<Rental> list = new ArrayList<>();
        String sql = "SELECT r.*, u.FullName, u.Email, b.SerialNumber, "
                + "p.PlanID, p.PlanName, p.UnlockFee, p.PricePerMin, p.FreeMinutes, p.DailyCap, p.IsActive, "
                + "s1.Name as StartStationName, s2.Name as EndStationName "
                + "FROM Rentals r "
                + "INNER JOIN Users u ON r.CustomerID = u.UserID "
                + "INNER JOIN Bikes b ON r.BikeID = b.BikeID "
                + "LEFT JOIN PricingPlans p ON r.PlanID = p.PlanID "
                + "LEFT JOIN Stations s1 ON r.StartStationID = s1.StationID "
                + "LEFT JOIN Stations s2 ON r.EndStationID = s2.StationID "
                + "ORDER BY r.StartTime DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRentalFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Rental> searchRentals(String keyword, String status) {
        List<Rental> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, u.FullName, u.Email, b.SerialNumber, "
                + "p.PlanID, p.PlanName, p.UnlockFee, p.PricePerMin, p.FreeMinutes, p.DailyCap, p.IsActive, "
                + "s1.Name as StartStationName, s2.Name as EndStationName "
                + "FROM Rentals r "
                + "INNER JOIN Users u ON r.CustomerID = u.UserID "
                + "INNER JOIN Bikes b ON r.BikeID = b.BikeID "
                + "LEFT JOIN PricingPlans p ON r.PlanID = p.PlanID "
                + "LEFT JOIN Stations s1 ON r.StartStationID = s1.StationID "
                + "LEFT JOIN Stations s2 ON r.EndStationID = s2.StationID "
                + "WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (CAST(r.RentalID AS NVARCHAR) LIKE ? OR u.FullName LIKE ? OR u.Email LIKE ? OR b.SerialNumber LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.Status = ?");
            params.add(status.trim());
        }
        sql.append(" ORDER BY r.StartTime DESC");
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setNString(i + 1, (String) param);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRentalFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalRentalsCount() {
        String sql = "SELECT COUNT(*) FROM Rentals";
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

    public int getTodayRentalsCount() {
        String sql = "SELECT COUNT(*) FROM Rentals WHERE CAST(StartTime AS DATE) = CAST(GETDATE() AS DATE)";
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

    public List<Object[]> getRentalsLast7Days() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT CAST(StartTime AS DATE) as Date, COUNT(*) as Count " +
                     "FROM Rentals " +
                     "WHERE StartTime >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) " +
                     "GROUP BY CAST(StartTime AS DATE) " +
                     "ORDER BY Date";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getDate("Date");
                row[1] = rs.getInt("Count");
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Rental mapRentalFromResultSet(ResultSet rs) throws SQLException {
        Rental rental = new Rental();
        rental.setRentalID(rs.getLong("RentalID"));
        rental.setCustomerID(rs.getInt("CustomerID"));
        rental.setBikeID(rs.getInt("BikeID"));
        rental.setPlanID(rs.getObject("PlanID") != null ? rs.getInt("PlanID") : null);
        rental.setStartStationID(rs.getInt("StartStationID"));
        rental.setEndStationID(rs.getObject("EndStationID") != null ? rs.getInt("EndStationID") : null);
        rental.setStartTime(rs.getTimestamp("StartTime"));
        rental.setEndTime(rs.getTimestamp("EndTime"));
        rental.setCostAmount(rs.getBigDecimal("CostAmount"));
        rental.setStatus(rs.getNString("Status"));
        rental.setCreatedAt(rs.getTimestamp("CreatedAt"));

        User customer = new User();
        customer.setUserID(rs.getInt("CustomerID"));
        customer.setFullName(rs.getNString("FullName"));
        customer.setEmail(rs.getNString("Email"));
        rental.setCustomer(customer);

        Bike bike = new Bike();
        bike.setBikeID(rs.getInt("BikeID"));
        bike.setSerialNumber(rs.getNString("SerialNumber"));
        rental.setBike(bike);

        if (rental.getPlanID() != null && rs.getObject("PlanID") != null) {
            PricingPlan plan = new PricingPlan();
            plan.setPlanID(rs.getInt("PlanID"));
            plan.setPlanName(rs.getNString("PlanName"));
            plan.setUnlockFee(rs.getBigDecimal("UnlockFee"));
            plan.setPricePerMin(rs.getBigDecimal("PricePerMin"));
            plan.setFreeMinutes(rs.getInt("FreeMinutes"));
            plan.setDailyCap(rs.getBigDecimal("DailyCap"));
            plan.setIsActive(rs.getBoolean("IsActive"));
            rental.setPlan(plan);
        }

        Station startStation = new Station();
        startStation.setStationID(rental.getStartStationID());
        startStation.setName(rs.getNString("StartStationName"));
        rental.setStartStation(startStation);

        if (rental.getEndStationID() != null) {
            Station endStation = new Station();
            endStation.setStationID(rental.getEndStationID());
            endStation.setName(rs.getNString("EndStationName"));
            rental.setEndStation(endStation);
        }

        return rental;
    }

    public BigDecimal calculateRentalCost(Rental rental, PricingPlan plan) {
        if (rental.getEndTime() == null || rental.getStartTime() == null) {
            return BigDecimal.ZERO;
        }

        long durationMillis = rental.getEndTime().getTime() - rental.getStartTime().getTime();
        long durationMinutes = durationMillis / (1000 * 60);

        BigDecimal totalCost = plan.getUnlockFee();
        int billableMinutes = (int) Math.max(0, durationMinutes - plan.getFreeMinutes());
        if (billableMinutes > 0) {
            totalCost = totalCost.add(plan.getPricePerMin().multiply(BigDecimal.valueOf(billableMinutes)));
        }

        if (plan.getDailyCap() != null && totalCost.compareTo(plan.getDailyCap()) > 0) {
            totalCost = plan.getDailyCap();
        }

        return totalCost;
    }
}

