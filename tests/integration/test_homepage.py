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
    driver.get("http://127.0.0.1:5000/")

    # Act
    next_page_button = WebDriverWait(driver, 3).until(
        EC.element_to_be_clickable((By.ID, "search-next-page-link"))
    )

    next_page_button.click()

    footer = WebDriverWait(driver, 3).until(
        EC.visibility_of_element_located((By.ID, "nav-page-num"))
    )

    # Assert
    assert "Page 2 of" in footer.text


def test_nav_previous_page(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/?page=2")

    # Act
    previous_page_button = WebDriverWait(driver, 3).until(
        EC.element_to_be_clickable((By.ID, "search-previous-page-link"))
    )

    previous_page_button.click()

    footer = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "nav-page-num"))
    )

    # Assert
    assert "Page 1 of" in footer.text
