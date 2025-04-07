*** Settings ***
Variables      ../../fixtures/environments.yaml
Resource    ../tests/login.robot
Resource    ../pages/user_variables.robot
Library    ../../libs/get_fake_user.py

*** Keywords ***
Criar usuário
    [Documentation]    Keyword para criar um usuário com dados aleatórios
    [Arguments]    ${person}    
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${body}        Create Dictionary
                    ...    fullName=${person}[name]
                    ...    mail=${person}[email]
                    ...    password=${person}[password]
                    ...    accessProfile=ADMIN
                    ...    cpf=${person}[cpf]
                    ...    confirmPassword=${person}[password]


    ${response}      POST On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER.url}${USER.endpoint}/?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    expected_status=201  

    RETURN           ${response}

Cadastro usuário com sucesso
    [Documentation]    Keyword para realizar cadastro de usuário
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${user}        Get Fake User
    ${idUser}       Criar Usuário     ${user}    

    RETURN           ${idUser}

Realizar login e cadastrar usuário retornando dados fake
    [Documentation]    Realiza o login como usuário e cadastra usuário
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}        Get Fake User
    ${responseUser}    Criar usuário    ${person}    
    [Return]     ${responseUser}    ${person} 
Cadastro manual de usuário
    [Documentation]    Keyword para criar um usuário com dados manuais
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

Listar usuário com sucesso
    [Documentation]    Keyword para listar usuários com sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}   200
    ${responseUser}    GET On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/?token=${TOKEN_USER}
    [Return]    ${responseUser}
Listar usuário por id
    [Documentation]    Keyword para listar usuários por id
    ${response}      Cadastro usuário com sucesso
    ${userId}       Set Variable    ${response.json()["user"]["_id"]}
    ${responseUser}    GET On Session    alias=quality-eagles    url=${USER.url}${USER.endpoint}/${userId}/?token=${TOKEN_USER}
    RETURN         ${responseUser}    ${userId} 

Atualizar cadastro de usuário com sucesso
    [Documentation]    Keyword para atualizar um usuário 
    ${responseUser}    ${person}     Realizar login e cadastrar usuário retornando dados fake   
    ${userId}    Set Variable    ${responseUser.json()["user"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    fullName=${responseUser.json()["user"]["fullName"]}    mail=${person}[email]
    ${response}    PUT On Session    alias=quality-eagles    url=${USER.url}${USER.endpoint}/${user_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    [Return]    ${response}     ${person} 

Atualização manual de cadastro usuário
    [Documentation]    Keyword para atualizar um usuário com dados manuais
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
Atualizar status de usuário
    [Documentation]    Keyword para atualizar status de usuário
    [Arguments]   ${status}
    ${response}    Cadastro usuário com sucesso
    ${userId}       Set Variable    ${response.json()["user"]["_id"]}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
    ${body}        Create Dictionary    status=${status}
    ${responseCompany}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER_STATUS.url}${USER_STATUS.endpoint}/${userId}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    headers=${headers}
    RETURN         ${responseCompany.json()}



Atualizar senha de usuário
    [Documentation]    Keyword para atualizar senha de usuário
    ${responseRegister}      Cadastro usuário com sucesso
    ${userId}       Set Variable    ${responseRegister.json()["user"]["_id"]}
    ${person}        Get Fake User
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    password=${person}[password]   confirmPassword=${person}[password] 
    ${responseCompany}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD.url}${USER_PASSWORD.endpoint}/${userId}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    [Return]    ${responseCompany} 


Deletar usuário
    [Documentation]    Keyword para exclusão de usuário
    [Arguments]    ${userId}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${response}    DELETE On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER.url}${USER.endpoint}/${userId}?token=${TOKEN_USER}
                     ...    headers=${headers}

    RETURN         ${response.json()}
