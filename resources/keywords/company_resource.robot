*** Settings ***
Variables      ../../fixtures/environments.yaml
Resource    ../tests/login.robot
Resource    ../keywords/login_resource.robot
Resource    ../pages/company_variables.robot
Library    ../../libs/get_fake_company.py
Library    Collections
Library    Dialogs
Library    String
Library    RequestsLibrary

*** Keywords ***
Criar empresa
    [Documentation]    Keyword para criar uma empresa com dados aleatórios
    [Arguments]    ${companyFake}   
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${address}=    Create List
    ${addressItem}=    Create Dictionary
    ...    zipCode=${companyFake}[zipCode]
    ...    city=${companyFake}[city]
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood]
    ...    street=${companyFake}[street]
    ...    number=${companyFake}[number]
    ...    complement=Loja
    ...    country=Brasil
    Append To List    ${address}    ${addressItem}
    ${body}=    Create Dictionary
    ...    corporateName=${companyFake}[corporateName]
    ...    registerCompany=${companyFake}[cnpj]
    ...    mail=${companyFake}[corporateEmail]
    ...    matriz=Teste
    ...    responsibleContact=${companyFake}[responsibleName]
    ...    telephone=${companyFake}[phone]
    ...    serviceDescription=${companyFake}[serviceDescription]
    ...    address=${address}
    ${response}=    POST On Session
    ...    headers=${headers}
    ...    alias=quality-eagles
    ...    url=/${COMPANY.url}${COMPANY.endpoint}
    ...    json=${body}
    ...    expected_status=201
    RETURN    ${response}
    
Cadastro Empresa Sucesso
    [Documentation]    Keyword para cadastrar uma empresa com sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}       Criar Empresa     ${companyFake}   
    RETURN           ${responseCompany}   

Realizar Login e cadastrar empresa retornando dados fake
    [Documentation]    Realiza o login como usuário e cadastra empresa
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${responseCompany}       Criar Empresa     ${companyFake}    
    RETURN    ${responseCompany}  ${companyFake}         

    
Criar empresa manual
    [Documentation]    Keyword para criar uma empresa com os dados manuais
    [Arguments]
    ...    ${corporateName} 
    ...    ${registerCompany}  
    ...    ${mail} 
    ...    ${responsibleContact}
    ...    ${zipCode}
    ...    ${city}
    ...    ${state}
    ...    ${district}
    ...    ${street}
    ...    ${number}
    ...    ${phone}
    ...    ${serviceDescription}
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${address}=    Create List
    ${addressItem}=    Create Dictionary
    ...    zipCode=${zipCode}
    ...    city=${city}
    ...    state=${state}
    ...    district=${district}
    ...    street=${street}
    ...    number=${number}
    ...    complement=Loja
    ...    country=Brasil
    Append To List    ${address}    ${addressItem}           
    ${body}=    Create Dictionary
    ...    corporateName=${corporateName} 
    ...    registerCompany=${registerCompany} 
    ...    mail=${mail}
    ...    matriz=Teste
    ...    responsibleContact=${responsibleContact}
    ...    telephone=${phone}
    ...    serviceDescription=${serviceDescription}
    ...    address=${address}
     
      
    ${response}=    POST On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${COMPANY.url}${COMPANY.endpoint}?token=${TOKEN_USER}
    ...    json=${body}
    ...   expected_status=any
    
    RETURN    ${response}

Listar empresa com sucesso
    [Documentation]    Keyword para listar empresas com sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}   200
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${responseCompany}    GET On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${COMPANY.url}${COMPANY.endpoint}/
    RETURN    ${responseCompany}

Listar empresa por id
    [Documentation]    Keyword para listar empresa por id
    [Arguments]    ${id}
     ${headers}    Criar headers com token    ${TOKEN_USER}
    ${url}         Set Variable    /${COMPANY.url}${COMPANY.endpoint}/${id}/
    ${response}    GET On Session 
    ...    alias=quality-eagles 
    ...    headers=${headers}
    ...    url=${url}
    RETURN         ${response}

Contagem de empresa com sucesso
    [Documentation]    Keyword para realizar contagem de empresas com sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${responseCompany}    GET On Session
    ...    alias=quality-eagles
    ...    headers=${headers}
    ...    url=/${COMPANY_COUNT.url}${COMPANY_COUNT.endpoint}/
    RETURN    ${responseCompany}

Atualizar cadastro empresa por id
    [Documentation]    Keyword para atualizar o cadastro da empresa por id
    ${response}    Cadastro Empresa Sucesso
    ${company_id}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${body}    Create Dictionary    
    ...    corporateName=${response.json()["newCompany"]["corporateName"]}
    ...    registerCompany=${response.json()["newCompany"]["registerCompany"]} 
    ...    mail=${response.json()["newCompany"]["mail"]} 
    ...    matriz=${response.json()["newCompany"]["matriz"]} 
    ...    responsibleContact= ${RESPONSIBLE_CONTACT}
    ...    telephone=${response.json()["newCompany"]["telephone"]}
    ...    serviceDescription=${response.json()["newCompany"]["serviceDescription"]}
    ${responseCompany}    PUT On Session
    ...    alias=quality-eagles
    ...    url=/${COMPANY.url}${COMPANY.endpoint}/${company_id}
    ...    json=${body} 
    ...    headers=${headers}
    RETURN    ${responseCompany}

Atualizar endereço da empresa
    [Documentation]    Keyword para realizar atualização de endereço da empresa
    ${responseCompany}    ${companyFake}     Realizar Login e cadastrar empresa retornando dados fake    
    ${companyId}    Set Variable    ${responseCompany.json()["newCompany"]["_id"]}
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${address}=    Create List
    ${addressItem}=    Create Dictionary
    ...    zipCode=${companyFake}[zipCode]
    ...    city=${companyFake}[city]
    ...    state=${companyFake}[state]
    ...    district=${companyFake}[neighborhood]
    ...    street=${companyFake}[street]
    ...    number=${companyFake}[number]
    ...    complement=Loja
    ...    country=Brasil
    Append To List    ${address}    ${addressItem}
    ${body}=    Create Dictionary
    ...    corporateName=${responseCompany.json()["newCompany"]["corporateName"]}
    ...    registerCompany=${responseCompany.json()["newCompany"]["registerCompany"]}
    ...    mail=${responseCompany.json()["newCompany"]["mail"]}
    ...    matriz=${responseCompany.json()["newCompany"]["matriz"]}
    ...    responsibleContact=${responseCompany.json()["newCompany"]["responsibleContact"]}
    ...    telephone=${responseCompany.json()["newCompany"]["telephone"]}
    ...    serviceDescription=${responseCompany.json()["newCompany"]["serviceDescription"]}
    ...    address=${address}
    ${response}    PUT On Session
    ...    alias=quality-eagles
    ...    url=/${COMPANY_ADDRESS.url}${COMPANY_ADDRESS.endpoint}/${company_id}
    ...    json=${body}
    ...    headers=${headers}
    RETURN    ${response}

Atualizar endereço da empresa manual
    [Documentation]    Keyword para realizar atualização de endereço da empresa de forma manual
    [Arguments]    ${zipCode}    ${city}    ${state}    ${district}    ${street}    ${number}    
    ${responseCompany}    ${companyFake}     Realizar Login e cadastrar empresa retornando dados fake        
    ${companyId}    Set Variable    ${responseCompany.json()["newCompany"]["_id"]}
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${address}=    Create List
    ${addressItem}=    Create Dictionary
    ...    zipCode=${zipCode}
    ...    city=${city} 
    ...    state=${state} 
    ...    district=${district} 
    ...    street=${street}  
    ...    number=${number} 
    ...    complement=Loja
    ...    country=Brasil
    Append To List    ${address}    ${addressItem}
    ${body}=    Create Dictionary
    ...    corporateName=${responseCompany.json()["newCompany"]["corporateName"]}
    ...    registerCompany=${responseCompany.json()["newCompany"]["registerCompany"]}
    ...    mail=${responseCompany.json()["newCompany"]["mail"]}
    ...    matriz=${responseCompany.json()["newCompany"]["matriz"]}
    ...    responsibleContact=${responseCompany.json()["newCompany"]["responsibleContact"]}
    ...    telephone=${responseCompany.json()["newCompany"]["telephone"]}
    ...    serviceDescription=${responseCompany.json()["newCompany"]["serviceDescription"]}
    ...    address=${address}
    ${response}    PUT On Session
    ...    alias=quality-eagles
    ...    url=/${COMPANY_ADDRESS.url}${COMPANY_ADDRESS.endpoint}/${company_id}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
 
    RETURN    ${response}
 Atualizar status da empresa
    [Documentation]    Keyword para atualizar o status da empresa
    [Arguments]    ${status}
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${company_fake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${companyId}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${body}        Create Dictionary    status=${status}
    ${response}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY_STATUS.url}${COMPANY_STATUS.endpoint}/${companyId}
                     ...    json=${body}
                     ...    headers=${headers}
    RETURN         ${response.json()}



Deletar empresa
    [Documentation]    Keyword para exclusão de empresa
    [Arguments]    ${companyId}
    ${headers}    Criar headers com token    ${TOKEN_USER}
    ${response}    DELETE On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY.url}${COMPANY.endpoint}/${companyId}
                     ...    headers=${headers}

    RETURN         ${response.json()}

