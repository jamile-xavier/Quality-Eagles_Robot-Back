*** Settings ***
Variables      ../../fixtures/environments.yaml
Resource    ../tests/login.robot
Resource    ../pages/user_variables.robot
Library    ../../libs/get_fake_user.py

*** Keywords ***
Criar usuario
    [Documentation]    Criar um usuário com dados aleatórios
    [Arguments]    ${person}    ${token}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${body}        Create Dictionary
                    ...    fullName=${person}[name]
                    ...    mail=${person}[email]
                    ...    password=B6Dc#4d@SM6U
                    ...    accessProfile=ADMIN
                    ...    cpf=${person}[cpf]
                    ...    confirmPassword=B6Dc#4d@SM6U


    ${response}      POST On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER.url}${USER.endpoint}/?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    expected_status=201  

    RETURN           ${response}

Cadastro usuário com sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${user}        Get Fake User
    ${id_user}       Criar Usuario     ${user}    ${TOKEN_USER}

    RETURN           ${id_user}
Cadastro manual de usuario
    [Documentation]    Criar um usuário com dados manuais
    [Arguments]    ${name}    ${mail}    ${cpf}    ${password}    ${confirmPassword}
    ${body}        Create Dictionary
                    ...    fullName= ${name}
                    ...    mail= ${mail}
                    ...    accessProfile=ADMIN
                    ...    cpf= ${cpf}
                    ...    password=${password}
                    ...    confirmPassword=${confirmPassword}



    ${response}      POST On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER.url}${USER.endpoint}/?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    expected_status=400

    RETURN           ${response}

Atualização manual de cadastro usuario
    [Documentation]    Criar um usuário com dados manuais
    [Arguments]    ${name}    ${mail}   
    ${body}        Create Dictionary
                    ...    fullName= ${name}
                    ...    mail= ${mail}

    ${response}      PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    expected_status=400

    RETURN           ${response}    

Listar usuario por id
    [Arguments]    ${id}
    ${url}         Set Variable    /${USER.url}${USER.endpoint}/${id}/?token=${TOKEN_USER}
    ${response}    GET On Session    alias=quality-eagles    url=${url}
    RETURN         ${response}

Atualizar status de usuario
    [Arguments]    ${user_id}    ${status}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
    ${body}        Create Dictionary    status=${status}
    ${response}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER_STATUS.url}${USER_STATUS.endpoint}/${user_id}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    headers=${headers}
    RETURN         ${response.json()}

Atualizar senha de usuario
    [Arguments]    ${user_id}    ${password}    ${confirmPassword}
    ${body}    Create Dictionary    password=${password}    confirmPassword=${confirmPassword}
    ${headers}    Create Dictionary
    ...    accept=application/json
    ...    Content-Type=application/json

    ${response}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD.url}${USER_PASSWORD.endpoint}${user_id}?token=${TOKEN_USER}   json=${body}    headers=${headers}


Deletar usuario
    [Arguments]    ${user_id}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${response}    DELETE On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER.url}${USER.endpoint}/${user_id}?token=${TOKEN_USER}
                     ...    headers=${headers}

    RETURN         ${response.json()}
