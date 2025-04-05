*** Variables ***
${TOKEN_BLANK}    ""
${TOKEN_INVALID}    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2N2NhMzdhMzExZDVmZjc2Mjk2MjZmOTAiLCJmdWxsTmFtZSI6IkNhcm9saW5lIE5vdmFpcyIsIm1haWwiOiJjb3N0YWRhdmktbHVjY2FAZXhhbXBsZS5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRtTTdxWi9LeWxqMTZKM2I4T1hJaGl1bkttd0RGaFRWS1NzS21kV1I3bnVKSUVBWDRVMTJFcSIsImFjY2Vzc1Byb2ZpbGUiOiJBRE1JTiIsImNwZiI6IjQ1NzIxMzA5NjUyIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjY2ZGI1ZTQwZTVhMDAxNTYzNGYxMzdlNiIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoicXVpbnRhLWZlaXJhLCAwNi8wMy8yMDI1LCAyMTowMjo0MyBCUlQiLCJyZWdpc3RyYXRpb25OdW1iZXIiOiJRYUNvZGVycy0yOTkwIiwiX2lkIjoiNjdjYTM3YTMxMWQ1ZmY3NjI5NjI2ZjkxIn1dLCJfX3YiOjAsImlhdCI6MTc0MTQ3MjgzNSwiZXhwIjoxNzQxNTU5MjM1fQ.co6_pj0KsFiH5a3q6fLvqGECth4QHOyb603nu5XjIN4
${VALID_COMPANY_ID}    67ccdaf911d5ff7629a82d31
${INVALID_COMPANY_ID}    67ccdaf911d5ff7629a82v47


# Dados para teste de cadastro de empresa em duplicidade
${CORPORATE_NAME_DUPLICATE}    Bebidas Carvalho 
${REGISTER_COMPANY_DUPLICATE}    63445495483108
${MAIL_COMPANY_DUPLICATE}    giovannacarvalho_53450fd9-2eec-46fe-8f23-275a8c5b0b20@atendimento.com.br
${RESPONSIBLE_CONTACT_DUPLICATE}    Gabriel Costa
${PHONE_COMPANY_DUPLICATE}    428959506374250
${SERVICE_DESCRIPTION_DUPLICATE}    Testes
${ZIP_CODE_COMPANY_DUPLICATE}    82186821
${CITY_COMPANY_DUPLICATE}    Rio Crespo
${STATE_COMPANY_DUPLICATE}    PI
${DISTRICT_COMPANY_DUPLICATE}    São Gonçalo
${STREET_COMPANY_DUPLICATE}    Boulevard Vagner Frances
${NUMBER_COMPANY_DUPLICATE}    124


# Dados para teste de cadastro de empresa inválido e atualização de endereço
${CORPORATE_NAME}    Comércio TechInnovate Educação
${REGISTER_COMPANY}    14686715000154
${MAIL_COMPANY}    comercial@techinnovate.com.br
${RESPONSIBLE_CONTACT}    Manuel Thirine
${PHONE_COMPANY}    356987412547865
${SERVICE_DESCRIPTION}    Venda de cursos de tecnologia
${ZIP_CODE_COMPANY}    30190925
${CITY_COMPANY}    Belo Horizonte
${STATE_COMPANY}    MG
${DISTRICT_COMPANY}    Belo Horizonte
${STREET_COMPANY}    Rua Goiás
${NUMBER_COMPANY}    244