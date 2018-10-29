# Projeto Areco
## Cadastro de Itens Areco
* Foi criado um cadastro de itens que podem ser produtos, ou serviços. Cada um com características comuns, e características pessoais.

* Banco de dados utilizado MySQL.

* Para acesso ao sistema, basta que ele seja compilado, e a biblioteca libMySQL.dll esteja na mesma pasta do executável. 

* O acesso ao banco se dá através de um arquivo .ini que é criado no momento da primeira execução, ele deve ser configurado com o nome da base de dados, usuário e senha. Caso não seja feito nenhuma alteração, por padrão as configurações são:
  Database=produtositens
  Server=localhost
  Port=3306
  UserName=root
  Password=root

* Para criação da base de dados, no repositório do Git, existe um script SQL que cria as tabelas conforme padrão utilizado pelo projeto, basta que seja executado em uma base escolhida e limpa. 




