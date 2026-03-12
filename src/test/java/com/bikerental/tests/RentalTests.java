package com.bikerental.tests;

import com.bikerental.base.BaseTest;
import org.junit.jupiter.api.Test;
import com.bikerental.pages.LoginPage;
import com.bikerental.pages.BikePage;
import com.bikerental.pages.RentalPage;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class RentalTests extends BaseTest {

    void login(){

        driver.get(baseUrl+"login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login("cust@gmail.com","1");
        try{
            Thread.sleep(1500);
        }catch(Exception e){}
    }
    @Test
    void TC_RENT_01(){

        login();

        driver.get(baseUrl+"customer-bikes");
        BikePage bike = new BikePage(driver);
        bike.rentFirstBike();

        try{
            Thread.sleep(2000);
        }catch(Exception e){}

        RentalPage rental = new RentalPage(driver);

        assertTrue(rental.rentalListVisible());
    }

    @Test
    void TC_RENT_02(){

        driver.get(baseUrl+"customer-bikes");

        assertTrue(
                driver.getCurrentUrl().contains("login") ||
                        driver.getPageSource().contains("Đăng nhập")
        );

    }

    @Test
    void TC_RENT_03(){

        login();

        driver.get(baseUrl + "rental?action=list");

        assertTrue(driver.getPageSource().contains("Xe"));
    }

    @Test
    void TC_RENT_04(){

        login();
        driver.get(baseUrl + "rental?action=list");

        assertTrue(driver.getPageSource().contains("Thời gian"));

    }

    @Test
    void TC_RENT_05(){

        login();

        driver.get(baseUrl + "rental?action=list");

        assertTrue(driver.getTitle().contains("Lịch sử thuê xe"));

    }


}