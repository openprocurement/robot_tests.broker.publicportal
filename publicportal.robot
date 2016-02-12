*** Settings ***


*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  [Documentation]  Відкрити браузер, створити об’єкт api wrapper, тощо
  Log  ${username}
  # Can't just put "Fail" here because that breaks the whole suite setup
  Log  ${username}: Keyword not implemented: Підготувати клієнт для користувача  WARN


Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Log Many  ${username}  ${tender_uaid}
  Fail  ${username}: Keyword not implemented: Пошук тендера по ідентифікатору


Отримати інформацію із тендера
  [Arguments]  ${username}  ${fieldname}
  Log Many  ${username}  ${fieldname}
  Fail  ${username}: Keyword not implemented: Отримати інформацію із тендера


Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}
  Log Many  ${username}  ${tender_uaid}
  Fail  ${username}: Keyword not implemented: Отримати посилання на аукціон для глядача
