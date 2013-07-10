package com.suse.manager.testsuite;

import cucumber.api.PendingException;
import cucumber.api.Scenario;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;

import cucumber.api.java.*;
import cucumber.api.java.en.*;

import static org.junit.Assert.assertEquals;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.firefox.FirefoxDriver;

public class WebStepsDefs {
    
    protected Page page;
    
    @Before
    public void setUp() {
        this.page = new Page(new FirefoxDriver());
    }

    @Given("^I am not authorized$")
    public void I_am_not_authorized() throws Throwable {
        page.visit("http://manager.suse.de");        
        // Express the Regexp above with the code you wish you had
        throw new PendingException();
    }

    @When("^I go to the home page$")
        public void I_go_to_the_home_page() throws Throwable {
        // Express the Regexp above with the code you wish you had
        throw new PendingException();
    }

    @When("^I enter \"([^\"]*)\" as \"([^\"]*)\"$")
    public void I_enter_as(String arg1, String arg2) throws Throwable {
        // Express the Regexp above with the code you wish you had
        throw new PendingException();
    }

    @When("^I click on \"([^\"]*)\"$")
    public void I_click_on(String arg1) throws Throwable {
        // Express the Regexp above with the code you wish you had
        throw new PendingException();
    }

    @Then("^I should be logged in$")
    public void I_should_be_logged_in() throws Throwable {
        // Express the Regexp above with the code you wish you had
        throw new PendingException();
    }

    @Given("^I am authorized$")
    public void I_am_authorized() throws Throwable {
        // Express the Regexp above with the code you wish you had
        throw new PendingException();
    }

    @After
    public void tearDown() {
        page.close();
    }
    
    @After  
     public void embedScreenshot(Scenario scenario) {  
         if (scenario.isFailed()) {  
             try {  
                 byte[] screenshot = ((TakesScreenshot) page.getDriver()).getScreenshotAs(OutputType.BYTES);  
                 scenario.embed(screenshot, "image/png");  
             } catch (WebDriverException wde) {  
                 System.err.println(wde.getMessage());  
             } catch (ClassCastException cce) {  
                 cce.printStackTrace();  
             }  
         }  
     }  
}