package models;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment implements Serializable {
    private long paymentID;
    private long rentalID;
    private BigDecimal amount;
    private String currency;
    private String method;
    private String status;
    private String transactionRef;
    private Timestamp createdAt;
    private Rental rental;

    public Payment() {
    }

    public Payment(long paymentID, long rentalID, BigDecimal amount, String currency, String method, String status, String transactionRef, Timestamp createdAt) {
        this.paymentID = paymentID;
        this.rentalID = rentalID;
        this.amount = amount;
        this.currency = currency;
        this.method = method;
        this.status = status;
        this.transactionRef = transactionRef;
        this.createdAt = createdAt;
    }

    public long getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(long paymentID) {
        this.paymentID = paymentID;
    }

    public long getRentalID() {
        return rentalID;
    }

    public void setRentalID(long rentalID) {
        this.rentalID = rentalID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionRef() {
        return transactionRef;
    }

    public void setTransactionRef(String transactionRef) {
        this.transactionRef = transactionRef;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Rental getRental() {
        return rental;
    }

    public void setRental(Rental rental) {
        this.rental = rental;
    }
}

