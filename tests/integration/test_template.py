# import pytest
# from selenium import webdriver
# from selenium.webdriver.common.by import By
# from selenium.webdriver.support.ui import WebDriverWait
# from selenium.webdriver.support import expected_conditions as EC
# from selenium.webdriver.chrome.options import Options


# @pytest.fixture
# def driver():
#     options = Options()
#     options.add_argument("--headless=new")

#     driver = webdriver.Chrome(options=options)
#     yield driver
#     driver.quit()


# def test_web_form(driver):
#     driver.get("https://www.selenium.dev/selenium/web/web-form.html")

#     text_box = driver.find_element(By.NAME, "my-text")
#     text_box.send_keys("Selenium")

#     submit_button = WebDriverWait(driver, 10).until(
#         EC.element_to_be_clickable((By.CSS_SELECTOR, "button"))
#     )

#     driver.execute_script(
#         """
#     arguments[0].scrollIntoView({block: 'center'});
#     """,
#         submit_button,
#     )

#     driver.execute_script("arguments[0].click();", submit_button)

#     message = driver.find_element(By.ID, "message")

#     assert "Received" in message.text
