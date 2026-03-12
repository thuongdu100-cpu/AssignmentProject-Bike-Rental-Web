package dao;

import models.Payment;
import util.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO extends DBContext {

    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (RentalID, Amount, Currency, Method, Status, TransactionRef) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, payment.getRentalID());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setNString(3, payment.getCurrency());
            ps.setNString(4, payment.getMethod());
            ps.setNString(5, payment.getStatus());
            ps.setNString(6, payment.getTransactionRef());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Payment getPaymentByRentalId(long rentalID) {
        String sql = "SELECT * FROM Payments WHERE RentalID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, rentalID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(rs.getLong("PaymentID"));
                payment.setRentalID(rs.getLong("RentalID"));
                payment.setAmount(rs.getBigDecimal("Amount"));
                payment.setCurrency(rs.getNString("Currency"));
                payment.setMethod(rs.getNString("Method"));
                payment.setStatus(rs.getNString("Status"));
                payment.setTransactionRef(rs.getNString("TransactionRef"));
                payment.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return payment;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePaymentStatus(long paymentID, String status) {
        String sql = "UPDATE Payments SET Status = ? WHERE PaymentID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, status);
            ps.setLong(2, paymentID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Payment> getPaymentsByCustomer(int customerID) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Payments p "
                + "INNER JOIN Rentals r ON p.RentalID = r.RentalID "
                + "WHERE r.CustomerID = ? "
                + "ORDER BY p.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(rs.getLong("PaymentID"));
                payment.setRentalID(rs.getLong("RentalID"));
                payment.setAmount(rs.getBigDecimal("Amount"));
                payment.setCurrency(rs.getNString("Currency"));
                payment.setMethod(rs.getNString("Method"));
                payment.setStatus(rs.getNString("Status"));
                payment.setTransactionRef(rs.getNString("TransactionRef"));
                payment.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Payment getPaymentByTransactionRef(String transactionRef) {
        String sql = "SELECT * FROM Payments WHERE TransactionRef = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, transactionRef);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(rs.getLong("PaymentID"));
                payment.setRentalID(rs.getLong("RentalID"));
                payment.setAmount(rs.getBigDecimal("Amount"));
                payment.setCurrency(rs.getNString("Currency"));
                payment.setMethod(rs.getNString("Method"));
                payment.setStatus(rs.getNString("Status"));
                payment.setTransactionRef(rs.getNString("TransactionRef"));
                payment.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return payment;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePaymentByTransactionRef(String transactionRef, String status, String vnpTransactionNo) {
        String sql = "UPDATE Payments SET Status = ?, TransactionRef = ? WHERE TransactionRef = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, status);
            ps.setNString(2, vnpTransactionNo != null ? vnpTransactionNo : transactionRef);
            ps.setNString(3, transactionRef);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public BigDecimal getTotalRevenue() {
        String sql = "SELECT SUM(Amount) FROM Payments WHERE Status = 'paid'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getTodayRevenue() {
        String sql = "SELECT SUM(Amount) FROM Payments WHERE Status = 'paid' AND CAST(CreatedAt AS DATE) = CAST(GETDATE() AS DATE)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getMonthRevenue() {
        String sql = "SELECT SUM(Amount) FROM Payments WHERE Status = 'paid' AND YEAR(CreatedAt) = YEAR(GETDATE()) AND MONTH(CreatedAt) = MONTH(GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public List<Object[]> getRevenueLast7Days() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT CAST(CreatedAt AS DATE) as Date, SUM(Amount) as Revenue " +
                     "FROM Payments " +
                     "WHERE Status = 'paid' AND CreatedAt >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) " +
                     "GROUP BY CAST(CreatedAt AS DATE) " +
                     "ORDER BY Date";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getDate("Date");
                row[1] = rs.getBigDecimal("Revenue") != null ? rs.getBigDecimal("Revenue") : BigDecimal.ZERO;
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Object[]> getRevenueLast12Months() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT FORMAT(CreatedAt, 'yyyy-MM') as Month, SUM(Amount) as Revenue " +
                     "FROM Payments " +
                     "WHERE Status = 'paid' AND CreatedAt >= DATEADD(MONTH, -11, GETDATE()) " +
                     "GROUP BY FORMAT(CreatedAt, 'yyyy-MM') " +
                     "ORDER BY Month";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("Month");
                row[1] = rs.getBigDecimal("Revenue") != null ? rs.getBigDecimal("Revenue") : BigDecimal.ZERO;
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Object[]> getRevenueByPaymentMethod() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT Method, SUM(Amount) as Revenue " +
                     "FROM Payments " +
                     "WHERE Status = 'paid' " +
                     "GROUP BY Method " +
                     "ORDER BY Revenue DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("Method");
                row[1] = rs.getBigDecimal("Revenue") != null ? rs.getBigDecimal("Revenue") : BigDecimal.ZERO;
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

