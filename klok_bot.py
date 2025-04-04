import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import undetected_chromedriver as uc  # Avoid bot detection

# Configure Chrome to mimic human behavior xgj
options = uc.ChromeOptions()
options.add_argument("--disable-blink-features=AutomationControlled")
options.add_argument("--start-maximized")
options.add_experimental_option("excludeSwitches", ["enable-automation"])

# Initialize undetected Chrome driver
driver = uc.Chrome(driver_executable_path=ChromeDriverManager().install(), options=options)


def google_login(email: str, password: str):
    driver.get("https://klokapp.ai/")

    # Click Google login button (adjust selector based on Klokapp's UI)
    google_btn = WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, "//button[contains(., 'Google')]"))
    )
    google_btn.click()

    # Switch to Google OAuth popup window
    time.sleep(2)
    windows = driver.window_handles
    driver.switch_to.window(windows[-1])

    # Enter email
    email_field = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "identifierId"))
    )
    email_field.send_keys(email)
    driver.find_element(By.ID, "identifierNext").click()

    # Enter password
    password_field = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.NAME, "password"))
    )
    password_field.send_keys(password)
    driver.find_element(By.ID, "passwordNext").click()

    # Switch back to main window
    driver.switch_to.window(windows[0])


def ask_question(question: str):
    # Find question input field (adjust selector)
    input_field = WebDriverWait(driver, 20).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "textarea, input[type='text']"))
    )
    input_field.send_keys(question)
    input_field.submit()

    # Wait for response (adjust selector)
    response = WebDriverWait(driver, 30).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, ".response-class, .message-content"))
    )
    return response.text


# Example usage
if __name__ == "__main__":
    try:
        google_login("akaliasaviour@gmail.com", "Daddy123@")
        time.sleep(5)  # Wait for Klokapp.ai to load
        answer = ask_question("What is the capital of France?")
        print(f"Answer: {answer}")
    finally:
        driver.quit()