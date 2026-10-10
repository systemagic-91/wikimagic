# AWS

A AWS é uma gigante da computação em nuvem que atua em varios continentes no mundo e oferecem soluçoes para diversas áreas. Ela também oferece uma grande variedade de produtos como EC2, S2, RDS, etc.

###  Gerenciamento de Identidade e Acesso (IAM)

IAM - Identity and Access Management. Em um projeto trabalhando em equipe, cada usuário ou grupo de usuários tem seu papel específico no projeto. Cada membro de uma equipe deve ter seu póprio usuario e senha de acesso com permissões distintas e bem definidas.

Usuários administradores podem criar outras contas e gerenciar usuários, grupos, politicas de acesso, papéis, etc. Por padrao o usuario root é um "deus", ou seja, tem poder total. E por padrao qualquer novo usuario é criado sem permissão alguma. Os usuarios root sao responáveis por configurar as permissões do novo usuário. 

### Serviços de Rede e Conectividade

A Virtual Private Cloud (VPC) e basicamente a sua pópria rede isolada dentro de um provedor de nuvem (AWS, GCP, Azure, etc). QUando usamos uma cloud pública, seus recursos (servidores, bancos, containers) tecnicamente compartilham a infraestrutura física com clientes de outras empresas. A `VPC` é o que isola sua rede mesmo estando dentro de uma infra compartilhada. 

É literalmente **virtual**, não é hardware dedicado, é definido por software, **private**, por que e isolada de outros clientes e cloud por que roda dentro de um provedor.

Dentro de uma VPC voce configura:

- **Faixa de IP (CIDR block)**: você define o range de endereços IP privados da sua rede, ex: `10.0.0.0/16`.
- **Subnets**: divisões dessa rede, geralmente separadas em:
  - **Públicas** — têm rota pra internet, usadas por load balancers, API gateways.
  - **Privadas** — sem acesso direto de fora, usadas por bancos de dados, serviços internos.
- **Route tables**: definem como o tráfego se move entre subnets e pra fora da VPC.
- **Security Groups / Network ACLs**: regras de firewall — o que pode entrar e sair, em quais portas.
- **Internet Gateway / NAT Gateway**: controlam como (e se) recursos internos acessam a internet.

Se formos levar um projeto para produção num provedor cloud (AWS/GCP), a VPC é uma das primeiras coisas que deve ser desenhada antes mesmo de subir o Kubernetes cluster, porque a topologia de rede afeta como o EKS/GKE se comunica com bancos gerenciados, filas, etc.
