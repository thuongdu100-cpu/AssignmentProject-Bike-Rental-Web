package com.bikerental.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class LoginPage {

    WebDriver driver;

    public LoginPage(WebDriver driver){
        this.driver = driver;
    }

    By email = By.name("email");
    By password = By.name("password");
    By loginBtn = By.cssSelector("button[type='submit']");

    public void login(String e, String p){
        driver.findElement(email).sendKeys(e);
        driver.findElement(password).sendKeys(p);
        driver.findElement(loginBtn).click();
    }
}