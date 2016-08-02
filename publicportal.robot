*** Settings ***

Library  Selenium2Library
Library  String
Library  DateTime
Library  publicportal.py


*** Variables ***

${settings.global.timeout}  60
${locator.tender.number}        xpath=//button[text()='№ закупівлі']
${locator.tender.search}        xpath=//*[@id="blocks"]/div/input
${locator.tender.title.verification}    xpath=//*[@href="/tender/{}/"]
${locator.go.to.auction}                xpath=//*[@href="/tender/{}/"]
${locator.auction.get.link}             xpath=//i[contains(@class, 'sprite-hammer')]
${tender.value.amount}  xpath=//div[contains(@class,"items-list--item--price")]
${locator.title}        xpath=//a[contains(@class,"items-list--header")]/span
${locator.tender.description}  xpath=//h3[text()='Інформація про процедуру']
${locator.tenderPeriod.startDate}  xpath=//div[contains(@class, "items-list--item--date")]
${locator.tenderPeriod.endDate}  xpath=//strong[text()='Кінцевий строк подання тендерних пропозицій:']/../following-sibling::td[1]
${locator.minimalStep.amount}  xpath=//strong[text()='Розмір мінімального кроку пониження ціни:']/../following-sibling::td[1]

*** Keywords ***

Підготувати клієнт для користувача
  Set Global Variable  ${PUBLICPORTAL_MODIFICATION_DATE}  ${EMPTY}
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Create WebDriver  ${users.users['${username}'].browser}  alias=${username}
  Go To             ${users.users['${username}'].homepage}
  Set Window Size   @{users.users['${username}'].size}
  Set Window Position  @{users.users['${username}'].position}


Підготувати дані для оголошення тендера
    [Arguments]  ${username}  ${tender_data}  ${role_name}
    ${tender_data}=  adapt_procuringEntity  ${tender_data}
    [Return]  ${tender_data}


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Switch Browser  ${username}
  Go To  ${users.users['${username}'].homepage}
  Click Button  ${locator.tender.number}
  Input Text    ${locator.tender.search}  ${tender_uaid}
  ${xpath}=  insert_tender_id_into_xpath  ${locator.tender.title.verification}  ${tender_uaid}
  Wait Until Element Is Visible  ${xpath}  ${settings.global.timeout}


Оновити сторінку з тендером 
  [Arguments]  ${username}  ${tender_uaid} 
  publicportal.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid} 


Отримати інформацію із тендера
  [Arguments]  ${username}  ${tender_uaid}   ${fieldname}
  Switch browser  ${username}
  Execute Javascript    window.scroll(300, 300)
  ${return_value}=  Run Keyword  Отримати інформацію про ${fieldname}
  [Return]  ${return_value}


Отримати текст із поля і показати на сторінці
  [Arguments]  ${locator}
  Execute Javascript    window.scroll(300, 300)
  Wait Until Page Contains Element  ${locator}  ${settings.global.timeout}  error=No Such Element On Page
  ${return_value}=  Get Text  ${locator}
  [Return]  ${return_value}


Отримати інформацію про title
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.title}
  [Return]  ${return_value}


Отримати інформацію про description
  ${return_value}=   Отримати текст із поля і показати на сторінці   ${locator.tender.description}
  [Return]  ${return_value}

Отримати інформацію про tenderPeriod.startDate
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.tenderPeriod.startDate}
  ${return_value}=  parse_date_publicportal  ${return_value}
  [Return]  ${return_value}


Отримати інформацію про tenderPeriod.endDate
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.tenderPeriod.endDate}
  ${return_value}=  parse_date_publicportal  ${return_value}
  [Return]  ${return_value}


Отримати інформацію про value.amount
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${tender.value.amount}
  ${return_value}=  prune_amount  ${return_value}
  [Return]  ${return_value}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}  ${url}
  publicportal.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${xpath}=  insert_tender_id_into_xpath  ${locator.go.to.auction}  ${tender_uaid}
  Wait Until Element Is Visible  ${xpath}  ${settings.global.timeout}
  Click Element  ${xpath}
  Wait Until Page Contains Element  ${locator.auction.get.link}  ${settings.global.timeout}  error=No Such Element On Page
  ${proceed_url}=  Get Element Attribute  ${locator.auction.get.link}@href
  [Return]  ${proceed_url}


Отримати інформацію про minimalStep.amount
  ${return_value}=  Отримати текст із поля і показати на сторінці  ${locator.minimalStep.amount}
  ${return_value}=  Remove String  ${return_value}  грн.
  ${return_value}=  Convert To Number  ${return_value.replace(',', '.')[:5]}
  [Return]  ${return_value}
