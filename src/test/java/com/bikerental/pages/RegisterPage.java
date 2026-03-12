package com.bikerental.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class RegisterPage {
    WebDriver driver;
    By nameField = By.name("fullName");
    By emailField = By.name("email");
    By passwordField = By.name("password");
    By registerBtn = By.cssSelector("button[type='submit']");
    public RegisterPage(WebDriver driver){
        this.driver = driver;
    }
    public void register(String name, String email, String password){

        driver.findElement(nameField).sendKeys(name);

        driver.findElement(emailField).sendKeys(email);

        driver.findElement(passwordField).sendKeys(password);

        driver.findElement(registerBtn).click();
    }
}