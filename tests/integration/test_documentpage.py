import pytest
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


def test_back_to_results(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/document/s1229l11157?return_to=/?page%3D1")

    # Act
    back_to_results_btn = driver.find_element(By.NAME, "document-back-link")

    back_to_results_btn.click()

    homepage_header = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "home-page-header"))
    )

    # Assert
    assert "Copyright Documents from Early Hollywood" in homepage_header.text


def test_open_flag_document(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/document/s1229l11157?return_to=/?page%3D1")

    # Act
    flag_docs_btn = driver.find_element(By.NAME, "document-flag-toggle-btn")

    flag_docs_btn.click()

    flag_close_btn = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "document-flag-close-btn"))
    )

    # Assert
    assert "Close" in flag_close_btn.text


def test_year_metadata_search(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/document/s1229l11157?return_to=/")

    # Act
    year = driver.find_element(By.ID, "metadata-year")

    year.click()

    year_min = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "year-min"))
    )

    year_max = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "year-max"))
    )

    # Assert
    assert "1917" in year_min.text
    assert "1917" in year_max.text


def test_reels_metadata_search(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/document/s1229l17130?return_to=/")

    # Act
    reels = driver.find_element(By.ID, "metadata-reels")

    reels.click()

    reels_min = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "search-reel-min-input"))
    )

    reels_max = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "search-reel-max-input"))
    )

    # Assert
    assert reels_min.get_attribute("value") == "6"
    assert reels_max.get_attribute("value") == "6"


def test_copyright_year_metadata_search(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/document/s1229l17130?return_to=/")

    # Act
    copyright_year = driver.find_element(By.ID, "copyright-year")

    copyright_year.click()

    copyright_year_min = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "year-min"))
    )

    copyright_year_max = WebDriverWait(driver, 3).until(
        EC.presence_of_element_located((By.ID, "year-max"))
    )

    # Assert
    assert "1921" in copyright_year_min.text
    assert "1921" in copyright_year_max.text


@pytest.mark.skip(reason="Firefox does not like it")
def test_actor_name_metadata_search(driver):
    # Arrange
    driver.get("http://127.0.0.1:5000/document/s1229l17130?return_to=/")

    # Act
    actor_name = driver.find_element(By.CLASS_NAME, "actor_name_cell")

    actor_name.click()

    actor_name_year_min = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "year-min"))
    )

    actor_name_year_max = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "year-max"))
    )

    search_query = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "search-query-input"))
    )

    # Assert
    assert "1912" in actor_name_year_min.text
    assert "1928" in actor_name_year_max.text
    assert search_query.get_attribute("value") == '"James Smith"'
