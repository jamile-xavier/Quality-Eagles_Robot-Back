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
    ${responseCompany}    ${companyFake}    Realizar Login e cadastrar empresa retornando dados fake
    
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
       
    Status Should Be    400    ${responseCompany}
    Should Be Equal    ${responseCompany.json()['alert'][0]}    Essa companhia já está cadastrada. Verifique o nome, CNPJ e a razão social da companhia.
#
TC03 - Cadastrar empresa sem nome da empresa
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o nome
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}     Criar empresa manual
    ...    corporateName=
    ...    registerCompany=${companyFake}[cnpj]
    ...    mail=${companyFake}[corporateEmail]
    ...    responsibleContact=${companyFake}[responsibleName]
    ...    phone=${companyFake}[phone]
    ...    serviceDescription=${companyFake}[serviceDescription]
    ...    zipCode=${companyFake}[zipCode]
    ...    city=${companyFake}[city]
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood]
    ...    street=${companyFake}[street]
    ...    number=${companyFake}[number]
  
  
    Status Should Be    400    ${responseCompany}
    Should Be Equal    ${responseCompany.json()['error'][0]}    O campo 'Nome da empresa' da empresa é obrigatório
TC04 - Cadastrar empresa com nome da empresa com caracteres acima do limite
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o nome
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}     Criar empresa manual
    ...    corporateName=${LONG_CORPORATE_NAME}
    ...    registerCompany=${companyFake}[cnpj]
    ...    mail=${companyFake}[corporateEmail]
    ...    responsibleContact=${companyFake}[responsibleName]
    ...    phone=${companyFake}[phone]
    ...    serviceDescription=${companyFake}[serviceDescription]
    ...    zipCode=${companyFake}[zipCode]
    ...    city=${companyFake}[city]
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood]
    ...    street=${companyFake}[street]
    ...    number=${companyFake}[number]
  
  
    Status Should Be    400    ${responseCompany}
    Should Be Equal    ${responseCompany.json()['error'][0]}    O campo 'Nome da empresa' deve ter no máximo 100 caracteres.

TC05 - Cadastrar empresa sem o CNPJ
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o cnpj
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${response}     Criar empresa manual
    ...    corporateName=${companyFake}[corporateName]
    ...    registerCompany=
    ...    mail=${companyFake}[corporateEmail]
    ...    responsibleContact=${companyFake}[responsibleName]
    ...    phone=${companyFake}[phone]
    ...    serviceDescription=${companyFake}[serviceDescription]
    ...    zipCode=${companyFake}[zipCode]
    ...    city=${companyFake}[city]
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood]
    ...    street=${companyFake}[street]
    ...    number=${companyFake}[number]
  
    Status Should Be    400    ${response}
    Should Be Equal    ${response.json()['error'][0]}    O campo 'CNPJ' da empresa é obrigatório.

TC06 - Cadastrar empresa sem e-mail
    [Documentation]     Validar acesso negado à cadastro de empresa sem informar o e-mail
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}     Criar empresa manual
    ...    corporateName=${companyFake}[corporateName]
    ...    registerCompany=${companyFake}[cnpj]
    ...    mail=
    ...    responsibleContact=${companyFake}[responsibleName]
    ...    phone=${companyFake}[phone]
    ...    serviceDescription=${companyFake}[serviceDescription]
    ...    zipCode=${companyFake}[zipCode]
    ...    city=${companyFake}[city]
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood]
    ...    street=${companyFake}[street]
    ...    number=${companyFake}[number]

    Status Should Be    400    ${responseCompany}
    Should Be Equal    ${responseCompany.json()['error'][0]}    O campo 'Email' é obrigatório.

TC07 - Exclusão de empresa com sucesso
    [Documentation]    Deletar uma empresa existente
    ${response}    Cadastro Empresa Sucesso       
    ${companyId}       Set Variable    ${response.json()["newCompany"]["_id"]}

    # Deletar usuário
    ${response}      Deletar empresa    ${companyId}

    # Validações
    Status Should Be    200    
    Should Be Equal   Companhia deletado com sucesso.    ${response["msg"]}

TC08 - Exclusão de empresa com id inválido
  [Documentation]     Validar acesso negado à exclusão de empresa informando um token inválido
    ${response}    Cadastro Empresa Sucesso       
    ${companyId}       Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Criar headers com token    ${TOKEN_INVALID}
    ${responseCompany}=    DELETE On Session 
    ...    alias=quality-eagles
    ...    headers=${headers} 
    ...    url=/${COMPANY}/${companyId}
    ...    expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${responseCompany.json()["errors"][0]}    Failed to authenticate token.

TC09 - Exclusão de empresa com token inválido
    [Documentation]     Validar acesso negado à exclusão de empresa informando um token inválido
    ${headers}    Criar headers com token    ${TOKEN_INVALID}
    ${response}=    DELETE On Session 
    ...    alias=quality-eagles
    ...    headers=${headers} 
    ...    url=/${COMPANY}/${VALID_COMPANY_ID}
    ...    expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC10 - Listagem de empresa com sucesso
    [Documentation]    Listar todas as empresas cadastradas
    ${response}    Listar empresa com sucesso
    Status Should Be    200    ${response}

   # Validar estrutura da resposta
    Should Be True    isinstance(${response.json()}, list)
    Should Not Be Empty    ${response.json()}

    # Validar primeiro usuário da lista
    ${firstCompany}    Set Variable    ${response.json()[0]}

    # Validar campos obrigatórios
    Dictionary Should Contain Key    ${firstCompany}    corporateName
    Dictionary Should Contain Key    ${firstCompany}    registerCompany
    Dictionary Should Contain Key    ${firstCompany}    responsibleContact
    Dictionary Should Contain Key    ${firstCompany}    mail
    Dictionary Should Contain Key    ${firstCompany}    telephone

TC11 - Listagem de empresa com token inválido
    [Documentation]     Validar acesso negado à listagem de empresa por id com um token inválido
    ${headers}    Criar headers com token    ${TOKEN_INVALID}
    ${response}=    GET On Session
    ...    alias=quality-eagles
    ...    headers=${headers} 
    ...    url=/${COMPANY}/${VALID_COMPANY_ID}
    ...    expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC12 - Listagem de empresa com token em branco
    [Documentation]     Validar acesso negado à listagem de empresa por id com um token inválido
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${response}=    GET On Session 
    ...    alias=quality-eagles 
    ...    headers=${headers} 
    ...    url=/${COMPANY}/${VALID_COMPANY_ID}
    ...    expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.   

TC13 - Contagem de empresa com sucesso
    [Documentation]    Realizar a contagem de todas as empresas cadastradas
    ${response}   Contagem de empresa com sucesso
    Status Should Be    200    ${response}
    # Validar conteúdo da resposta
    Dictionary Should Contain Key   ${response.json()}    count

TC14 - Contagem de empresa com token inválido
    [Documentation]     Validar acesso negado à contagem de empresa com o token inválido
    ${headers}    Criar headers com token    ${TOKEN_INVALID}
    ${response}=    GET On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${COMPANY_COUNT}
    ...    expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC15 - Contagem de empresa com token em branco
    [Documentation]     Validar acesso negado à contagem usuários com o token inválido
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${response}=    GET On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${USER_COUNT}
    ...    expected_status=any
    Status Should Be    403
    Log    GET Count Users Response: ${response}
    Log To Console    ${response.json()["errors"][0]}
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.

TC16 - Atualização de cadastro da empresa por id com sucesso
    [Documentation]    Atualizar dados básicos da empresa - Responsável
    ${fakeCompany}    Get Fake Company
    ${response}    Atualizar cadastro empresa por id
       
    Status Should Be  200
    Should Be Equal    ${response.json()["msg"]}    Companhia atualizada com sucesso.
    # Validar campos atualizados
    ${updatedCompany}    Set Variable    ${response.json()["updatedCompany"]}
    Dictionary Should Contain Key    ${updatedCompany}    responsibleContact


    Should Be Equal    ${RESPONSIBLE_CONTACT}   ${updatedCompany["responsibleContact"]}

    Log To Console    Responsável atualizado: ${updatedCompany["responsibleContact"]}
    Log To Console    Dados da empresa atualizada: ${response.json()}

TC17 - Atualização de cadastro da empresa por id com token inválido
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com um token inválido
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${headers}    Criar headers com token    ${TOKEN_INVALID}
    ${fakeCompany}    Get Fake Company
    ${body}    Create Dictionary 
    ...    corporateName=${fakeCompany}[corporateName]
    ...    registerCompany=${fakeCompany}[cnpj]
    ...    mail=${fakeCompany}[corporateEmail]
    ...    responsibleContact= ${fakeCompany}[responsibleName]
    ...    telephone=${fakeCompany}[phone]
    ...    serviceDescription=${fakeCompany}[serviceDescription]
    ${response}=    PUT On Session 
    ...    alias=quality-eagles
    ...    json=${body}
    ...    headers=${headers}  
    ...    url=/${COMPANY.url}${COMPANY.endpoint}/${VALID_COMPANY_ID}
    ...  expected_status=any
    Status Should Be    403
    Should Be Equal As Strings   ${response.json()["errors"][0]}    Failed to authenticate token.
TC18- Atualização de cadastro da empresa por id com o cnpj em branco
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com o cnpj em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${fakeCompany}    Get Fake Company
    ${responseCompany}    Atualizar cadastro empresa por id manual
    ...    corporateName=${fakeCompany}[corporateName]
    ...    registerCompany=
    ...    mail=${fakeCompany}[corporateEmail]
    ...    responsibleContact= ${fakeCompany}[responsibleName]
    ...    telephone=${fakeCompany}[phone]
    ...    serviceDescription=${fakeCompany}[serviceDescription]
    Status Should Be    400
    Should Be Equal As Strings   ${responseCompany.json()["error"][1]}    O campo 'CNPJ' da empresa é obrigatório.

TC19 - Atualização de cadastro da empresa por id com o e-mail em branco
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com o e-mail em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${fakeCompany}    Get Fake Company
    ${responseCompany}    Atualizar cadastro empresa por id manual
    ...    corporateName=${fakeCompany}[corporateName]
    ...    registerCompany=${fakeCompany}[cnpj]
    ...    mail=
    ...    responsibleContact= ${fakeCompany}[responsibleName]
    ...    telephone=${fakeCompany}[phone]
    ...    serviceDescription=${fakeCompany}[serviceDescription]
    Status Should Be    400
    Should Be Equal As Strings   ${responseCompany.json()["error"][0]}    O campo 'Email' informado é inválido. Informe um e-mail no formato [nome@domínio.com].

TC20 - Atualização de cadastro da empresa por id com todos os campos em branco
    [Documentation]     Validar acesso negado à atualização de cadastro da empresa por id com todos os campos em branco
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${responseCompany}    Atualizar cadastro empresa por id manual
    ...    corporateName=
    ...    registerCompany=
    ...    mail=
    ...    responsibleContact= 
    ...    telephone=
    ...    serviceDescription=
   
    Status Should Be    400
   
     Should Be Equal As Strings   ${responseCompany.json()["error"][0]}    O campo 'Nome da empresa' da empresa é obrigatório
     Should Be Equal As Strings   ${responseCompany.json()["error"][1]}    O campo 'Email' informado é inválido. Informe um e-mail no formato [nome@domínio.com].
     Should Be Equal As Strings   ${responseCompany.json()["error"][2]}    O campo 'CNPJ' da empresa é obrigatório.
     Should Be Equal As Strings   ${responseCompany.json()["error"][3]}    O campo 'Contado do Responsável' é obrigatório.
     #Should Be Equal As Strings   ${responseCompany.json()["error"][4]}    O campo 'Telefone' é obrigatório.
     Should Be Equal As Strings   ${responseCompany.json()["error"][5]}    O campo 'Descrição' é obrigatório.    

TC21 - Atualização de endereço da empresa com sucesso
    [Documentation]    Atualizar o endereço da empresa
    ${response}    Atualizar endereço da empresa
      
    Status Should Be   200
    #Should Be Equal    ${responseCompany.json()["msg"]}    Endereço da companhia atualizado com sucesso
    
     # Validar campos atualizados
    Dictionary Should Contain Key     ${response.json()["updateCompany"]}    address

TC22 - Atualização do endereço da empresa sem cep
    [Documentation]    Atualizar o endereço da empresa com cep em branco
    ${companyFake}        Get Fake Company
    ${response}    Atualizar endereço da empresa manual
    ...    zipCode=
    ...    city=${companyFake}[city] 
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood] 
    ...    street=${companyFake}[street]  
    ...    number=${companyFake}[number]
    
    Status Should Be    400
    Should Be Equal    ${response.json()["error"][0]}   O campo 'CEP' é obrigatório.

TC23 - Atualização do endereço da empresa sem nome da rua
    [Documentation]    Atualizar o endereço da empresa com nome da rua em branco
    ${companyFake}        Get Fake Company
    ${response}    Atualizar endereço da empresa manual
    ...    zipCode=${companyFake}[zipCode] 
    ...    city=${companyFake}[city] 
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood] 
    ...    street= 
    ...    number=${companyFake}[number]
    
    Status Should Be    400
    Should Be Equal    ${response.json()["error"][0]}   O campo 'logradouro' é obrigatório.

TC24 - Atualização de endereço da empresa com número possuindo mais caracteres que o limite definido
    [Documentation]    Atualizar o endereço da empresa com mais caracteres que o permitido no campo número
    ${companyFake}        Get Fake Company
    ${response}    Atualizar endereço da empresa manual
    ...    zipCode=${companyFake}[zipCode] 
    ...    city=${companyFake}[city] 
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood] 
    ...    street=${companyFake}[street]  
    ...    number=${NUMBER_COMPANY_EXCEPTION}
    
    Status Should Be    400
    Should Be Equal    ${response.json()["error"][0]}   O campo 'número' deve possuir no máximo 10 caracteres.

TC25 - Atualização de endereço da empresa com todos os campos em branco
    [Documentation]    Atualizar o endereço da empresa com todos os campos em branco
    ${response}    Atualizar endereço da empresa manual
    ...    zipCode=
    ...    city=
    ...    state=
    ...    district=
    ...    street=
    ...    number=
    
    Status Should Be    400
    Should Be Equal    ${response.json()["error"][0]}   O campo 'CEP' é obrigatório.
    Should Be Equal    ${response.json()["error"][1]}   O campo 'cidade' é obrigatório. 
    Should Be Equal    ${response.json()["error"][2]}   O campo 'estado' é obrigatório.
    Should Be Equal    ${response.json()["error"][3]}   O campo 'bairro' é obrigatório.
    Should Be Equal    ${response.json()["error"][4]}   O campo 'logradouro' é obrigatório.
    Should Be Equal    ${response.json()["error"][5]}   O campo 'número' é obrigatório.
TC26 -Atualização de status por id para false com sucesso
    [Documentation]    Atualizar o status para false utilizando o id do usuário
    ${response}      Atualizar status da empresa     status=false
    #Status Should Be    200
    Should Be Equal    ${response['msg']}    Status da companhia atualizado com sucesso.

TC27 - Atualização de status por id para true com sucesso
    [Documentation]    Atualizar o status para true utilizando o id do usuário
    ${response}      Atualizar status da empresa      status=true
    #Status Should Be    200
    Should Be Equal    ${response['msg']}    Status da companhia atualizado com sucesso.

TC28 - Atualização de status por id com token em branco
    [Documentation]     Validar acesso negado à atualizção de status da empresa com ID inválido
    ${response}    Cadastro Empresa Sucesso
    ${companyId}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Criar headers com token    ${TOKEN_BLANK}
    ${body}     Create Dictionary     status=true
    ${responseCompany}     PUT On Session
    ...     alias=quality-eagles
    ...     url=/${COMPANY_STATUS.url}${COMPANY_STATUS.endpoint}/${VALID_COMPANY_ID}
    ...     json=${body}
    ...     headers=${headers}
    ...     expected_status=any
    
    
    Status Should Be     403

    Should Be Equal    ${responseCompany.json()["errors"][0]}   Failed to authenticate token.

