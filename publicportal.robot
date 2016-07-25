*** Settings ***

sLibrary  Selenium2Library
Library  String
Library  DateTime
Library  publicportal.py


*** Variables ***

${settings.global.timeout}  10
${locator.image.verification}     xpath=/html/body/div/nav[2]/div/div[1]/a[1]/img
${locator.tender.number}        xpath=//*[@id="buttons"]/button[4]
${locator.tender.search}        xpath=//*[@id="blocks"]/div/input
${locator.tenderID.text.verification}   xpath=//*[@id="result"]/div[1]/div/div[1]/div/div/text()
${locator.tender.title.verification}    xpath=//*[@href="/tender/{}/"]
${locator.go.to.auction}                xpath=//*[@href="/tender/{}/"]
${locator.auction.get.link}             xpath=//*[@id="sticky-wrapper"]/div/div/a
# Button  ${locator.auction.get.link} doesn't appear with tender e.g. UA-2016-07-20-000247-1, but with e.g. UA-2016-07-21-000035-1 it's OK

${tender.value.amount}  xpath=//div[contains(@class, "items-list--item--price")]
${locator.title}        xpath=//a[contains(@class, "items-list--header")]/span
${locator.tender.description}  xpath=//div[contains(@class, "description")]/*/p
${locator.tenderPeriod.startDate}  xpath=//div[contains(@class, "items-list--item--date")]
${locator.tenderPeriod.endDate}    xpath=//table[contains(@class, "tender--customer")]/tbody/tr[2]/td[1]
${locator.minimalStep.amount}       xpath=//table[contains(@class, "tender--customer")]/tbody/tr[5]/td[2]

*** Keywords ***

Підготувати клієнт для користувача
  Set Global Variable  ${PUBLICPORTAL_MODIFICATION_DATE}  ${EMPTY}
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Create WebDriver  ${users.users['${username}'].browser}  alias=${username}
  Go To             ${users.users['${username}'].homepage}
  Set Window Size   @{users.users['${username}'].size}
  Set Window Position  @{users.users['${username}'].position}

#Basic Test: opens browser, goes to the home page, resizes the window (users.yaml)


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Reload Page
  Switch Browser  ${username}
  Go To  ${users.users['${username}'].homepage}
  Page Should Contain Image  ${locator.image.verification}
  Click Button  ${locator.tender.number}
  Input Text    ${locator.tender.search}  ${tender_uaid}
  Log  ${tender_uaid} <-- Current ID   WARN
  ${xpath}=  create_xpath  ${locator.tender.title.verification}  ${tender_uaid}
  Wait Until Element Is Visible  ${xpath}  ${settings.global.timeout}


Оновити сторінку з тендером 
  [Arguments]  ${username}  ${tender_uaid} 
  Reload Page
  Selenium2Library.Switch Browser  ${username}
  publicportal.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid} 
  Log  ${tender_uaid} <-- Current ID   WARN


Отримати інформацію із тендера
  [Arguments]  ${username}  ${tender_uaid}   ${fieldname}
  Switch browser  ${username}
  ${return_value_tender.info}=  Run Keyword  Отримати інформацію про ${fieldname}
  [return]  ${return_value_tender.info}


Отримати текст із поля і показати на сторінці
  [Arguments]  ${locator}
  Wait Until Page Contains Element  ${locator}  ${settings.global.timeout}
  ${return_value}=  Get Text  ${locator}
  [return]  ${return_value}


Отримати інформацію про title
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.title}
  [return]  ${return_value}


Отримати інформацію про description
  ${return_value}=   Отримати текст із поля і показати на сторінці   ${locator.tender.description}
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.startDate
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.tenderPeriod.startDate}
  ${return_value}=  Change_date_to_month  ${return_value}
  [return]  ${return_value}


Отримати інформацію про tenderPeriod.endDate
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.tenderPeriod.endDate}
  ${return_value}=  Change_date_to_month  ${return_value}
  [return]  ${return_value}


Отримати інформацію про value.amount
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${tender.value.amount}
  Log  ${return_value} <-- Amount from page   WARN
  ${return_value}=  prune_amount  ${return_value}
  Log  ${return_value} <-- Pruned by python   WARN
  ${return_value}=  Convert To Number  ${return_value}
  Log  ${return_value} <-- Converted by magic   WARN
  [return]  ${return_value}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}  ${url}
  #  Sleep   60
  Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Log  ${tender_uaid} <-- Current ID   WARN
  ${xpath}=  create_xpath  ${locator.go.to.auction}  ${tender_uaid}
  wait until element is visible  ${xpath}  ${settings.global.timeout}
  Click Element  ${xpath}
  wait until page contains element  ${locator.auction.get.link}  ${settings.global.timeout}
  ${proceed_url}=  Get Element Attribute  ${locator.auction.get.link}@href
  [return]  ${proceed_url}


Change_date_to_month
  [Arguments]  ${date}
  ${day}=  Get Substring  ${date}    0  2
  ${month}=  Get Substring  ${date}  3  6
  ${year}=  Get Substring  ${date}   5
  ${return_value}=  Convert To String  ${month}${day}${year}
  [return]  ${return_value}



################################   NOT IMPLEMENTED KEYWORDS   ##############################

Отримати інформацію із лоту
  [Arguments]  ${tender_uaid}  ${object_id}  ${url}  ${dynamicField}
  Fail  Not implemented: Отримати інформацію із лоту

Отримати інформацію про minimalStep.amount
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.minimalStep.amount}
  ${return_value}=  Remove String  ${return_value}  грн.
  ${return_value}=  Convert To Number  ${return_value.replace(',', '.')[:5]}
  [return]  ${return_value}

Отримати інформацію про value.currency
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.amount
  ${return_value}=   Convert To String     ${return_value.split(' ')[2]}
  ${return_value}=   convert_prom_string_to_common_string      ${return_value}
  [return]  ${return_value}
