*** Settings ***
Resource    ../keywords/login_resource.robot
Resource    ../pages/login_variables.robot
Resource    ../keywords/company_resource.robot
Resource    ../pages/company_variables.robot

##Importando as Bibliotecas
Library    RequestsLibrary
Library    ../../libs/get_fake_company.py
Library    Collections
Library    String

 
*** Test Cases ***
TC01 - Cadastrar empresa
    [Documentation]    Realizar o cadastro de uma empresa
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}       Criar Empresa     ${companyFake}    ${TOKEN_USER}
    Status Should Be    201    ${responseCompany}
    Log To Console     ${responseCompany.json()}
      
    ${companyData}    Set Variable    ${responseCompany.json()["newCompany"]}
    Should Be True    isinstance(${companyData}, dict)
    Dictionary Should Contain Item    ${companyData}    corporateName    ${companyFake}[corporateName]
    Dictionary Should Contain Item    ${companyData}    registerCompany    ${companyFake}[cnpj]
    Dictionary Should Contain Item    ${companyData}    mail    ${companyFake}[corporateEmail]
    
  
TC02 - Cadastrar empresa em duplicidade    
    [Documentation]     Validar acesso negado à cadastro de empresa em duplicidade
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${responseCompany}     Criar empresa manual     
    ...    corporateName=${CORPORATE_NAME_DUPLICATE}
    ...    registerCompany=${REGISTER_COMPANY_DUPLICATE}
    ...    mail=${MAIL_COMPANY_DUPLICATE}
    ...    responsibleContact=${RESPONSIBLE_CONTACT_DUPLICATE}
    ...    phone=${PHONE_COMPANY_DUPLICATE}
    ...    serviceDescription=${SERVICE_DESCRIPTION_DUPLICATE}
    ...    zipCode=${ZIP_CODE_COMPANY_DUPLICATE}
    ...    city=${CITY_COMPANY_DUPLICATE}
    ...    state=${STATE_COMPANY_DUPLICATE}
    ...    district=${DISTRICT_COMPANY_DUPLICATE}
    ...    street=${STREET_COMPANY_DUPLICATE}
    ...    number=${NUMBER_COMPANY_DUPLICATE}
    ...    token=${TOKEN_USER}
    
    Status Should Be    400    ${responseCompany}
    Should Be Equal    ${responseCompany.json()['alert'][0]}    Essa companhia já está cadastrada. Verifique o nome, CNPJ e a razão social da companhia.

TC03 - Cadastrar empresa sem nome da empresa
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o nome
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}     Criar empresa manual    ${TOKEN_USER}
    ...    corporateName= 
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=${MAIL_COMPANY}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    phone=${PHONE_COMPANY}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    zipCode=${ZIP_CODE_COMPANY}
    ...    city=${CITY_COMPANY}
    ...    state=${STATE_COMPANY}
    ...    district=${DISTRICT_COMPANY}
    ...    street=${STREET_COMPANY}
    ...    number=${NUMBER_COMPANY}
    ...    token=${TOKEN_USER}

    Status Should Be    400    ${responseCompany}
    Should Be Equal    ${responseCompany.json()['error'][0]}    O campo 'Nome da empresa' da empresa é obrigatório

TC04 - Cadastrar empresa sem o CNPJ
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o cnpj
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${response}     Criar empresa manual
    ...    corporateName=${CORPORATE_NAME}
    ...    registerCompany=
    ...    mail=${MAIL_COMPANY}
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    phone=${PHONE_COMPANY}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    zipCode=${ZIP_CODE_COMPANY}
    ...    city=${CITY_COMPANY}
    ...    state=${STATE_COMPANY}
    ...    district=${DISTRICT_COMPANY}
    ...    street=${STREET_COMPANY}
    ...    number=${NUMBER_COMPANY}
    ...    token=${TOKEN_USER}

    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()['error'][0]}    O campo 'CNPJ' da empresa é obrigatório.

TC05 - Cadastrar empresa sem email
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}     Criar empresa manual
    ...    corporateName=${CORPORATE_NAME}
    ...    registerCompany=${REGISTER_COMPANY}
    ...    mail=
    ...    responsibleContact=${RESPONSIBLE_CONTACT}
    ...    phone=${PHONE_COMPANY}
    ...    serviceDescription=${SERVICE_DESCRIPTION}
    ...    zipCode=${ZIP_CODE_COMPANY}
    ...    city=${CITY_COMPANY}
    ...    state=${STATE_COMPANY}
    ...    district=${DISTRICT_COMPANY}
    ...    street=${STREET_COMPANY}
    ...    number=${NUMBER_COMPANY}
    ...    token=${TOKEN_USER}

    Status Should Be    400    ${responseCompany}
    Should Be Equal    ${responseCompany.json()['error'][0]}    O campo 'Email' é obrigatório.

TC06 - Exclusão de empresa com sucesso
    [Documentation]    Deletar uma empresa existente
    ${response}    Cadastro Empresa Sucesso       
    ${companyId}       Set Variable    ${response.json()["newCompany"]["_id"]}

    # Deletar usuário
    ${response}      Deletar empresa    ${companyId}

    # Validações
    Status Should Be    200    
    Should Be Equal   Companhia deletado com sucesso.    ${response["msg"]}

TC07 - Exclusão de empresa com id inválido
    [Documentation]     Validar acesso negado à exclusão de empresa informando um id inválido
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${COMPANY}/${INVALID_COMPANY_ID}?token=${TOKEN_USER}   expected_status=any
    Status Should Be    404   ${response}
    #Should Be Equal As Strings   ${response.json()["msg"]}    Essa companhia não existem em nossa base de dados.

TC08 - Exclusão de empresa com token inválido
    [Documentation]     Validar acesso negado à exclusão de empresa informando um token inválido
    ${response}=    DELETE On Session    alias=quality-eagles    url=/${COMPANY}/${VALID_COMPANY_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC09 - Listagem de empresa com sucesso
    [Documentation]    Listar todas as empresas cadastradas
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}   200
    ${responseCompany}    GET On Session    alias=quality-eagles    url=/${COMPANY.url}${COMPANY.endpoint}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}

   # Validar estrutura da resposta
    Should Be True    isinstance(${responseCompany.json()}, list)
    Should Not Be Empty    ${responseCompany.json()}

    # Validar primeiro usuário da lista
    ${firstCompany}    Set Variable    ${responseCompany.json()[0]}

    # Validar campos obrigatórios
    Dictionary Should Contain Key    ${firstCompany}    corporateName
    Dictionary Should Contain Key    ${firstCompany}    registerCompany
    Dictionary Should Contain Key    ${firstCompany}    responsibleContact
    Dictionary Should Contain Key    ${firstCompany}    mail
    Dictionary Should Contain Key    ${firstCompany}    telephone

TC10 - Listagem de empresa com token inválido
    [Documentation]     Validar acesso negado à listagem de empresa por id com um token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${COMPANY}/${VALID_COMPANY_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC11 - Listagem de empresa com token em branco
    [Documentation]     Validar acesso negado à listagem de empresa por id com um token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${COMPANY}/${VALID_COMPANY_ID}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.    

TC12 - Contagem de empresa com sucesso
    [Documentation]    Realizar a contagem de todas as empresas cadastradas
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${responseCompany}    GET On Session    alias=quality-eagles    url=/${COMPANY_COUNT.url}${COMPANY_COUNT.endpoint}/?token=${TOKEN_USER}
    Status Should Be    200    ${response}
    # Validar conteúdo da resposta
    Dictionary Should Contain Key   ${responseCompany.json()}    count

TC13 - Contagem de empresa com token inválido
    [Documentation]     Validar acesso negado à contagem de empresa com o token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${COMPANY_COUNT}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC14 - Contagem de empresa com token em branco
    [Documentation]     Validar acesso negado à contagem usuários com o token inválido
    ${response}=    GET On Session    alias=quality-eagles    url=/${USER_COUNT}?token=${TOKEN_BLANK}   expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC15 - Atualização de cadastro da empresa por id com sucesso
    [Documentation]    Atualizar dados básicos da empresa - Responsável
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${company_fake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${companyId}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${body}    Create Dictionary    corporateName=${response.json()["newCompany"]["corporateName"]}    registerCompany=${response.json()["newCompany"]["registerCompany"]}     mail=${response.json()["newCompany"]["mail"]}     matriz=Teste    responsibleContact= Marcio Freitas    telephone=${response.json()["newCompany"]["telephone"]}    serviceDescription=Teste 
    ${response}    PUT On Session    alias=quality-eagles    url=/${COMPANY.url}${COMPANY.endpoint}/${company_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal    ${response.json()["msg"]}    Companhia atualizada com sucesso.
    # Validar campos atualizados
    ${updatedCompany}    Set Variable    ${response.json()["updatedCompany"]}
    Dictionary Should Contain Key    ${updatedCompany}    responsibleContact

    # Remover espaços extras e comparar
    ${expectedContact}    Strip String    Marcio Freitas
    ${actualContact}      Strip String    ${updatedCompany["responsibleContact"]}
    Should Be Equal    ${expectedContact}    ${actualContact}

    Log To Console    Responsável atualizado: ${updatedCompany["responsibleContact"]}
    Log To Console    Dados da empresa atualizada: ${response.json()}

TC16 - Atualização de cadastro da empresa por id com token inválido
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com um token inválido
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}=    PUT On Session    alias=quality-eagles    url=/${COMPANY.url}${COMPANY.endpoint}/${VALID_COMPANY_ID}?token=${TOKEN_INVALID}   expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
    

#TC17 - Atualização de cadastro da empresa por id com todos os campos em branco
#    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com todos os campos em branco
#    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
#    ${response}=    PUT On Session    alias=quality-eagles    url=/${COMPANY.url}${COMPANY.endpoint}${VALID_COMPANY_ID}?token=${TOKEN_USER}   expected_status=any
#    #Status Should Be    400
#    Should Be Equal As Strings   ${response.json()["error"][0]}    O campo 'Nome da empresa' da empresa é obrigatório
#    Should Be Equal As Strings   ${response.json()["error"][1]}    O campo 'Email' é obrigatório.
#    Should Be Equal As Strings   ${response.json()["error"][2]}    O campo 'CNPJ' da empresa é obrigatório.
#    Should Be Equal As Strings   ${response.json()["error"][3]}    O campo 'Contado do Responsável' é obrigatório.
#    Should Be Equal As Strings   ${response.json()["error"][4]}    O campo 'Telefone' é obrigatório.
#    Should Be Equal As Strings   ${response.json()["error"][5]}    O campo 'Descrição' é obrigatório.

TC18- Atualização de cadastro da empresa por id com o cnpj em branco
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com o cnpj em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}=    PUT On Session    alias=quality-eagles    url=/${COMPANY.url}${COMPANY.endpoint}/${VALID_COMPANY_ID}?token=${TOKEN_USER}    expected_status=any
    Status Should Be    400
    Should Be Equal As Strings   ${response.json()["error"][2]}    O campo 'CNPJ' da empresa é obrigatório.

TC19 - Atualização de cadastro da empresa por id com o e-mail em branco
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com o e-mail em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${response}=    PUT On Session    alias=quality-eagles    url=/${COMPANY.url}${COMPANY.endpoint}/${VALID_COMPANY_ID}?token=${TOKEN_USER}    expected_status=any
    Status Should Be    400
    Should Be Equal As Strings   ${response.json()["error"][1]}    O campo 'Email' é obrigatório.

#TC20- Atualização de cadastro da empresa por id com o telefone em branco
#    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com o telefone em branco
#    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
#    ${response}=    PUT On Session    alias=quality-eagles    url=/${COMPANY.url}${COMPANY.endpoint}${VALID_COMPANY_ID}?token=${TOKEN_USER}    expected_status=any
#    #Status Should Be    400
#    Should Be Equal As Strings   ${response.json()["error"][4]}    O campo 'Telefone' é obrigatório.

TC21 - Atualização de endereço da empresa com sucesso
    [Documentation]    Atualizar o endereço da empresa
    ${response}    Atualizar endereço da empresa
   
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal    ${response.json()["msg"]}    Endereço da companhia atualizado com sucesso.
    
     # Validar campos atualizados
    Dictionary Should Contain Key     ${response.json()["updateCompany"]}    address

TC22 -Atualização de status por id para false com sucesso
    [Documentation]    Atualizar o status para false utilizando o id do usuário
    ${response}      Atualizar status da empresa     status=false
    #Status Should Be    200
    Should Be Equal    ${response['msg']}    Status da companhia atualizado com sucesso.

TC23 - Atualização de status por id para true com sucesso
    [Documentation]    Atualizar o status para true utilizando o id do usuário
    ${companyFake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${companyId}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${response}      Atualizar status da empresa   companyId=${companyId}    status=true
    #Status Should Be    200
    Should Be Equal    ${response['msg']}    Status da companhia atualizado com sucesso.
   
TC24 - Atualização de status por id com id inválido 
    [Documentation]     Validar acesso negado à atualizção de status da empresa com ID inválido
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${COMPANY_STATUS.url}${COMPANY_STATUS.endpoint}/${INVALID_COMPANY_ID}?token=${TOKEN_USER}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    # Verifica o status code
    #Status Should Be     404

    #Should Be Equal    ${response['alert'][0]}    Essa companhia não existe em nossa base de dados.

TC25 - Atualização de status por id com token em branco
    [Documentation]     Validar acesso negado à atualizção de status da empresa com ID inválido
    ${headers}     Create Dictionary
    ...     accept=application/json
    ...     Content-Type=application/json
    ${body}     Create Dictionary     status=true
    ${response}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${COMPANY_STATUS.url}${COMPANY_STATUS.endpoint}/${VALID_COMPANY_ID}?token=${TOKEN_BLANK}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    
    Status Should Be     403

    Should Be Equal    ${response.json()["errors"][0]}   Failed to authenticate token.

