from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service


def lambda_handler(event, context):
    options = Options()
    options.binary_location = "/opt/chrome-linux/chrome"
    options.add_argument("--headless")
    options.add_argument('--no-sandbox')
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")

    service = Service(executable_path="/opt/chromedriver")

    wb = webdriver.Chrome(service=service, options=options)
    wb.get("https://www.google.com/")
    title = wb.title
    print(title)

    return title
