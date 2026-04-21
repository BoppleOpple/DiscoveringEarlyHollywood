from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


def test_view_history_without_login(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/")

    # Act
    view_history_button = driver.find_element(By.NAME, "nav-view-history-link")

    driver.execute_script("arguments[0].click();", view_history_button)

    error_message = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "div.bg-red-100.text-red-800"))
    )

    # Assert
    assert "Log in to view your history." in error_message.text


def test_goto_flagged_documents_page(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/")

    # Act
    flagged_documents_button = driver.find_element(By.LINK_TEXT, "Flagged Documents")

    driver.execute_script("arguments[0].click();", flagged_documents_button)

    header = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.XPATH, "//*[text()='Flagged Documents']"))
    )

    # Assert
    assert "Flagged Documents" in header.text


def test_nav_next_page(driver):
    # Arrange
    driver.get("https://deh.boppleopple.net/")

    # Act
    next_page_button = driver.find_element(By.NAME, "search-next-page-link")

    driver.execute_script("arguments[0].click();", next_page_button)

    footer = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.XPATH, "//*[contains(text(), 'Page 2 of')]"))
    )

    # Assert
    assert "Page 2 of" in footer.text


def test_nav_previous_page(driver):
    # Arrange
    driver.get("https://deh.boppleopple.net/?page=2")

    # Act
    previous_page_button = driver.find_element(By.NAME, "search-previous-page-link")

    driver.execute_script("arguments[0].click();", previous_page_button)

    footer = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.XPATH, "//*[contains(text(), 'Page 1 of')]"))
    )

    # Assert
    assert "Page 1 of" in footer.text


def test_download_csv_too_large_query(driver):
    # Arrange
    driver.get("https://deh.boppleopple.net/")

    # Act
    download_csv_button = driver.find_element(By.LINK_TEXT, "Download as CSV")

    driver.execute_script("arguments[0].click();", download_csv_button)

    error_msg = WebDriverWait(driver, 5).until(
        EC.presence_of_element_located(
            (By.XPATH, "//*[contains(text(), 'Query is too large to download.')]")
        )
    )

    # Assert
    assert "Query is too large to download." in error_msg.text
