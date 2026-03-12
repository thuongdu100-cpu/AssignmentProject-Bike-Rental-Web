package com.bikerental.tests;

import com.bikerental.base.BaseTest;
import org.junit.jupiter.api.Test;
import com.bikerental.pages.LoginPage;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class LoginTests extends BaseTest {

    @Test
    void TC_LOGIN_01(){

        driver.get(baseUrl+"login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login("admin@gmail.com","1");

        assertTrue(driver.getCurrentUrl().contains("dashboard"));

    }

    @Test
    void TC_LOGIN_02(){

        driver.get(baseUrl+"login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login("admin@gmail.com","wrong");

        assertTrue(driver.getPageSource().contains("error"));

    }

    @Test
    void TC_LOGIN_03(){

        driver.get(baseUrl+"login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login("abc@gmail.com","123456");

        assertTrue(driver.getPageSource().contains("Email hoặc mật khẩu không đúng"));

    }

    @Test
    void TC_LOGIN_04(){

        driver.get(baseUrl+"login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login("","123456");

        assertTrue(driver.getCurrentUrl().contains("login"));

    }

    @Test
    void TC_LOGIN_05(){

        driver.get(baseUrl+"login.jsp");

        LoginPage login = new LoginPage(driver);
        login.login("admin@gmail.com","");

        assertTrue(driver.getCurrentUrl().contains("login"));

    }

}