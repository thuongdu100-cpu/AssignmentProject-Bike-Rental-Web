package models;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Rental implements Serializable {
    private long rentalID;
    private int customerID;
    private int bikeID;
    private Integer planID;
    private int startStationID;
    private Integer endStationID;
    private Timestamp startTime;
    private Timestamp endTime;
    private BigDecimal costAmount;
    private String status;
    private Timestamp createdAt;
    private User customer;
    private Bike bike;
    private PricingPlan plan;
    private Station startStation;
    private Station endStation;

    public Rental() {
    }

    public Rental(long rentalID, int customerID, int bikeID, Integer planID, int startStationID, Integer endStationID, Timestamp startTime, Timestamp endTime, BigDecimal costAmount, String status, Timestamp createdAt) {
        this.rentalID = rentalID;
        this.customerID = customerID;
        this.bikeID = bikeID;
        this.planID = planID;
        this.startStationID = startStationID;
        this.endStationID = endStationID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.costAmount = costAmount;
        this.status = status;
        this.createdAt = createdAt;
    }

    public long getRentalID() {
        return rentalID;
    }

    public void setRentalID(long rentalID) {
        this.rentalID = rentalID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getBikeID() {
        return bikeID;
    }

    public void setBikeID(int bikeID) {
        this.bikeID = bikeID;
    }

    public Integer getPlanID() {
        return planID;
    }

    public void setPlanID(Integer planID) {
        this.planID = planID;
    }

    public int getStartStationID() {
        return startStationID;
    }

    public void setStartStationID(int startStationID) {
        this.startStationID = startStationID;
    }

    public Integer getEndStationID() {
        return endStationID;
    }

    public void setEndStationID(Integer endStationID) {
        this.endStationID = endStationID;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public BigDecimal getCostAmount() {
        return costAmount;
    }

    public void setCostAmount(BigDecimal costAmount) {
        this.costAmount = costAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public Bike getBike() {
        return bike;
    }

    public void setBike(Bike bike) {
        this.bike = bike;
    }

    public PricingPlan getPlan() {
        return plan;
    }

    public void setPlan(PricingPlan plan) {
        this.plan = plan;
    }

    public Station getStartStation() {
        return startStation;
    }

    public void setStartStation(Station startStation) {
        this.startStation = startStation;
    }

    public Station getEndStation() {
        return endStation;
    }

    public void setEndStation(Station endStation) {
        this.endStation = endStation;
    }
}

