import pytest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions


def create_driver(browser):
    if browser == "chrome":
        options = ChromeOptions()
        options.add_argument("--headless=new")
        return webdriver.Chrome(options=options)

    elif browser == "firefox":
        options = FirefoxOptions()
        options.add_argument("--headless=new")
        return webdriver.Firefox(options=options)

    else:
        raise ValueError(f"Unknown browser: {browser}")


@pytest.fixture(params=["chrome", "firefox"])
def driver(request):
    browser = request.param
    driver = create_driver(browser)

    yield driver

    driver.quit()
