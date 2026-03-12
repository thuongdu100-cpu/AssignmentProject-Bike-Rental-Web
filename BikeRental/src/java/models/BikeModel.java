package models;

import java.io.Serializable;
import java.math.BigDecimal;

public class BikeModel implements Serializable {
    private int modelID;
    private String modelName;
    private String brand;
    private String typeName;
    private BigDecimal weightKg;
    private boolean hasBattery;

    public BikeModel() {
    }

    public BikeModel(int modelID, String modelName, String brand, String typeName, BigDecimal weightKg, boolean hasBattery) {
        this.modelID = modelID;
        this.modelName = modelName;
        this.brand = brand;
        this.typeName = typeName;
        this.weightKg = weightKg;
        this.hasBattery = hasBattery;
    }

    public int getModelID() {
        return modelID;
    }

    public void setModelID(int modelID) {
        this.modelID = modelID;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public BigDecimal getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(BigDecimal weightKg) {
        this.weightKg = weightKg;
    }

    public boolean isHasBattery() {
        return hasBattery;
    }

    public void setHasBattery(boolean hasBattery) {
        this.hasBattery = hasBattery;
    }
}

