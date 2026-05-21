import pytest
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


def login(driver):
    driver.get("http://127.0.0.1:5000/")

    login_btn = driver.find_element(By.ID, "nav-login-btn")

    login_btn.click()

    user_name = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "login-name"))
    )

    user_name.send_keys("TestRunner")

    password = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "login-password"))
    )

    password.send_keys("TestRunner1!")

    login_submit = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "login-submit-btn"))
    )

    login_submit.click()


def test_flag_doc_without_login(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/document/s1229l11157?return_to=/")

    # Act
    flag_btn = driver.find_element(By.ID, "document-flag-toggle-btn")

    flag_btn.click()

    error_loc = driver.find_element(By.ID, "error_location")

    error_loc.send_keys("Page Test")

    error_desc = driver.find_element(By.ID, "error_description")

    error_desc.send_keys("Test Description, disregard")

    submit_flag_btn = driver.find_element(By.ID, "document-flag-submit-btn")

    submit_flag_btn.click()

    flag_msg = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "base-flash-message"))
    )

    # Assert
    assert flag_msg.text == "Log in to flag documents for review."


@pytest.mark.skip(reason="Login does not work correctly")
def test_flag_doc_with_login(driver):
    # Arrange
    login(driver)
    driver.get("http://127.0.0.1:5000/document/s1229l11157?return_to=/")

    # Act
    flag_btn = WebDriverWait(driver, 5).until(
        EC.presence_of_element_located((By.ID, "document-flag-toggle-btn"))
    )

    flag_btn.click()

    error_loc = driver.find_element(By.ID, "error_location")

    error_loc.send_keys("Page Test")

    error_desc = driver.find_element(By.ID, "error_description")

    error_desc.send_keys("Test Description, disregard")

    submit_flag_btn = driver.find_element(By.ID, "document-flag-submit-btn")

    submit_flag_btn.click()

    flag_msg = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "base-flash-message"))
    )

    # Assert
    assert flag_msg.text == "Document flagged for review."
