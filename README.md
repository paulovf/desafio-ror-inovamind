# Desafio Ruby-on-Rails InovaMind
Uma API responsável por efetuar uma busca de frases no site http://quotes.toscrape.com/, a partir de uma tag informada em uma requisição HTTP GET.

### Tecnologias utilizadas:

* Roby versão 2.4.4
* Rails versão 5.2.5
* MongoDB versão 3.6.3

#### Pré-requisitos

- Ruby 2.4.x
- Rails 5.2.x
- MongoDB >=3.x

#### Gems extras utilizadas

- bcrypt
- jwt
- simple_command
- mongoid
- rspec-rails (Grupo development)
- mongoid-rspec (Grupo development)

### Lógica adotada
Esta API retorna frases pesqusiadas a partir de uma tag informada. Primeiramente é feita uma pesquisa no banco de dados local, que se comporta como um cache de palavras. 

Caso a tag não tenha sido encontrada no banco de dados, é realizada uma busca na página inicial do site http://quotes.toscrape.com/. Caso tenha encontrado a tag nesta página, é feito um crawler (rastreio) da tag pesquisada em todo o conteúdo HTML da página inicial. Ao encontrar a tag, as informações relacionadas a esta tag são lidas, e gravadas no banco de dados.

As informações gravadas são:

- Nome do autor;
- Link para mais informações acerca do autor;
- Frase ligada a este autor;
- Grupo de tags nas quais esta frase está relacionada (pode ter uma ou mais tags).
      
Caso a pesquisa feita na página inicial do site http://quotes.toscrape.com/ não retorne nenhuma tag, é feita uma segunda pesquisa, informando a tag na url do site, seguindo este padrão:
```http://quotes.toscrape.com/tag/<tag_a_ser_pesquisada>/```


### Executando o projeto (sem Docker-Compose)
1. Para executar a api, faça o clone deste repositório;
2. Certifique-se de que as versões do Ruby, Rails e MongoDB atendem aos requisitos citados acima;
3. Entre na pasta ```desafio-ror-inovamind/source/desafio```;
4. Instale as dependências com o comando ```bundle install```;
5. Faça as migrações para o banco com o comando ```rake db:migrate```;
6. Execute a API com o comando ```rails s``` ou ```rails s -b <ip>```;


### Executando o projeto utilizando Docker-Compose

1. Para executar a api, faça o clone deste repositório;
2. Entre na pasta ```desafio-ror-inovamind/source/desafio```;
3. Digite o comando ```sudo docker-compose build```;
4. Para rodar o projeto digite o comando ```sudo docker-compose up```;


### Utilização da API

1. Criar um usuário para consumo dos dados
```
curl -H "Content-Type: application/json" -X POST -d '{"user": {"email":"example@example.com","password":"123", "password_confirmation": "123"}}' http://localhost:3000/user

```

2. Fazer login na api (se o login for realizado com sucesso, a api irá lhe retornar o token de acesso)
```
curl -H "Content-Type: application/json" -X POST -d '{"email":"example@example.com","password":"123"}' http://localhost:3000/authenticate
```

3. Consultar uma tag na api
```
curl -H "Authorization: <token_acesso>" -X GET http://localhost:3000/quotes/<tag>
```

4. Alterar senha do usuário (é preciso estar logado. Informe o email do usuário na url, utilizando o código %2e no lugar dos pontos)
```
curl -H "Authorization: <token_acesso>" -H "Content-Type: application/json" -X PUT -d '{"user": {"password":"456", "password_confirmation": "456"}}' http://localhost:3000/user/example@example%2ecom
```

5. Excluir usuário (é preciso estar logado. Informe o email do usuário na url, utilizando o código %2e no lugar dos pontos)
```
curl -H "Authorization: <token_acesso>" -H "Content-Type: application/json" -X DELETE http://localhost:3000/user/example@example%2ecom
```

### Fazendo testes na API

1. Para poder fazer testes na api, utilizando o rspec, basta executar o comando abaixo dentro da pasta ```desafio-ror-inovamind/source/desafio```;
```
rspec
```
