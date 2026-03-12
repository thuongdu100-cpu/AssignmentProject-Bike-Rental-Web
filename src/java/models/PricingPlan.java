package models;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class PricingPlan implements Serializable {
    private int planID;
    private String planName;
    private BigDecimal unlockFee;
    private BigDecimal pricePerMin;
    private int freeMinutes;
    private BigDecimal dailyCap;
    private boolean isActive;
    private Timestamp createdAt;

    public PricingPlan() {
    }

    public PricingPlan(int planID, String planName, BigDecimal unlockFee, BigDecimal pricePerMin, int freeMinutes, BigDecimal dailyCap, boolean isActive, Timestamp createdAt) {
        this.planID = planID;
        this.planName = planName;
        this.unlockFee = unlockFee;
        this.pricePerMin = pricePerMin;
        this.freeMinutes = freeMinutes;
        this.dailyCap = dailyCap;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getPlanID() {
        return planID;
    }

    public void setPlanID(int planID) {
        this.planID = planID;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    public BigDecimal getUnlockFee() {
        return unlockFee;
    }

    public void setUnlockFee(BigDecimal unlockFee) {
        this.unlockFee = unlockFee;
    }

    public BigDecimal getPricePerMin() {
        return pricePerMin;
    }

    public void setPricePerMin(BigDecimal pricePerMin) {
        this.pricePerMin = pricePerMin;
    }

    public int getFreeMinutes() {
        return freeMinutes;
    }

    public void setFreeMinutes(int freeMinutes) {
        this.freeMinutes = freeMinutes;
    }

    public BigDecimal getDailyCap() {
        return dailyCap;
    }

    public void setDailyCap(BigDecimal dailyCap) {
        this.dailyCap = dailyCap;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

