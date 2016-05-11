*** Settings ***
Library           String
Library           DateTime
Library           Collections
Library           SeleniumLibrary
Library           dev_prozorro_service.py

*** Variables ***

*** Test Cases ***
Пошук тендера по ідентифікатору
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} ==  username
    ...      ${ARGUMENTS[1]} ==  tenderId
    Switch browser   ${ARGUMENTS[0]}

    Log To Console   __IN_TENDER_SEARCH__
    ${sync_res}=    trigger_search_sync_dev_prozorro
    Log To Console   ${sync_res}
    Log To Console   __WAIT_FOR_DB_SYNC__7_sec__
    Sleep   7

    Go To  ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Wait Until Page Contains Element    name=tender-v2    20
    Click Element    name=tender-v2
    Wait Until Page Contains Element    xpath=.//*[@id='buttons']/button[4]    10
    Click Element    xpath=.//*[@id='buttons']/button[4]
    Wait Until Page Contains Element    xpath=.//*[@id='blocks']/div/input    10
    Log To Console    __SEARCHING_ID_ON_PAGE__
    Log To Console    ${ARGUMENTS[1]}
    Input Text    xpath=.//*[@id='blocks']/div/input    ${ARGUMENTS[1]}
    Focus    xpath=.//*[@id='blocks']/div/input
    Press Key Native    39
    Wait Until Page Contains Element    xpath=.//*[@id='result']//*[@class='items-list--tem-id']    20
    Element Text Should Be    xpath=.//*[@id='result']//*[@class='items-list--tem-id']    ID: ${ARGUMENTS[1]}
    Отримати текст із поля і показати на сторінці    title
    Log To Console    __FOUND__
    Sleep    2
    Log To Console    __DONE__


Отримати текст із поля і показати на сторінці
  [Arguments]   ${fieldname}
  sleep  1
  ${return_value}=    Get Text  ${locator.${fieldname}}
  [return]  ${return_value}