*** Settings ***
Library    String


***Variables***
${locator.tenderId}                     xpath=//li[contains(., 'Номер тендеру:')]
${locator.title}                        xpath=//div[contains(@class, "tender--head--title col-sm-9")]
${locator.description}                  xpath=//div[contains(@class, "tender--description--text description open")]
${locator.value.amount}                 xpath=//li[contains(., 'Бюджет:')]
${locator.procuringEntity.name}         xpath=//div[contains(@class, "tender--head--company")]
${locator.tenderPeriod.startDate}       xpath=//li[contains(., 'Період уточнень:')]
${locator.tenderPeriod.endDate}         xpath=//li[contains(., 'Подання пропозицій:')]
${locator.enquiryPeriod.startDate}      xpath=/html/body/div[2]/div/div[2]/div/div/div/div[3]/div[2]/div/ul/li[1]
${locator.enquiryPeriod.endDate}        xpath=/html/body/div[2]/div/div[2]/div/div/div/div[3]/div[2]/div/ul/li[2]
${locator.minimalStep.amount}           xpath=//li[contains(., 'Мінімальний крок:')]

${timeout_short}     5

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Open Browser  ${USERS.users['${username}'].homepage}    ${USERS.users['${username}'].browser}
  # in Suite Setup there are already whole preparation.
 
Пошук тендера по ідентифікатору
  [Arguments]    ${username}    ${tender_uaid}
  Wait Until Page Contains Element    name=sandbox     ${timeout_short}
  Click Button    name=sandbox
  sleep  ${timeout_short}
  Click Button    № закупівлі
  Input Text    //*[@id="blocks"]/div/input    ${tender_uaid}
  Sleep   ${timeout_short}
  Wait Until Page Contains    ${tender_uaid}   10
  Capture Page Screenshot
  Click Link    /tender/${tender_uaid}/
  Capture Page Screenshot

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[1]}


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}
  Log Many  ${username}  ${tender_uaid}
  #ail  ${username}: Keyword not implemented: Отримати посилання на аукціон для глядача
  ${url}=  Викликати для учасника  ${username}  Отримати посилання на аукціон для глядача  ${tender_uaid}
  Log  URL аукціону для глядача: ${url}



#=================
Отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  3
#  відмітити на сторінці поле з тендера   ${fieldname}   ${locator.${fieldname}}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}
Отримати інформацію про title
  ${return_value}=   Отримати текст із поля і показати на сторінці   title
  [return]  ${return_value}

Отримати інформацію про description
  ${return_value}=   Отримати текст із поля і показати на сторінці   description
  [return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати текст із поля і показати на сторінці   minimalStep.amount
  ${return_value}    Fetch from Right    ${return_value}    \n
  ${return_value}=   Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

Отримати інформацію про value.amount
  ${return_value}=   Отримати текст із поля і показати на сторінці  value.amount
  #${return_value}=   Evaluate   "".join("${return_value}".split(' ')[:-3])
  ${return_value}    Fetch from Right    ${return_value}    \n
  ${return_value}    Fetch from Left    ${return_value}    UAH
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

Відмітити на сторінці поле з тендера
  [Arguments]   ${fieldname}  ${locator}
  ${last_note_id}=  Add pointy note   ${locator}   Found ${fieldname}   width=200  position=bottom
  Align elements horizontally    ${locator}   ${last_note_id}
  sleep  1
  Remove element   ${last_note_id}

Отримати інформацію про tenderId
  ${return_value}=   Отримати текст із поля і показати на сторінці   tenderId
  ${return_value}=   Get Substring  ${return_value}   10
  ${return_value}=   Fetch from Right    ${return_value}    \n
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати текст із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  tenderPeriod.startDate
  ${return_value}=   Fetch from Right    ${return_value}    до${SPACE}
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  tenderPeriod.endDate
  ${return_value}=   Fetch from Right    ${return_value}    до${SPACE}
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  Log To Console    This keyword WILL fail because actually on UI such data is not displayed for this platform.
  ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.startDate
  ${return_value}=   Fetch from Right    ${return_value}    до${SPACE}
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.startDate
  ${return_value}=   Fetch from Right    ${return_value}    до${SPACE}
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Change_date_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   6
  ${year}=   Get Substring   ${ARGUMENTS[0]}   5
  ${return_value}=   Convert To String  ${month}${day}${year}
  [return]  ${return_value}

Оновити сторінку з тендером
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  Go To    ${USERS.users['${ARGUMENTS[0]}'].homepage}search/?tid=${ARGUMENTS[1]}
  Reload Page

  # ==================================================================
Отримати інформацію про items[0].description
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].deliveryLocation.latitude
  ${return_value}=   Get Substring  ${return_value}   0   10
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].deliveryLocation.longitude
  ${return_value}=   Get Substring  ${return_value}   12   22
  [return]  ${return_value}

Отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].unit.code
  ${return_value}=   Get Substring  ${return_value}   5
  Run Keyword And Return If  '${return_value}' == 'кг.'   Convert To String  KGM
  [return]  ${return_value}

Отримати інформацію про items[0].quantity
  ${return_value}=   Отримати текст із поля і показати на сторінці   items[0].quantity
  ${return_value}=   Get Substring  ${return_value}   0   4
  ${return_value}=   Convert To Number   ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.scheme
  ${return_value}=   Get Substring  ${return_value}   0   -1
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].classification.description
  ${return_value}=   Get Substring  ${return_value}   11
  Run Keyword And Return If  '${return_value}' == 'Картонки'   Convert To String  Cartons
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].id
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].additionalClassifications[0].scheme
  ${return_value}=   Отримати текст із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  ${return_value}=   Get Substring  ${return_value}   0   -1
  [return]  ${return_value.split(' ')[1]}

Отримати інформацію про items[0].additionalClassifications[0].description
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].additionalClassifications[0].description
  ${return_value}=  Split String  ${return_value}  separator=${SPACE}  max_split=1
  [return]  ${return_value[1]}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  Run Keyword And Return  Get Substring  ${return_value}  0  5

Отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.countryName
  Run Keyword And Return  Get Substring  ${return_value}  0  7

Отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.region
  Run Keyword And Return  Remove String  ${return_value}  ,

Отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.locality
  Run Keyword And Return  Remove String  ${return_value}  ,

Отримати інформацію про items[0].deliveryAddress.streetAddress
  Run Keyword And Return  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.streetAddress

Отримати інформацію про items[0].deliveryDate.endDate
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryDate.endDate
  ${time}=  Отримати текст із поля і показати на сторінці  enquiryPeriod.startDate
  ${time}=  Get Substring  ${time}  11
  ${day}=  Get Substring  ${return_value}  16  18
  ${month}=  Get Substring  ${return_value}  18  22
  ${year}=  Get Substring  ${return_value}  22
  Run Keyword And Return  Convert To String  ${year}${month}${day}${time}

Отримати інформацію про questions[0].title
  Run Keyword And Return  Отримати текст із поля і показати на сторінці  questions[0].title

Отримати інформацію про questions[0].description
  Run Keyword And Return  Отримати текст із поля і показати на сторінці  questions[0].description

Отримати інформацію про questions[0].date
  ${return_value}=  Отримати текст із поля і показати на сторінці  questions[0].date
  Run Keyword And Return  Change_date_to_month  ${return_value}

Отримати інформацію про questions[0].answer
  Run Keyword And Return  Отримати текст із поля і показати на сторінці  questions[0].answer
