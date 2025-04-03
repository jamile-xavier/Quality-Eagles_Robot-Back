*** Settings ***
Resource    ../keywords/login_resource.robot
Resource    ../pages/login_variables.robot
Resource    ../keywords/user_resource.robot
Resource    ../pages/user_variables.robot

*** Test Cases ***
TC01 - Cadastro de usuário com sucesso
    [Documentation]    Realizar um cadastro de usuário com sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${person}        Get Fake User
    ${response}      Criar usuario    ${person}    ${TOKEN_USER}

    Should Be Equal As Strings    ${response.status_code}    201

    #Validar campos
    ${user_data}    Set Variable    ${response.json()["user"]}
    Should Be True    isinstance(${user_data}, dict)
    Dictionary Should Contain Item    ${user_data}    fullName    ${person}[name]
    Dictionary Should Contain Item    ${user_data}    mail    ${person}[email]
    Dictionary Should Contain Item    ${user_data}    cpf    ${person}[cpf]

    Log To Console    Nome: ${user_data["fullName"]}
    Log To Console    Email: ${user_data["mail"]}

TC02 - Cadastrar usuário com nome com mais de 100 caracteres
    [Documentation]    Cadastrar usuário com nome com mais de 100 caracteres
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira Valo Velho Barro Preto Botafogo Santana Padre Clemente Henrique Moussier Uruguai Teresina Robert Spengler Neto
    ...    mail=isabelaoliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=78599154719
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}

TC03 - Cadastrar usuário com espaço no e-mail
    [Documentation]    Cadastrar usuário com espaço entre o nome e sobrenome no e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira 
    ...    mail=isabela oliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=78599154719
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}
    Should Be Equal As Strings   ${response.json()["error"][1]}    O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com]. 

TC04- Cadastrar usuário com senha inválida
    [Documentation]    Cadastrar usuário com um e-mail inválido
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira
    ...    mail=isabela oliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=78599154719
    ...    password=5qLPT6vpPfj
    ...    confirmPassword= 5qLPT6vpPfj
    Status Should Be    400    ${response}

TC05 - Cadastrar usuário com e-mail inválido
    [Documentation]    Cadastrar usuário com um e-mail inválido
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira
    ...    mail=isabelaoliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders
    ...    cpf=78599154719
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}
    Should Be Equal As Strings   ${response.json()["error"][1]}    O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com]. 


TC06 - Cadastrar usuário com CPF em branco
    [Documentation]    Cadastrar usuário com o CPF em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}     Cadastro manual de usuario
    ...    fullName=Isabella Oliveira
    ...    mail=isabela oliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    ...    cpf=
    ...    password=5qLPT$6vpPfj
    ...    confirmPassword= 5qLPT$6vpPfj
    Status Should Be    400    ${response}
    Should Be Equal As Strings   ${response.json()["error"][2]}    Deve preencher o CPF com 11 dígitos

TC07 - Exclusão de usuário com sucesso
    [Documentation]    Deletar um usuário existente
    ${response}    Cadastro usuário com sucesso        
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}

    # Deletar usuário
    ${response}      Deletar usuario    ${user_id}

    # Validações
    Status Should Be    200   
    Should Be Equal    Usuário deletado com sucesso!.    ${response["msg"]}  

TC08 - Exclusão de usuário com id inválido
    [Documentation]     Validar acesso negado à exclusão de usuários informando um id inválido
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/${INVALID_USER_ID}?token=${TOKEN_USER}   expected_status=any
    Status Should Be    400    ${response}
    Should Be Equal As Strings   ${response.json()["alert"][0]}    Esse usuário não existe em nossa base de dados.

TC09 - Exclusão de usuário com token em branco
    [Documentation]     Validar acesso negado à exclusão de usuários com token em branco
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403     ${response}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC10 - Listagem de usuário com sucesso
    [Documentation]    Listar todos os usuários cadastrados
    ${response}    GET On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}

   # Validar estrutura da resposta
    ${user_data}    Set Variable    ${response.json()}
    Should Be True    isinstance(${user_data}, list)
    Should Not Be Empty    ${user_data}

    # Validar primeiro usuário da lista
    ${first_user}    Set Variable    ${user_data[0]}

    # Validar campos obrigatórios
    Dictionary Should Contain Key    ${first_user}    fullName
    Dictionary Should Contain Key    ${first_user}    mail
    Dictionary Should Contain Key    ${first_user}    password
    Dictionary Should Contain Key    ${first_user}    accessProfile
    Dictionary Should Contain Key    ${first_user}    cpf

TC11 - Listagem de usuário com token inválido
    [Documentation]     Validar acesso negado à listagem de usuários com token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC12 - Listagem de usuário com token em branco
    [Documentation]     Validar acesso negado à listagem de usuários com token em branco
    ${response}=   GET On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}?token=${TOKEN_BLANK}    expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC13- Listagem de usuário por id com sucesso
    [Documentation]    Realizar a busca de um usuário pelo seu id

    ${response}      Cadastro usuário com sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${response}      Listar usuario por id    ${user_id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${user_list}    Set Variable    ${response.json()}
    Should Be True    isinstance(${user_list}, dict)
    Dictionary Should Contain Key    ${user_list}    fullName
    Dictionary Should Contain Key    ${user_list}    mail
    Dictionary Should Contain Key    ${user_list}    cpf

TC14- Listagem de usuário por id com id inválido
    [Documentation]     Validar acesso negado à listagem de usuários por id com um id inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/${INVALID_USER_ID}?token=${TOKEN_USER}   expected_status=any
    Status Should Be    404
    Should Be Equal As Strings   ${response.json()["alert"][0]}    Esse usuário não existe em nossa base de dados.

TC15- Listagem de usuário por id com token em branco
    [Documentation]     Validar acesso negado à listagem de usuários por id com o token em branco
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
   
TC16 - Contagem de usuário com sucesso
    [Documentation]    Realizar a contagem de todos os usuários cadastrados
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}    GET On Session    alias=quality-eagles    url=/${USER_COUNT.url}${USER_COUNT.endpoint}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}
    # Validar conteúdo da resposta
    Dictionary Should Contain Key   ${response.json()}    count

TC17 - Contagem de usuários com o token inválido
    [Documentation]     Validar acesso negado à contagem usuários com o token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER_COUNT.url}${USER_COUNT.endpoint}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
   

TC18 - Contagem de usuário token em branco
    [Documentation]     Validar acesso negado à contagem usuários com o token em branco
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER_COUNT.url}${USER_COUNT.endpoint}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC19 - Atualização de cadastro com sucesso
    [Documentation]    Atualizar dados básicos do usuário - e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${person}    Get Fake User
    ${response}    Cadastro usuário com sucesso
    ${user_id}    Set Variable    ${response.json()["user"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    fullName=${response.json()["user"]["fullName"]}    mail=${person}[email]
    ${response}    PUT On Session    alias=quality-eagles    url=${USER.url}${USER.endpoint}/${user_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    #Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal    ${response.json()["msg"]}    Dados atualizados com sucesso!

   # Validar campos atualizados
    ${updated_user}    Set Variable    ${response.json()["updatedUser"]}
    Dictionary Should Contain Key    ${updated_user}    mail
    Should Be Equal    ${updated_user["mail"]}   ${person}[email]

    Log To Console   Email: ${person}[email]
    Log To Console    Novo email: ${updated_user["mail"]}
   

TC20 - Atualização de cadastro sem nome completo
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar nome completo
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}     Atualização manual de cadastro usuario
    ...    fullName=Isabella 
    ...    mail=isabelaoliveira_0037fbf4-241a-4852-bdf1-19723cb0aab3@qacoders.com.br
    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()["error"][0]}    Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.

TC21 - Atualização de cadastro sem email
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar o e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}     Atualização manual de cadastro usuario
    ...    fullName=Isabella Oliveira
    ...    mail=
    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()["error"][1]}    O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].

TC22 - Atualização de senha por id com sucesso
    [Documentation]    Atualizar senha do usuário utilizando seu id
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${person}        Get Fake User
    ${response}      Cadastro usuário com sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    password=9qJNsMDL75#A    confirmPassword=9qJNsMDL75#A
    ${response}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD.url}${USER_PASSWORD.endpoint}/${user_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    Status Should Be    200
    Should Be Equal    ${response.json()["msg"]}    Senha atualizada com sucesso!

TC23 - Atualização de senha por id com id inválido
    [Documentation]     Validar acesso negado à atualização de senha com id inválido
    ${body}    Create Dictionary    password=9qJNsMDL75#A    confirmPassword=9qJNsMDL75#A
    ${response}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD.url}${USER_PASSWORD.endpoint}/${INVALID_USER_ID}?token=${TOKEN_USER}    expected_status=any   
    Status Should Be    400
    Should Be Equal    ${response.json()["msg"]}    Esse usuário não existe em nossa base de dados.

TC24 - Atualização de senha por id com token em branco
    [Documentation]     Validar acesso negado à atualização de senha informando um token em branco
    ${body}    Create Dictionary    password=9qJNsMDL75#A    confirmPassword=9qJNsMDL75#A
    ${response}    PUT On Session    alias=quality-eagles    url=/${USER_PASSWORD.url}${USER_PASSWORD.endpoint}/${VALID_USER_ID}?token=${TOKEN_BLANK}    expected_status=any   
    Status Should Be    403
    Should Be Equal    ${response.json()["errors"][0]}    Failed to authenticate token.

TC25 -Atualização de status por id para false com sucesso
    [Documentation]    Atualizar o status para false utilizando o id do usuário
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${person}        Get Fake User
    ${response}      Cadastro usuário com sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${resposta}      Atualizar status de usuario    user_id=${user_id}    status=false
    Status Should Be    200
    Should Be Equal    ${resposta['msg']}    Status do usuario atualizado com sucesso para status false.

TC34 - Atualização de status por id para true com sucesso
    [Documentation]    Atualizar o status para true utilizando o id do usuário
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${person}        Get Fake User
    ${response}      Cadastro usuário com sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    ${response}      Atualizar status de usuario    user_id=${user_id}    status=true
    Status Should Be    200
    Should Be Equal    ${response['msg']}    Status do usuario atualizado com sucesso para status true.

TC35 - Atualização de status por id com id inválido
    [Documentation]     Validar acesso negado à atualizção de status com ID inválido
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${USER_STATUS.url}${USER_STATUS.endpoint}/${INVALID_USER_ID}?token=${TOKEN_USER}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    Status Should Be     404
   
TC36 - Atualização de status por id com token em branco
    [Documentation]     Validar acesso negado à atualização de status com o token em branco
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${USER_STATUS.url}${USER_STATUS.endpoint}/${VALID_USER_ID}?token=${TOKEN_BLANK}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    Status Should Be     403
    Should Be Equal    ${response.json()['errors'][0]}    Failed to authenticate token.




