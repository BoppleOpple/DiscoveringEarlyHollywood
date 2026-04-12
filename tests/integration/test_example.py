from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


def test_view_history_without_login(driver):
    driver.get("http://127.0.0.1:5000/")

    view_history_button = driver.find_element(By.LINK_TEXT, "View History")

    driver.execute_script("arguments[0].click();", view_history_button)

    error_message = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "div.bg-red-100.text-red-800"))
    )

    assert "Log in to view your history." in error_message.text
