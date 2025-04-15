*** Settings ***
Variables      ../../fixtures/environments.yaml
Resource    ../keywords/login_resource.robot
Resource    ../pages/login_variables.robot

Library    RequestsLibrary
Library    Collections


*** Test Cases ***

TC01 - Realizar login com sucesso Admin
    [Documentation]    Realizar login de Admin com sucesso
    ${response}    Realizar login com token admin  email=${MAIL_ADMIN}    senha=${PASSWORD_ADMIN}   expectedStatus=200
    Set Global Variable    ${TOKEN_ADMIN}    ${response.json()["token"]}

    Should Be Equal As Strings    ${MAIL_ADMIN}    ${response.json()["user"]["mail"]}
    Should Be Equal As Strings    Olá Qa-Coders-SYSADMIN, autenticação autorizada com sucesso!    ${response.json()["msg"]}

    Should Not Be Empty     ${response.json()["token"]}

TC02 - Realizar login com sucesso User
    [Documentation]    Realizar login de usuário com sucesso
    ${response}    Realizar login com token user   email=${MAIL_USER}    senha=${PASSWORD_USER}    expectedStatus=200
   
    Should Be Equal As Strings    ${MAIL_USER}    ${response.json()["user"]["mail"]}
    Should Not Be Empty     ${response.json()["token"]}

TC03 - Realizar login com senha inválida
    [Documentation]    Realizar login com a senha inválida e o e-mail válido
    ${response}     Realizar login sem inclusão de token   email=${MAIL_ADMIN}    senha=1234@Tes    expectedStatus=400
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC04 - Realizar login com email inválido
    [Documentation]    Realizar login com o e-mail inválido e a senha válida
    ${response}     Realizar login sem inclusão de token   email=sysadmin@qacoders.com.br    senha=${PASSWORD_ADMIN}    expectedStatus=400
    Status Should Be    400   ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC05 - Realizar login com email e senha inválidos
    [Documentation]    Realizar login com e-mail e senha inválidos
    ${response}     Realizar login sem inclusão de token   email=sysadmin@qacoders.com.br    senha=1234@Tes    expectedStatus=400
    Status Should Be    400    ${response}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${response.json()["alert"]}

TC06 - Realizar login com e-mail em branco
    [Documentation]    Realizar login com o e-mail em branco e a senha válida
    ${response}     Realizar login sem inclusão de token    email=       senha=${PASSWORD_ADMIN}    expectedStatus=400
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo e-mail é obrigatório.    second=${response.json()["mail"]}

TC07 - Realizar login com a senha em branco
    [Documentation]    Realizar login com o e-mail válido e a senha em branco
    ${response}     Realizar login sem inclusão de token   email=${MAIL_ADMIN}    senha=    expectedStatus=400
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo senha é obrigatório.    second=${response.json()["password"]}

TC08 - Realizar login com e-mail e senha em branco
    [Documentation]    Realizar login com o e-mail e a senha em branco
    ${response}     Realizar login sem inclusão de token   email=       senha=    expectedStatus=400
    Status Should Be    400    ${response}
    Should Be Equal    first=O campo e-mail é obrigatório.    second=${response.json()["mail"]}
    Should Be Equal    first=O campo senha é obrigatório.    second=${response.json()["password"]}




