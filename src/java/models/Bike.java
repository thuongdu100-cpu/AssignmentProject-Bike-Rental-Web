package models;

import java.io.Serializable;
import java.sql.Timestamp;

public class Bike implements Serializable {
    private int bikeID;
    private String serialNumber;
    private int modelID;
    private Integer currentStationID;
    private String status;
    private Integer batteryPercent;
    private String imageURL;
    private Timestamp createdAt;
    private BikeModel model;
    private Station station;

    public Bike() {
    }

    public Bike(int bikeID, String serialNumber, int modelID, Integer currentStationID, String status, Integer batteryPercent, String imageURL, Timestamp createdAt) {
        this.bikeID = bikeID;
        this.serialNumber = serialNumber;
        this.modelID = modelID;
        this.currentStationID = currentStationID;
        this.status = status;
        this.batteryPercent = batteryPercent;
        this.imageURL = imageURL;
        this.createdAt = createdAt;
    }

    public int getBikeID() {
        return bikeID;
    }

    public void setBikeID(int bikeID) {
        this.bikeID = bikeID;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public int getModelID() {
        return modelID;
    }

    public void setModelID(int modelID) {
        this.modelID = modelID;
    }

    public Integer getCurrentStationID() {
        return currentStationID;
    }

    public void setCurrentStationID(Integer currentStationID) {
        this.currentStationID = currentStationID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getBatteryPercent() {
        return batteryPercent;
    }

    public void setBatteryPercent(Integer batteryPercent) {
        this.batteryPercent = batteryPercent;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public BikeModel getModel() {
        return model;
    }

    public void setModel(BikeModel model) {
        this.model = model;
    }

    public Station getStation() {
        return station;
    }

    public void setStation(Station station) {
        this.station = station;
    }
}

