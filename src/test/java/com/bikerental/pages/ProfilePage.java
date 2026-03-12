package com.bikerental.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class ProfilePage {
    WebDriver driver;
    By nameField = By.name("name");
    By saveButton = By.cssSelector("button");
    public ProfilePage(WebDriver driver){
        this.driver = driver;
    }
    public void updateName(String newName) {

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(5));

        WebElement name = wait.until(
                ExpectedConditions.visibilityOfElementLocated(By.id("fullName"))
        );

        name.clear();
        name.sendKeys(newName);

        WebElement btn = wait.until(
                ExpectedConditions.elementToBeClickable(
                        By.cssSelector("button.btn-primary")
                )
        );

        btn.click();
    }
}