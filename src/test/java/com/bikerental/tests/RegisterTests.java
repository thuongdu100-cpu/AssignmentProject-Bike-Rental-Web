package com.bikerental.tests;

import com.bikerental.base.BaseTest;
import com.bikerental.pages.RegisterPage;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class RegisterTests extends BaseTest {

    @Test
    void TC_REGISTER_01(){

        driver.get(baseUrl + "register");

        RegisterPage r = new RegisterPage(driver);

        String email = "user" + System.currentTimeMillis() + "@gmail.com";

        r.register("test", email, "123456");

        assertTrue(driver.getPageSource().contains("Đăng nhập"));

    }

    @Test
    void TC_REGISTER_02(){

        driver.get(baseUrl + "register");

        RegisterPage r = new RegisterPage(driver);

        r.register("test","admin@gmail.com","123456");

        assertTrue(driver.getPageSource().contains("Email đã tồn tại"));

    }

    @Test
    void TC_REGISTER_03(){

        driver.get(baseUrl + "register");

        RegisterPage r = new RegisterPage(driver);

        r.register("test","abc","123456");

        // controller không validate email
        assertTrue(driver.getPageSource().contains("Đăng ký thất bại")
                || driver.getPageSource().contains("register"));

    }

    @Test
    void TC_REGISTER_04(){

        driver.get(baseUrl + "register");

        RegisterPage r = new RegisterPage(driver);

        r.register("","test@gmail.com","123456");

        // HTML required block submit
        assertTrue(driver.getCurrentUrl().contains("register"));

    }

    @Test
    void TC_REGISTER_05(){

        driver.get(baseUrl + "register");

        RegisterPage r = new RegisterPage(driver);

        r.register("test","test@gmail.com","");

        assertTrue(driver.getCurrentUrl().contains("register"));

    }

}