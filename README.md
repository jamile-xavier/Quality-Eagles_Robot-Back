<h1 align="center">Teste de Automação de API com Robot - ERP Quality Eagles Academy T13 Qa Coders </h1>

## Descrição do Projeto

<h2 align="center">
Teste de Automação de API ERP com Robot Framework
</h2>
<p align="center"> Realização de testes automação de API do ERP disponibilizado pela Qa Coders para a equipe Quality Eagles T13. </p>
<p align="center">Testes de endpoints: Login, Users e Company</p>
<p align="center"> Realização de testes de sucesso e alguns de exceção dos endpoints mencionados.</p>
<p align="center">Para realização dos testes foi utilizado os casos de testes e critérios de aceites disponibilizados pela Qa Coders através do Azure e também os endpoints disponibilizados através do Swagger.</p>
<p align="center"> O Azure também foi utilizado para abertura das PBI´s, Test Plan Suite e Test Pan.</p>
<p align="center"> Os testes contidos nesse repositório possui testes de contribuição de todos os membros da equipe sendo necessário modificar alguns para adaptação e devido funcionamento após a unificação dos testes.</p>

### Sumário

- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Executando o projeto](#Executando-o-projeto)
- [Autora](#autora)
- [Equipe](#equipe)
- [Licença](#licença)

### Funcionalidades

- [x] Fazer login;
- [x] Cadastrar usuário;
- [x] Listar usuário;
- [x] Listar usuário por id;
- [x] Contagem de usuários;
- [x] Atualizar cadastro de usuário;
- [x] Atualizar senha de usuário por id;
- [x] Atualizar status de usuário por id;
- [x] Excluir usuário;
- [x] Cadastro de empresa;
- [x] Listar Empresas;
- [x] Contagem de empresas;
- [x] Atualizar empresa por id;
- [x] Atualizar endereço da empresa por id;
- [x] Atualizar o status da empresa por id
- [x] Excluir empresa;

### Tecnologias

- [VsCode](https://code.visualstudio.com/), ou outra IDE de sua preferência
- [Python](https://www.python.org/) - Caso não possua instalado será necessário realizar instalação antes de executar o projeto.
- [Robot](https://robotframework.org/)
- [RequestsLibrary](https://docs.robotframework.org/docs/different_libraries/requests)
- [Faker](https://faker.readthedocs.io/en/master/)
- [PYYAML](https://pypi.org/project/PyYAML/)
- [Swagger](https://swagger.io/)
- [Azure](https://azure.microsoft.com/pt-br/)

### Executando-o-projeto

Passo a passo utilizando o VsCode:

- Realizar o dowload do projeto;
- Abrir o VsCode;
- Clicar em File;
- Open Folder;
- Selecionar pasta;
- Abrir o terminal e digitar o comando para instalar as dependências (o comando abaixo realizará a instalação de todas as dependências necessárias):

```bash
pip install -r requeriments.txt
```

- Digitar no terminal o comando para executar todos os testes

```bash
robot -d log .\resource\tests\
```

Para executar os testes por arquivo:

Teste de empresas:

```bash
 robot -d log .\resource\tests\company.robot
```

Teste de login:

```bash
 robot -d log .\resource\tests\login.robot
```

Teste de usuários:

```bash
 robot -d log .\resource\tests\user.robot
```

### Autora

<p> Jamile Xavier Mendonça </p>

[Github](https://github.com/jamile-xavier)

[Linkedin](https://www.linkedin.com/in/jamile-xavier/)

### Equipe

- Cristian Fabiano Eisenhut (TechLead)
- Caroline Uchida
- Ítalo Mateus Costa
- Jamile Xavier Mendonça
- Lucas Antônio
- Sônia Izabel Wicki
- Tadeu Augusto Dutra Pinto

### Licença

MIT
https://www.linkedin.com/in/cristianeisenhut/
