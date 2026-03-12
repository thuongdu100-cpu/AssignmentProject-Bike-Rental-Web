package models;

import java.io.Serializable;
import java.sql.Timestamp;

public class Station implements Serializable {
    private int stationID;
    private String stationCode;
    private String name;
    private String address;
    private int capacity;
    private Timestamp createdAt;
    private boolean isActive;

    public Station() {
    }

    public Station(int stationID, String stationCode, String name, String address, int capacity, Timestamp createdAt, boolean isActive) {
        this.stationID = stationID;
        this.stationCode = stationCode;
        this.name = name;
        this.address = address;
        this.capacity = capacity;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }

    public int getStationID() {
        return stationID;
    }

    public void setStationID(int stationID) {
        this.stationID = stationID;
    }

    public String getStationCode() {
        return stationCode;
    }

    public void setStationCode(String stationCode) {
        this.stationCode = stationCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
}

