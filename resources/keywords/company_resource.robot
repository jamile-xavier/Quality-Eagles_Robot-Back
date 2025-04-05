*** Settings ***
Variables      ../../fixtures/environments.yaml
Resource    ../tests/login.robot
Library    ../../libs/get_fake_company.py
Library    Collections
Library    Dialogs
Library    String
Library    RequestsLibrary

*** Keywords ***
Criar empresa
    [Documentation]    Keyword para criar uma empresa com dados aleatórios
    [Arguments]    ${companyFake}    ${token}
    ${headers}    Create Dictionary   
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
    ...    url=/${COMPANY.url}${COMPANY.endpoint}?token=${TOKEN_USER}
    ...    json=${body}
    ...    expected_status=201
    RETURN    ${response}
    
Cadastro Empresa Sucesso
    [Documentation]    Keyword para cadastrar uma empresa com sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    200
    ${companyFake}        Get Fake Company
    ${idCompany}       Criar Empresa     ${companyFake}    ${TOKEN_USER}

    RETURN           ${idCompany}
Criar empresa manual
    [Documentation]    Keyword para criar uma empresa com os dados manuais
    [Arguments]
    ...    ${corporateName} 
    ...    ${registerCompany}  
    ...    ${mail} 
    ...    ${token} 
    ...    ${responsibleContact}
    ...    ${zipCode}
    ...    ${city}
    ...    ${state}
    ...    ${district}
    ...    ${street}
    ...    ${number}
    ...    ${phone}
    ...    ${serviceDescription}
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
    ...    url=/${COMPANY.url}${COMPANY.endpoint}?token=${TOKEN_USER}
    ...    json=${body}
    ...   expected_status=any
    
    RETURN    ${response}
Listar empresa por id
    [Documentation]    Keyword para listar empresa por id
    [Arguments]    ${id}
    ${url}         Set Variable    /${COMPANY.url}${COMPANY.endpoint}/${id}/?token=${TOKEN_USER}
    ${response}    GET On Session    alias=quality-eagles    url=${url}
    RETURN         ${response}

Atualizar endereço da empresa
    [Documentation]    Keyword para atualizar o endereço da empresa
    ${companyFake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${companyId}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    ${address}=    Create List
    ${addressItem}=    Create Dictionary
    ...    zipCode=90906874
    ...    city=Vilhena
    ...    state=SP
    ...    district=Sossego
    ...    street=Alameda Getúlio Vargas
    ...    number=727
    ...    complement=de 4500 ao fim - lado par
    ...    country=Brasil
    Append To List    ${address}    ${addressItem}
    ${body}=    Create Dictionary
    ...    corporateName=${response.json()["newCompany"]["corporateName"]}
    ...    registerCompany=${response.json()["newCompany"]["registerCompany"]}
    ...    mail=${response.json()["newCompany"]["mail"]}
    ...    matriz=Teste
    ...    responsibleContact=${response.json()["newCompany"]["responsibleContact"]}
    ...    telephone=${response.json()["newCompany"]["telephone"]}
    ...    serviceDescription=${response.json()["newCompany"]["serviceDescription"]}
    ...    address=${address}
    ${response}    PUT On Session    alias=quality-eagles    url=/${COMPANY_ADDRESS.url}${COMPANY_ADDRESS.endpoint}/${company_id}?token=${TOKEN_USER}    json=${body}    headers=${headers}

Atualizar status da empresa
    [Documentation]    Keyword para atualizar o status da empresa
    [Arguments]    ${status}
    ${company_fake}    Get Fake Company
    ${response}    Cadastro Empresa Sucesso
    ${companyId}    Set Variable    ${response.json()["newCompany"]["_id"]}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
    ${body}        Create Dictionary    status=${status}
    ${response}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY_STATUS.url}${COMPANY_STATUS.endpoint}/${companyId}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    headers=${headers}
    RETURN         ${response.json()}



Deletar empresa
    [Documentation]    Keyword para exclusão de empresa
    [Arguments]    ${companyId}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${response}    DELETE On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY.url}${COMPANY.endpoint}/${companyId}?token=${TOKEN_USER}
                     ...    headers=${headers}

    RETURN         ${response.json()}