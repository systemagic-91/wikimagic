# Conceitos básicos na prática

O Terraform tem um fluxo básico de trabalho: `write` > `plan` > `apply`. O que seria mais ou menos como: 

```
escrever uma receita > conferir a receita > fazer a receita
```

No *write* nós escrevemos o código descrevendo **como queremos que a infraestrutura seja**. Exemplo:

```
resource "aws_instance" "meu_servidor" {
	instance_type = "t2.micro"
}
```

No *plan* executamos o comando `terraform plan` e ele olha para o que foi escrito, olha para o que já existe na infraestrutura, analisa o que precisa mudar, e mostra uma saida com a prévia do que será alterado: 

```
+ servidor meu_servidor será criado
```

No *apply* executamos o comando `terraform apply`. Aqui e onde a ferramenta realmente faz as alterações descritas. O *apply* realmente provisiona/modifica a infraestrutura.

> Write: author IaC > Plan: preview changes > Apply: provision reproducible infrastructure

### Providers

Apesar de o terraform ter seu proprio core e state, ele depende dos providers pra que ele consiga executar as ações. Podemos pensar no terraform como alguém que sabe o que queremos fazer mas que não sabe diretamente **COMO** conversar com cada serviço. O **provider** é o tradutor entre o terraform e uma plataforma/serviço. 

> Terraform > Provider AWS > AWS
>
> Terraform > Provider Azure > Azure

O provider disponibiliza para o Terraform os recursos e APIs necessários para trabalhar com uma determinada plataforma.Por exemplo, o terraform sabe que `aws_instance` pretence ao **AWS Provider**. 

> Os *providers* são os conectores que permitem ao Terraform conversar com diferentes tecnologias

O `registry` do terraform nos mostra todos os providers e modulos com os quais podemos trabalhar. Ele é como um catálogo de providers e módulos. Nesse catálogo podemos encontrar informações como: 

- Como instalar o provider
- Qual é a versão mais recente
- Quais recursos ele oferece
- Como configurá-lo 
- Exemplos de utilização 
- Documentação

O `registry` é especialmente útil porque não precisamos necessáriamente começar tudo do zero. Podemos usar *providers* oficiais e modulos reutilizáveis. 

> Modulos são como pacotes reutilizaveis de códito Terraform. Em vez de escrever manualmente dezenas de recursos para criar uma infra de rede, podemos utilizar um módulo que já faz isso.

### Instalando o Terraform

No windows via *chocolatey*: `choco install terraform`

### Executando pela primeira vez

**HCL**, *HashiCorp Configuration Language*, é a linguagem que usamos para escrever os arquivos de configuração do Terraform.

No Terraform podemos escrever: 

```
resource "aws_instance" "servidor" {
	instace_type = "t2.micro"
}
```

Com `resource` estamos dizendo que estamos declarando um recurso. O `aws_instance` é o tipo do recurso da *AWS*. `Servidor` é o nome que vamos dar ao recurso dentro do *terraform*, é um identificador ou alias. E `instace_type = "t2.micro"` é uma configuração do recurso declarado.

Então temos a seguinte estrutura:

```
bloco de recurso "provider_tipo" "alias" {
	config
}
```

Agora que entendemos a estrutura podemos executar pela primeira vez usando um provider já existente. Vamos criar o arquivo `local.tf` e digitar o conteúdo: 

```
resource "local_file" "foo" {
    filename = "exemplo.txt"
    content = "Conteudo do arquivo"
}
```

Toda vez que formos trabalhar com terraform por padrão primeiro temos que executar o comando para inicializar: 

```
terraform init
```

Ao executar este comando, o terraform olha para os arquivos `.tf` do diretorio e prepara tudo que ele precisa. Ele baixa os componentes necessários para o ambiente, ou seja, baixa providers, inicializa modulos, configura o backend para armazenar o State. 

A pasta *.terraform* armazena todos os arquivos necessários para o funcionamento do projeto no ambiente. E o arquivo *.terraform.lock.hcl* registra as versóes e hashes dos providers selecionados. Isso garante que todos que atuam no projeto usem versões compatíveis. 

Tendo entendido isso agora podemos ir para o proximo comando:

```
terraform plan
```

Quando executamos esse comando o terraform compara tres coisas:

1. O codigo `.tf`
2. O estado atual (state)
3. A infraestrutura real

Então ele calcula as diferenças e exibe o plano de ação: 

```
+ create

Terraform will perform the following actions:

  # local_file.foo will be created
  + resource "local_file" "foo" {
      + content              = "Conteudo do arquivo"
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "exemplo.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

O + significa que esse recurso será criado. Existem outros símbolos importantes: 

- `+` criar
- `~` alterar
- `-` destruir
- `-/+` destruir e criar novamente

O mais importante é o comando `plan` **NÃO** aplica mudanças, ele apenas gera um plano de execução.

O proximo comando que vamos executar é o:

```
terraform apply
```

como saída dessa execução teremos algo como: 

```
Terraform will perform the following actions:

  # local_file.foo will be created
  + resource "local_file" "foo" {
      + content              = "Conteudo do arquivo"
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "exemplo.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

local_file.foo: Creating...
local_file.foo: Creation complete after 0s [id=5214b369f828b73f43b7bc7ee2653e80a57dd46c]
```

O `terraform apply` pega a configuração que escrevemos e faz as alterações necessárias na infra para chegar ao estado desejado. Como podemos ver no exemplo acima ele não aplica direto a configuração ele mostra novamente o plan e pede uma confirmação para executar a mudança. 

Depois de aplicar a mudança o terraform registra as informações sobre a infraestrutura no **Terraform State** - `terraform.tfstate`, isso permite que na proxima execução ele consiga descobrir se vai precisar criar novamente o recurso ou apenas alterar. Isso garante a **IDEMPOTENCIA** que já discutimos anteriormente.

Se executarmos `terraform apply` novamente teriamos a saída: 

```
No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

### Trabalhando com variaveis

Variáveis servem para evitar que deixemos valores fixos diretamente no código. Em vez de escrever um valor diretamente no recurso, podemos criar uma variável e passar o valor para ela. Imagine o seguinte: 

```
resource "local_file" "foo" {
    filename = "exemplo.txt"
    content = "texto"
}
```

Aqui `texto` está fixo no código. Poderiamos criar a variavel: 

```
variable "conteudo" {}
```

e referenciá-la no recurso usando o prefixo `var.`:

```
resource "local_file" "foo" {
    filename = "exemplo.txt"
    content = var.conteudo
}
```

Podemos também criar um arquivo `variables.tf` que vai reunir todas as variaveis da infraestrutura, e assim podemos reutilizar variaveis pelos arquivos `.tf`.

Podemos ter um arquivo de configuração `terraform.tfvars` que mantem o valor de todas as variaveis: 

```
conteudo = "valor da variavel conteudo"
```

Variaveis também possuem tipagem no terraform: 

```
variable "instancias"{
	description = "Numero de intancias"
	type = number
	default = 2
}
```

Tambem é possivel passar valores para variaveis por linha de comando:

```bash
export TF_VAR_conteudo="veio de um ambiente"
```

Outra opção é passar uma variavel quando estamos fazerndo um `apply`: 

```
terraform apply -var "conteudo=xpto"
```

### Outputs

Os **outputs** servem para mostrar informações que saem do Terraform. Vamos imaginar uma situação em que toda vez que a gente faz a alteração de um arquivo, o terraform cria ele novamente. Toda vez q ele cria esse arquivo novamente é gerado um ID desse arquivo. 

O output pode nos trazer as informações fornecidas durante a criação dos arquivos: 

```
output "id-arquivo" {
	value = resource.local_file.foo.id
}
```

Saída: 

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

id-do-foo = "4ff6edb56042781e214f2b5e5a5f5a0db7a11d19
```

Muitas vezes precisamos criar uma infraestrutura muito grande, temos muitos valores. Vamos imaginar que o Terraform criou uma máquina virtual na AWS. Durante a criação, a AWS pode fornecer informações como: 

- IP público
- ID da máquina
- DNS
- ID de uma rede

Pode ser que seja necessário acessar essas informações depois. E ai que entra o output. Exemplo: 

```
output "ip_publico" {
	value = aws_instance.servidor.public_ip
}
```

### Data sources

Muitas vezes a informação que precisamos pra continuar provisionando a infra já existe. Como conseguimos consultar a infra pra pegar essa informação para reutilizar?

Geralmente todo provider disponibiliza um *data source* e podemos utilizar ele para pegar informações.

> Um resource gerencia algo. Um data source consulta algo que já existe.

Supondo que uma VPC já exista na AWS e precisamos descobrir o ID dela para usar em outro recurso. Poderiamos fazer:

```
data "aws_vpc" "principal" {
	tags = {
		Name = "minha-vpc"
	}
}
```

Então podemos acessar o id: 

```
data.aws_vpc.principal.id
```

Isso é util por que conseguimos consultar recursos já existentes  e usar as informações no nosso codigo terraform, sem necessáriamente geranciá-los. 