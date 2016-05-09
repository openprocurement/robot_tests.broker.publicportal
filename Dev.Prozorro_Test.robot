*** Settings ***
Suite Setup       Begin Tests
Suite Teardown    End Tests
Library           BuiltIn
Library           SeleniumLibrary

*** Test Cases ***
Можливість знайти однопредметний тендер по ідентифікатору
    Page Should Contain Element    xpath=.//*[@id='result']
    Click Element    xpath=.//*[@id='result']//div[2]//span[@class='cell']

Відображення заголовку оголошеного тендера
    Page Should Contain Element    class=tender--head--title col-sm-9

Відображення початку періоду прийому пропозицій оголошеного тендера
    Page Should Contain Element    xpath=.//*[@class='tender--customer margin-bottom']//strong[text()='Початок подання тендерних пропозицій:']

Відображення закінчення періоду прийому пропозицій оголошеного тендера
    Page Should Contain Element    xpath=.//*[@class='tender--customer margin-bottom']//strong[text()='Кінцевий строк подання тендерних пропозицій:']

Можливість вичитати посилання на аукціон для глядача
    Page Should Contain Link    xpath=.//*[@id='sticky-wrapper']//a[@target='_blank']

*** Keywords ***
Begin Tests
    Start Selenium Server
    Open Browser    http://dev.prozorro.org/    googlechrome
    Set Selenium Speed    1 seconds
    Click Element    name=tender-v2
    Click Element    xpath=.//*[@id='buttons']/button[4]
    Input Text    xpath=.//*[@id='blocks']/div/input    UA-2016-05-08-000001-1
    Focus    xpath=.//*[@id='blocks']/div/input
    Press Key Native    39

End Tests
    Close All Browsers
    Stop Selenium Server
