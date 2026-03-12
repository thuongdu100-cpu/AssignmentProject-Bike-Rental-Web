package com.bikerental.tests;

import com.bikerental.base.BaseTest;
import com.bikerental.pages.LoginPage;
import com.bikerental.pages.ProfilePage;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class ProfileTests extends BaseTest {

    void login(String email,String pass){

        driver.get(baseUrl + "login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login(email,pass);

    }

    @Test
    void TC_PROFILE_ADMIN_VIEW(){

        login("admin@gmail.com","1");

        driver.get(baseUrl + "profile");

        assertTrue(driver.getPageSource().toLowerCase().contains("email"));

    }

    @Test
    void TC_PROFILE_CUSTOMER_VIEW(){

        login("cust@gmail.com","1");

        driver.get(baseUrl + "profile");

        assertTrue(driver.getPageSource().toLowerCase().contains("email"));

    }

    @Test
    void TC_PROFILE_STAFF_VIEW(){

        login("staff@gmail.com","1");

        driver.get(baseUrl + "profile");

        assertTrue(driver.getPageSource().toLowerCase().contains("email"));

    }

    @Test
    void TC_PROFILE_UPDATE(){

        login("admin@gmail.com","1");

        driver.get(baseUrl + "profile");

        ProfilePage p = new ProfilePage(driver);

        p.updateName("Admin02");

        assertTrue(driver.getPageSource().contains("Cập nhật thông tin thành công"));

    }

    @Test
    void TC_PROFILE_LOGOUT(){

        login("admin@gmail.com","1");

        driver.get(baseUrl + "logout");

        assertTrue(driver.getCurrentUrl().contains("login"));

    }

}