*** Settings ***
Resource    ../keywords/login_resource.robot
Resource    ../pages/login_variables.robot
Resource    ../keywords/user_resource.robot
Resource    ../pages/user_variables.robot

Library    RequestsLibrary
Library    Collections

*** Test Cases ***
TC01 - Cadastro de usuário com sucesso
    [Documentation]    Realizar um cadastro de usuário com sucesso
    ${responseUser}    ${person}     Realizar login e cadastrar usuário retornando dados fake    

    Status Should Be  201

    #Validar campos
    ${userData}    Set Variable    ${responseUser.json()["user"]}
    Should Be True    isinstance(${userData}, dict)
    Dictionary Should Contain Item    ${userData}    fullName    ${person}[name]
    Dictionary Should Contain Item    ${userData}    mail    ${person}[email]
    Dictionary Should Contain Item    ${userData}    cpf    ${person}[cpf]

    Log To Console    Nome: ${userData["fullName"]}
    Log To Console    Email: ${userData["mail"]}

TC02 - Cadastrar usuário com nome com mais de 100 caracteres
    [Documentation]    Cadastrar usuário com nome com mais de 100 caracteres
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}        Get Fake User
    ${response}     Cadastro manual de usuário
    ...    fullName=${INVALID_FULLNAME}
    ...    mail=${person}[email]
    ...    cpf=${person}[cpf]
    ...    password=${person}[password]
    ...    confirmPassword=${person}[password]
    Status Should Be    400    
   # Should Be Equal    ${response.json()['error']}    O nome completo deve ter no máximo 100 caracteres.

TC03 - Cadastrar usuário com e-mail inválido
    [Documentation]    Cadastrar usuário com espaço entre o nome e sobrenome no e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}        Get Fake User
    ${response}     Cadastro manual de usuário
    ...    fullName=${person}[name]
    ...    mail=${INVALID_MAIL}
    ...    cpf=${person}[cpf]
    ...    password=${person}[password]
    ...    confirmPassword= ${person}[password]
    Status Should Be    400    ${response}
    Should Be Equal As Strings   ${response.json()["error"][1]}    O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com]. 

TC04- Cadastrar usuário com senha inválida
    [Documentation]    Cadastrar usuário com um e-mail inválido
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}        Get Fake User
    ${response}     Cadastro manual de usuário
    ...    fullName=${person}[name]
    ...    mail=${person}[email]
    ...    cpf=${person}[cpf]
    ...    password=${INVALID_PASSWORD}
    ...    confirmPassword= ${INVALID_PASSWORD}
    Status Should Be    400    ${response}
    Should Be Equal As Strings   ${response.json()["error"][2]}     Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.

TC05 - Cadastrar usuário com CPF em branco
    [Documentation]    Cadastrar usuário com o CPF em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}        Get Fake User
    ${response}     Cadastro manual de usuário
    ...    fullName=${person}[name]
    ...    mail=${person}[email]
    ...    cpf=${CPF_BLANK}
    ...    password=${person}[password]
    ...    confirmPassword= ${person}[password]
    Status Should Be    400    
    Should Be Equal As Strings   ${response.json()["error"][2]}    Deve preencher o CPF com 11 dígitos

TC06 - Exclusão de usuário com sucesso
    [Documentation]    Deletar um usuário existente
    ${response}    Cadastro usuário com sucesso        
    ${userId}       Set Variable    ${response.json()["user"]["_id"]}

    # Deletar usuário
    ${response}      Deletar usuário    ${userId}

    # Validações
    Status Should Be    200   
    Should Be Equal    ${response["msg"]}      Usuário deletado com sucesso!.

TC07 - Exclusão de usuário com id inválido
    [Documentation]     Validar acesso negado à exclusão de usuários informando um id inválido
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${response}=    DELETE On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${USER.url}${USER.endpoint}/${INVALID_USER_ID}
    ...  expected_status=any
    Status Should Be    400    ${response}
    Should Be Equal As Strings   ${response.json()["alert"][0]}    Esse usuário não existe em nossa base de dados.

TC08 - Exclusão de usuário com token em branco
    [Documentation]     Validar acesso negado à exclusão de usuários com token em branco
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${response}=    DELETE On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}
    ...  expected_status=any
    Status Should Be    403     ${response}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC09 - Listagem de usuário com sucesso
    [Documentation]    Listar todos os usuários cadastrados
    ${response}    Listar usuário com sucesso
    Status Should Be    200   

   # Validar estrutura da resposta
    ${userData}    Set Variable    ${response.json()}
    Should Be True    isinstance(${userData}, list)
    Should Not Be Empty    ${userData}

    # Validar primeiro usuário da lista
    ${firstUser}    Set Variable    ${userData[0]}

    # Validar campos obrigatórios
    Dictionary Should Contain Key    ${firstUser}    fullName
    Dictionary Should Contain Key    ${firstUser}    mail
    Dictionary Should Contain Key    ${firstUser}    password
    Dictionary Should Contain Key    ${firstUser}    accessProfile
    Dictionary Should Contain Key    ${firstUser}    cpf

TC10 - Listagem de usuário com token inválido
    [Documentation]     Validar acesso negado à listagem de usuários com token inválido
    ${headers}    Criar headers com token    ${TOKEN_INVALID}
    ${response}=    GET On Session
    ...    alias=quality-eagles 
    ...     headers=${headers}
    ...    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}
    ...    expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC11 - Listagem de usuário com token em branco
    [Documentation]     Validar acesso negado à listagem de usuários com token em branco
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${response}=   GET On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}
    ...  expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC12- Listagem de usuário por id com sucesso
    [Documentation]    Realizar a busca de um usuário pelo seu id
    ${response}    ${userId}      Listar usuário por id   

    Should Be Equal As Strings    ${response.status_code}    200

    ${userList}    Set Variable    ${response.json()}
    Should Be True    isinstance(${userList}, dict)
    Dictionary Should Contain Key    ${userList}    fullName
    Dictionary Should Contain Key    ${userList}    mail
    Dictionary Should Contain Key    ${userList}    cpf

TC13- Listagem de usuário por id com id inválido
    [Documentation]     Validar acesso negado à listagem de usuários por id com um id inválido
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${response}=    GET On Session 
    ...    alias=quality-eagles 
    ...    headers=${headers}
    ...    url=/${USER.url}${USER.endpoint}/${INVALID_USER_ID}
    ...  expected_status=any
    Status Should Be    404
    Should Be Equal As Strings   ${response.json()["alert"][0]}    Esse usuário não existe em nossa base de dados.

TC14- Listagem de usuário por id com token em branco
    [Documentation]     Validar acesso negado à listagem de usuários por id com o token em branco
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${response}=    GET On Session
    ...    alias=quality-eagles 
    ...    headers=${headers}
    ...    url=/${USER.url}${USER.endpoint}/${VALID_USER_ID}
    ...  expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
   
TC15 - Contagem de usuário com sucesso
    [Documentation]    Realizar a contagem de todos os usuários cadastrados
    ${response}   Contagem de usuário com sucesso    
    Status Should Be    200    ${response}
    # Validar conteúdo da resposta
    Dictionary Should Contain Key   ${response.json()}    count

TC16 - Contagem de usuários com o token inválido
    [Documentation]     Validar acesso negado à contagem usuários com o token inválido
    ${headers}    Criar headers com token    ${TOKEN_INVALID}
    ${response}=    GET On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${USER_COUNT.url}${USER_COUNT.endpoint}
    ...    expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
   

TC17 - Contagem de usuário token em branco
    [Documentation]     Validar acesso negado à contagem usuários com o token em branco
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${response}=    GET On Session
    ...    alias=quality-eagles 
    ...    headers=${headers}
    ...    url=/${USER_COUNT.url}${USER_COUNT.endpoint}
    ...  expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC18 - Atualização de cadastro com sucesso
    [Documentation]    Atualizar dados básicos do usuário - e-mail
    ${response}     ${person}    Atualizar cadastro de usuário com sucesso
   
    Status Should Be    200
    Should Be Equal    ${response.json()["msg"]}    Dados atualizados com sucesso!

   # Validar campos atualizados
    ${updatedUser}    Set Variable    ${response.json()["updatedUser"]}
    Dictionary Should Contain Key    ${updatedUser}    mail
    Should Be Equal    ${updatedUser["mail"]}   ${person}[email]

    Log To Console   Email: ${person}[email]
    Log To Console    Novo email: ${updated_user["mail"]}
   

TC19 - Atualização de cadastro sem nome completo - somente primeiro nome
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar nome completo
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}    Get Fake User
    ${response}     Atualização manual de cadastro usuário
    ...    fullName=${INCOMPLETE_NAME}
    ...    mail=${person}[email]
    Status Should Be    400   
    Should Be Equal    ${response.json()["error"][0]}    Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.

TC20 - Atualização de cadastro com nome completo em branco
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar nome completo
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}    Get Fake User
    ${response}     Atualização manual de cadastro usuário
    ...    fullName=
    ...    mail=${person}[email]
    Status Should Be    400   
    Should Be Equal    ${response.json()["error"][0]}    Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.
TC21 - Atualização de cadastro sem email
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar o e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}    Get Fake User
    ${response}     Atualização manual de cadastro usuário
    ...    fullName=${person}[name]
    ...    mail=
    Status Should Be    400    
    Should Be Equal    ${response.json()["error"][1]}    O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].

TC22 - Atualização de cadastro com e-mail inválido
    [Documentation]     Validar acesso negado à atualização de cadastro sem informar o e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}    Get Fake User
    ${response}     Atualização manual de cadastro usuário
    ...    fullName=${person}[name]
    ...    mail=${INVALID_MAIL}
    Status Should Be    400    
    Should Be Equal    ${response.json()["error"][1]}    O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].

TC23 - Atualização de senha por id com sucesso
    [Documentation]    Atualizar senha do usuário utilizando seu id
    ${person}    Get Fake User
    ${response}   Atualizar senha de usuário    
    Status Should Be    200
    Should Be Equal    ${response.json()["msg"]}    Senha atualizada com sucesso!
    
    Log To Console    ${person}[password] 
    
TC24 - Atualização de senha por id com senha inválida
    [Documentation]    Atualizar senha do usuário utilizando seu id informando uma senha inválida
    ${response}   Atualizar senha de usuário manual    ${INVALID_PASSWORD} 
    Status Should Be    400
    Should Be Equal    ${response.json()["error"][0]}    Invalid value
    
    
TC25 - Atualização de senha por id com id inválido
    [Documentation]     Validar acesso negado à atualização de senha com id inválido
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}        Get Fake User
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${body}    Create Dictionary    password=${person}[password]    confirmPassword=${person}[password] 
    ${response}    PUT On Session 
    ...    alias=quality-eagles  
    ...      headers=${headers}
    ...    url=/${USER_PASSWORD.url}${USER_PASSWORD.endpoint}/${INVALID_USER_ID}
    ...    expected_status=any   
    Status Should Be    400
    Should Be Equal    ${response.json()["msg"]}    Esse usuário não existe em nossa base de dados.

TC26 - Atualização de senha por id com token em branco
    [Documentation]     Validar acesso negado à atualização de senha informando um token em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${person}        Get Fake User
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${body}    Create Dictionary    password=${person}[password]    confirmPassword=${person}[password] 
    ${response}    PUT On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${USER_PASSWORD.url}${USER_PASSWORD.endpoint}/${VALID_USER_ID}
    ...    expected_status=any   
    Status Should Be    403
    Should Be Equal    ${response.json()["errors"][0]}    Failed to authenticate token.

TC27 -Atualização de status por id para false com sucesso
    [Documentation]    Atualizar o status para false utilizando o id do usuário
    ${response}      Atualizar status de usuário    status=false
    Status Should Be    200
    Should Be Equal    ${response['msg']}    Status do usuario atualizado com sucesso para status false.
TC28 - Atualização de status por id para true com sucesso
    [Documentation]    Atualizar o status para true utilizando o id do usuário
    ${response}      Atualizar status de usuário       status=true
    Status Should Be    200
    Should Be Equal    ${response['msg']}    Status do usuario atualizado com sucesso para status true.

TC29 - Atualização de status por id com id inválido
    [Documentation]     Validar acesso negado à atualizção de status com ID inválido
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${USER_STATUS.url}${USER_STATUS.endpoint}/${INVALID_USER_ID}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    Status Should Be     404
   
TC30 - Atualização de status por id com token em branco
    [Documentation]     Validar acesso negado à atualização de status com o token em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${USER_STATUS.url}${USER_STATUS.endpoint}/${VALID_USER_ID}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    Status Should Be     403
    Should Be Equal    ${response.json()['errors'][0]}    Failed to authenticate token.




