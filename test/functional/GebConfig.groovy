import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.firefox.FirefoxDriver
import org.openqa.selenium.firefox.FirefoxProfile
import org.openqa.selenium.remote.DesiredCapabilities

driver = {
    def driverInstance = new ChromeDriver()
    driverInstance.manage().window().maximize()
    driverInstance
}

environments {
    // when system property 'geb.env' is set to 'travis', use a remote Firefox driver
    travis {
        driver = {
            //set the firefox locale to 'en-us' since the tests expect english
            //see http://stackoverflow.com/questions/9822717 for more details
            FirefoxProfile profile = new FirefoxProfile()
            profile.setPreference("intl.accept_languages", "en-us")
            DesiredCapabilities capabilities = DesiredCapabilities.firefox()
            capabilities.setCapability("marionette", true)
            capabilities.setCapability("firefox_profile", profile)

            def driverInstance = new FirefoxDriver(capabilities)
            driverInstance.manage().window().maximize()
            driverInstance
        }
    }
}

baseNavigatorWaiting = true
atCheckWaiting = true
