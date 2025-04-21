*** Settings ***
Variables      ../../fixtures/environments.yaml
Resource    ../pages/login_variables.robot

Library    RequestsLibrary

*** Keywords ***
Criar sessao
    [Documentation]    Keyword para criação de sessão inicial pra usar nas próximas requests
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    alias=quality-eagles    url=${LOGIN.url}    headers=${headers}    verify=true

 Realizar login com token admin
    [Documentation]    Keyword para realizar login com token de administrador
    [Arguments]    ${email}    ${senha}    ${expectedStatus}
    ${body}    Create Dictionary    mail=${email}    password=${senha}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    url=${LOGIN.endpoint}    expected_status=${expectedStatus}    json=${body}
    ${token}    Set Variable    ${response.json()["token"]}    # Primeiro define a variável local
    Set Global Variable    ${TOKEN_ADMIN}    ${token}    # Depois define como global
    RETURN    ${response}
    
Realizar login com token user
    [Documentation]    Keyword para realizar login com token de usuário
    [Arguments]    ${email}    ${senha}    ${expectedStatus}
    ${body}    Create Dictionary    mail=${email}    password=${senha}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    url=${LOGIN.endpoint}    expected_status=${expectedStatus}     json=${body}
    ${token}    Set Variable    ${response.json()["token"]}    # Primeiro define a variável local
    Set Global Variable    ${TOKEN_USER}    ${token}    # Depois define como global
    RETURN    ${response}
Realizar login sem inclusão de token
    [Documentation]    Keyword para tentativa de realizar login sem informar o token
    [Arguments]    ${email}    ${senha}    ${expectedStatus}
    ${body}    Create Dictionary    mail=${email}    password=${senha}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    url=${LOGIN.endpoint}    expected_status=${expectedStatus}    json=${body}
    RETURN    ${response}

Criar headers com token
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    [Return]    ${headers}