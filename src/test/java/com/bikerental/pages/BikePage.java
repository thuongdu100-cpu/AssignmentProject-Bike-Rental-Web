package com.bikerental.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import java.util.List;

public class BikePage {
    WebDriver driver;
    By bikeCards = By.cssSelector(".bike-card");
    By rentButtons = By.cssSelector("a.btn-rent");

    public BikePage(WebDriver driver){
        this.driver = driver;
    }
    public boolean bikesVisible(){
        return driver.findElements(bikeCards).size() > 0;
    }
    public void rentFirstBike() {

        List<WebElement> buttons = driver.findElements(rentButtons);

        if (buttons.size() > 0) {

            buttons.get(0).click();

            try {
                Thread.sleep(2000);
            } catch (Exception e) {
            }
        }
    }
}