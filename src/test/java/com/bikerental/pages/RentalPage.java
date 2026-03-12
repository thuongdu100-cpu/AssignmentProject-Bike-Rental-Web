package com.bikerental.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import java.util.List;

public class RentalPage {
    WebDriver driver;
    By rentalRows = By.cssSelector("table tbody tr");
    By returnButton = By.cssSelector("a.btn-danger");
    public RentalPage(WebDriver driver){
        this.driver = driver;
    }
    public boolean rentalListVisible(){
        List<WebElement> rows = driver.findElements(rentalRows);
        return driver.getPageSource().contains("Xe")
                || driver.getPageSource().contains("Bạn chưa có lịch sử");
    }
    public boolean bikeVisible(){
        return driver.getPageSource().contains("Đang thuê")
                || driver.getPageSource().contains("Hoàn thành");
    }
    public void returnBike(){
        List<WebElement> buttons = driver.findElements(returnButton);
        if(buttons.size() > 0){
            buttons.get(0).click();
        }

    }
}