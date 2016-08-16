*** Settings ***

Library  Selenium2Library
Library  String
Library  DateTime
Library  publicportal.py


*** Variables ***

${settings.global.timeout}  30
${locator.tender.number}        xpath=//button[text()="№ закупівлі"]
${locator.tender.search}        xpath=//*[@id="blocks"]/div/input
${locator.go.to.tender}         xpath=//a[@class="items-list--header"]/span
${locator.tender.id.search}     xpath=//*[@href="/tender/{}/"]
${locator.get.tender.ID}        xpath=//div[@class="tender--head--inf"]
${locator.tender.title}         xpath=//a[@class="items-list--header"]
${locator.tender.description}   xpath=//div[@class="tender--description--text description open"]
${locator.lot.title}            xpath=//div[@class="tender--description--text description open"]

${locator.tender.procuringEntity.name}      xpath=//strong[text()="Найменування замовника:"]/../following-sibling::td[1]
${locator.tender.value.amount}              xpath=//div[contains(@class,"green tender--description--cost--number")]/strong
${tender.value.currency}                    xpath=//div[contains(@class,"green tender--description--cost--number")]/strong/span
${locator.minimalStep.amount}               xpath=//strong[text()='Розмір мінімального кроку пониження ціни:']/../following-sibling::td[1]
${locator.tender.valueAddedTaxIncluded}     xpath=//strong[text()='Очікувана вартість:']/../following-sibling::td[1]

${locator.tenderPeriod.endDate}             xpath=//strong[text()="Кінцевий строк подання тендерних пропозицій:"]/../following-sibling::td[1]
${locator.enquiryPeriod.endDate}            xpath=//strong[text()="Звернення за роз’ясненнями:"]/../following-sibling::td[1]

${locator.auction.get.link}                 xpath=//a[text()='Подати пропозицію']


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
  ${tender_data}=  adapt_tender_data  ${tender_data}
  [Return]  ${tender_data}


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Set Global Variable  ${xpath}  ${EMPTY}
  Switch Browser  ${username}
  Go To  ${users.users['${username}'].homepage}
  Click Button  ${locator.tender.number}
  Input Text    ${locator.tender.search}  ${tender_uaid}
  ${xpath}=  insert_tender_id_into_xpath  ${locator.tender.id.search}  ${tender_uaid}
  Wait Until Page Contains  ${tender_uaid}  ${settings.global.timeout}  error=NO TENDER ID ON THIS PAGE
  Sleep  5


Оновити сторінку з тендером 
  [Arguments]  ${username}  ${tender_uaid} 
  Switch Browser  ${username}
  publicportal.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid} 


Отримати інформацію із тендера
  [Arguments]  ${username}  ${tender_data}   ${fieldname}
  Switch browser  ${username}
  ${return_value}=  Run Keyword  Отримати інформацію про ${fieldname}
  [Return]  ${return_value}


Отримати текст із поля і показати на сторінці
  [Arguments]  ${locator}
  Wait Until Page Contains Element  ${locator}  ${settings.global.timeout}  error=No Such Element On Page
  ${return_value}=  Get Text  ${locator}
  [Return]  ${return_value}


Отримати інформацію про title
  Execute Javascript  window.scrollTo(0, 23)
  ${tender.title}=  Отримати текст із поля і показати на сторінці  ${locator.tender.title}
  [Return]  ${tender.title}


Отримати інформацію про tenderID
  ${tender.ID}=   Отримати текст із поля і показати на сторінці   ${locator.get.tender.ID}
  [Return]  ${tender.ID.split(' ')[0]}


Отримати інформацію про description
  Click Element  ${locator.go.to.tender}
  Execute Javascript    window.scrollTo(0, 1090)
  ${tender.description}=   Отримати текст із поля і показати на сторінці   ${locator.tender.description}
  [Return]  ${tender.description}


Отримати інформацію про tenderPeriod.startDate
  Execute Javascript  window.scrollTo(0, 890)
  ${tenderPeriod_startDate}=    Отримати текст із поля і показати на сторінці  ${locator.enquiryPeriod.endDate}
  ${tenderPeriod_startDate}=    parse_date_publicportal  ${tenderPeriod_startDate}
  [Return]  ${tenderPeriod_startDate}


Отримати інформацію про tenderPeriod.endDate
  Execute Javascript    window.scrollTo(0, 890)
  ${tenderPeriod_endDate}=  Отримати текст із поля і показати на сторінці  ${locator.tenderPeriod.endDate}
  [Return]  ${tenderPeriod_endDate}


Отримати інформацію про enquiryPeriod.startDate
  Execute Javascript    window.scrollTo(0, 890)
  ${enquiryPeriod_startDate}=   Отримати текст із поля і показати на сторінці   ${locator.enquiryPeriod.endDate}
  ${enquiryPeriod_startDate}=   parse_date_publicportal     ${enquiryPeriod_startDate}
  ${enquiryPeriod_startDate}=   subtract_from_time          ${enquiryPeriod_startDate}  20  0
  [Return]  ${enquiryPeriod_startDate}


Отримати інформацію про enquiryPeriod.endDate
  Execute Javascript    window.scrollTo(0, 890)
  ${enquiryPeriod_endDate}=   Отримати текст із поля і показати на сторінці  ${locator.enquiryPeriod.endDate}
  ${enquiryPeriod_endDate}=   parse_date_publicportal   ${enquiryPeriod_endDate}
  [Return]  ${enquiryPeriod_endDate}


Отримати інформацію про value.amount
  ${value.amount}=  Отримати текст із поля і показати на сторінці  ${locator.tender.value.amount}
  ${value.amount}=  get_only_numbers  ${value.amount}
  [Return]  ${value.amount}


Отримати інформацію про minimalStep.amount
  Execute Javascript    window.scrollTo(0, 890)
  ${minimalStep.amount}=  Отримати текст із поля і показати на сторінці  ${locator.minimalStep.amount}
  ${minimalStep.amount}=  get_only_numbers  ${minimalStep.amount}
  [Return]  ${minimalStep.amount}


Отримати інформацію про value.currency
  ${value.currency}=  Отримати текст із поля і показати на сторінці  ${tender.value.currency}
  [Return]  ${value.currency}


Отримати інформацію про value.valueAddedTaxIncluded
  Execute Javascript    window.scrollTo(0, 890)
  ${tax_included}=  Отримати текст із поля і показати на сторінці  ${locator.tender.valueAddedTaxIncluded}
  ${tax_included}=  Convert To Boolean   ${tax_included.split(' ')[:-1]}
  [Return]  ${tax_included}


Отримати інформацію про procuringEntity.name
  Execute Javascript    window.scrollTo(0, 400)
  Wait Until Page Contains Element  ${locator.tender.procuringEntity.name}  ${settings.global.timeout}  error=No Such Element On Page
  ${procuringEntity.name}=  Get Text  ${locator.tender.procuringEntity.name}
  [Return]  ${procuringEntity.name}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}  ${url}
  publicportal.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${xpath}=  insert_tender_id_into_xpath  ${locator.go.to.tender}  ${tender_uaid}
  Wait Until Element Is Visible  ${xpath}  ${settings.global.timeout}
  Click Element  ${xpath}
  Wait Until Page Contains Element  ${locator.auction.get.link}  ${settings.global.timeout}  error=No Such Element On Page
  ${proceed.url.auction}=  Get Element Attribute  ${locator.auction.get.link}@href
  [Return]  ${proceed.url.auction}


Отримати інформацію із предмету
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${fieldname}
  Pass Execution    | CAN'T FIND THIS INFO ON PublicPortal
