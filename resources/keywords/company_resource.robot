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
    [Documentation]    Criar uma empresa com dados aleatórios
    [Arguments]    ${company_fake}    ${token}
    ${headers}    Create Dictionary   
    ${address}=    Create List
    ${address_item}=    Create Dictionary
    ...    zipCode=${company_fake}[zipCode]
    ...    city=${company_fake}[city]
    ...    state=${company_fake}[state]
    ...    district=${company_fake}[neighborhood]
    ...    street=${company_fake}[street]
    ...    number=${company_fake}[number]
    ...    complement=Loja
    ...    country=Brasil
    Append To List    ${address}    ${address_item}
    ${body}=    Create Dictionary
    ...    corporateName=${company_fake}[corporateName]
    ...    registerCompany=${company_fake}[cnpj]
    ...    mail=${company_fake}[corporateEmail]
    ...    matriz=Teste
    ...    responsibleContact=${company_fake}[responsibleName]
    ...    telephone=${company_fake}[phone]
    ...    serviceDescription=${company_fake}[serviceDescription]
    ...    address=${address}
    ${response}=    POST On Session
    ...    headers=${headers}
    ...    alias=quality-eagles
    ...    url=/${COMPANY.url}${COMPANY.endpoint}?token=${TOKEN_USER}
    ...    json=${body}
    ...    expected_status=201
    RETURN    ${response}
    
Cadastro Empresa Sucesso
    ${response}    Realizar login com token user   ${MAIL_USER}    ${PASSWORD_USER}    expected_status=200
    ${company_fake}        Get Fake Company
    ${id_company}       Criar Empresa     ${company_fake}    ${TOKEN_USER}

    RETURN           ${id_company}


Criar empresa manual
    [Documentation]    Criar uma empresa com dados aleatórios
    [Arguments]    ${corporateName}    ${registerCompany}    ${mail}     ${token}
    ${address}=    Create List
    ${address_item}=    Create Dictionary
    ...    zipCode=04777001
    ...    city=São Paulo
    ...    state=SP
    ...    district=Bom Jardim
    ...    street=Avenida Interlagos
    ...    number=50
    ...    complement=de 4503 ao fim - lado ímpar
    ...    country=Brasil
    Append To List    ${address}    ${address_item}           
    ${body}=    Create Dictionary
    ...    corporateName=${corporateName} 
    ...    registerCompany=${registerCompany} 
    ...    mail=${mail}
    ...    matriz=Teste
    ...    responsibleContact=Guilherme Magalhaes
    ...    telephone=62877232459394
    ...    serviceDescription=Testes
    ...    address=${address}
     
     
   
    
    ${response}=    POST On Session
    ...    alias=quality-eagles
    ...    url=/${COMPANY.url}${COMPANY.endpoint}?token=${TOKEN_USER}
    ...    json=${body}
    ...   expected_status=any
    
    RETURN    ${response}
Listar empresa por id
    [Arguments]    ${id}
    ${url}         Set Variable    /${COMPANY.url}${COMPANY.endpoint}/${id}/?token=${TOKEN_USER}
    ${response}    GET On Session    alias=quality-eagles    url=${url}
    RETURN         ${response}

Atualizar status da empresa
    [Arguments]    ${company_id}    ${status}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
    ${body}        Create Dictionary    status=${status}
    ${response}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY_STATUS.url}${COMPANY_STATUS.endpoint}/${company_id}?token=${TOKEN_USER}
                     ...    json=${body}
                     ...    headers=${headers}
    RETURN         ${response.json()}

Deletar empresa
    [Arguments]    ${company_id}
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json

    ${response}    DELETE On Session
                     ...    alias=quality-eagles
                     ...    url=/${COMPANY.url}${COMPANY.endpoint}/${company_id}?token=${TOKEN_USER}
                     ...    headers=${headers}

    RETURN         ${response.json()}