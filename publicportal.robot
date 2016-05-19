*** Settings ***
Library           String
Library           DateTime
Library           Collections
Library           Selenium2Library


*** Variables ***
${locator.title}                                                xpath=.//*[@class='tender--head--title col-sm-9']
${locator.enquiryPeriod.startDate}                              xpath=.//div[@class='col-sm-9 tender--customer--inner margin-bottom margin-bottom-more']//table[@class='tender--customer margin-bottom']//tr[1]/td[2]
${locator.enquiryPeriod.endDate}                                xpath=.//div[@class='col-sm-9 tender--customer--inner margin-bottom margin-bottom-more']//table[@class='tender--customer margin-bottom']//tr[2]/td[2]
${locator.tenderPeriod.startDate}                               xpath=.//div[@class='col-sm-9 tender--customer--inner margin-bottom margin-bottom-more']//table[@class='tender--customer margin-bottom']//tr[3]/td[2]
${locator.tenderPeriod.endDate}                                 xpath=        


*** Keywords ***
Підготувати клієнт для користувача
     [Arguments]  @{ARGUMENTS}
     [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
     Open Browser
     ...      ${USERS.users['${ARGUMENTS[0]}'].homepage}
     ...      ${USERS.users['${ARGUMENTS[0]}'].browser}
     ...      alias=${ARGUMENTS[0]}

     Set Window Size             @{USERS.users['${ARGUMENTS[0]}'].size}
     Set Window Position         @{USERS.users['${ARGUMENTS[0]}'].position}
     
     Wait Until Page Contains Element    name=tender-v2    20
     Click Element                       name=tender-v2


Пошук тендера по ідентифікатору
    [Arguments]         @{ARGUMENTS}
    [Documentation]    
    ...    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId


    Switch browser                       ${ARGUMENTS[0]}
    Go To                                ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Click Element                       name=tender-v2
    Wait Until Page Contains Element     xpath=.//*[@id='buttons']/button[4]      10
    Click Element                        xpath=.//*[@id='buttons']/button[4]
    Wait Until Page Contains Element     xpath=.//*[@id='blocks']/div/input       10
    Input Text                           xpath=.//*[@id='blocks']/div/input       ${ARGUMENTS[1]}
    Focus                                xpath=.//*[@id='blocks']/div/input
    Press Key                            xpath=.//*[@id='blocks']/div/input       \\32
    Wait Until Page Contains Element     xpath=.//*[@id='result']    20
    Click Element                        xpath=.//*[@id="result"]/div[2]//*[@class='cell']

Оновити сторінку з тендером
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} =  username
    ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
    Switch Browser                     ${ARGUMENTS[0]}
    publicportal.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
    Reload Page


Отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  Wait Until Page Contains Element    ${locator.${fieldname}}    1
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}



Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  Switch Browser   ${ARGUMENTS[0]}
  Run Keyword And Return  Отримати інформацію про ${ARGUMENTS[1]}


Отримати інформацію про title
  ${return_value}=   Отримати текст із поля і показати на сторінці   title
  [return]  ${return_value}



Отримати інформацію про tenderPeriod.startDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  tenderPeriod.startDate
  ${return_value}=    ${return_value}  4 
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  tenderPeriod.endDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.startDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати текст із поля і показати на сторінці  enquiryPeriod.endDate
  ${return_value}=   Change_date_to_month   ${return_value}
  [return]  ${return_value}

Change_date_to_month
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]}  ==  date
  ${day}=   Get Substring   ${ARGUMENTS[0]}   0   2
  ${month}=   Get Substring   ${ARGUMENTS[0]}  3   5
  ${year}=   Get Substring   ${ARGUMENTS[0]}   6    8
  ${return_value}=   Convert To String  ${month}${day}${year}
  [return]  ${return_value}



Отримати посилання на аукціон для глядача
    [Arguments]  @{ARGUMENTS}
    publicportal.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}   ${ARGUMENTS[1]}
    ${result} =    get text      xpath=.//*[@id='sticky-wrapper']//a[@target='_blank']
    [return]   ${result}