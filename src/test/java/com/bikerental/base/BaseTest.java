package com.bikerental.base;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import io.github.bonigarcia.wdm.WebDriverManager;
public class BaseTest {

    protected WebDriver driver;

    protected String baseUrl =
            "http://localhost:8080/BikeRental/";

    @BeforeEach
    void setup(){

        WebDriverManager.chromedriver().setup();

        driver = new ChromeDriver();

        driver.manage().window().maximize();
    }

    @AfterEach
    void tearDown(){

        if(driver != null){
            driver.quit();
        }

    }
}