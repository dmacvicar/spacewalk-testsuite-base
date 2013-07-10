/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.suse.manager.testsuite;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Duncan Mac-Vicar P. <dmacvicar@suse.de>
 */
class Page {
    protected WebDriver driver;
    
    public WebDriver getDriver() {
        return driver;
    }
    
    public Page(WebDriver driver) {
        this.driver = driver;
    }
    
    public void visit(String location) {
        this.driver.navigate().to(location);
    }
    
    //public WebElement findButton(String id) {
    //}
    
    public void close() {
        driver.close();
    }
}
