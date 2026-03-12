package com.bikerental.tests;

import com.bikerental.base.BaseTest;
import com.bikerental.pages.BikePage;
import com.bikerental.pages.LoginPage;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class BikeTests extends BaseTest {

    void login() {
        driver.get(baseUrl + "login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login("cust@gmail.com", "1");
    }

    @Test
    void TC_BIKE_01(){

        login();

        driver.get(baseUrl + "customer-bikes");

        BikePage bike = new BikePage(driver);

        assertTrue(bike.bikesVisible());

    }

    @Test
    void TC_BIKE_02(){

        login();

        driver.get(baseUrl + "customer-bikes");

        assertTrue(driver.getPageSource().contains("Bike"));

    }

    @Test
    void TC_BIKE_03(){

        login();

        driver.get(baseUrl + "customer-bikes");

        BikePage bike = new BikePage(driver);

        bike.rentFirstBike();

        assertTrue(driver.getPageSource().contains("Rent"));

    }

    @Test
    void TC_BIKE_04(){

        login();

        driver.get(baseUrl + "customer-bikes");

        assertTrue(
                driver.findElements(By.className("bike-card")).size() > 0
        );

    }

    @Test
    void TC_BIKE_05(){

        login();

        driver.get(baseUrl + "customer-bikes");

        assertTrue(driver.getTitle().contains("Bike"));

    }

}