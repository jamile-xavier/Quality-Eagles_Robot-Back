*** Settings ***
Variables      ../../fixtures/environments.yaml
Resource    ../pages/login_variables.robot

Library    RequestsLibrary

*** Keywords ***
Criar sessao
    [Documentation]    Criação de sessão inicial pra usar nas próximas requests
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    alias=quality-eagles    url=${LOGIN.url}    headers=${headers}    verify=true

 Realizar login com token admin
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}    ${expected_status}
    ${body}    Create Dictionary    mail=${email}    password=${senha}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    url=${LOGIN.endpoint}    expected_status=${expected_status}    json=${body}
    ${token}    Set Variable    ${response.json()["token"]}    # Primeiro define a variável local
    Set Global Variable    ${TOKEN_ADMIN}    ${token}    # Depois define como global
    RETURN    ${response}
    
Realizar login com token user
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}    ${expected_status}
    ${body}    Create Dictionary    mail=${email}    password=${senha}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    url=${LOGIN.endpoint}    expected_status=${expected_status}    json=${body}
    ${token}    Set Variable    ${response.json()["token"]}    # Primeiro define a variável local
    Set Global Variable    ${TOKEN_USER}    ${token}    # Depois define como global
    RETURN    ${response}
Realizar login sem inclusão de token
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}    ${expected_status}
    ${body}    Create Dictionary    mail=${email}    password=${senha}
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    url=${LOGIN.endpoint}    expected_status=${expected_status}    json=${body}
    RETURN    ${response}

