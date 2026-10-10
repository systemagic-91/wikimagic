# Criando cluster Kubernetes

Kubernates (K8s) é uma ferramenta que gerencia aplicações que estão rodando em containers. Num contexto onde uma organização tem **centenas de containers** se torna necessário algo que possa cuidar deles: 

- iniciar containers
- parar containers
- reiniciar containers que deram problema
- distribuir containers entre servidores
- criar mais cópias quando há muito acesso (escalar)
- substituir containers que falharam
- fazer atualizações
- descobrir onde cada aplicação está rodando

Para isso podemos usar o kubernates. Ele é como um gerente dos containers. Podemos dizer: "quero que minha aplicação tenha 3 instancias rodando". O kubernates tenta manter esse estado e se algo acontecer e uma cópia falhar ele cria/substitui o que for necessário para voltar ao estado desejado.

O Terraform e o Kubernetes podem trabalhar juntos: **O Terraform pode criar a infra necessária para um cluster Kubernates, enquanto o Kubernates gerencia as aplicações que rodam dentro desse cluster.**

### Conceitos de VPC na AWS

A *VPC* é uma rede que somente a organização tem acesso, é uma nuvem **privada** virtual, uma rede isolada **dentro da AWS** que pertence somente a sua conta/organização. 

Quando criamos uma VPC podemos escolher o intervalo de endereços IP que vai ser usado lá dentro. Isso é feito com a notação CIDR: 

```
VPC : 10.0.0.0/16
```

Esse `/16` significa que teremos cerca de 65 mil endereços disponiveis (de `10.0.0.0` até `10.0.255.255`). É como comprar um terreno grande e poder decidir como será a divisão dos lotes.

Dentro dessa rede podemos configurar *sub-redes* (subnets) com diferentes zonas de disponibilidade. A subnet e uma **fatia da VPC**. Podemos pegar um intervalo grande de IPs e dividir em pedaços menores cada um com uma função diferente. É como se dividissemos um condomínio em area da quadra, area da piscina, area residencial, area da administração, etc.

Exemplo real de divisão:

| Subnet             | Faixa de IP   | Função                                                   |
| ------------------ | ------------- | -------------------------------------------------------- |
| subnet-publica     | `10.0.1.0/24` | Servidores acessíveis pela internet (ex.: load balancer) |
| subnet-privada-app | `10.0.2.0/24` | Sua API/aplicação (sem acesso direto da internet)        |
| subnet-privada-db  | `10.0.3.0/24` | Banco de dados (bem protegido)                           |

Cada `/24` dá cerca de 250 endereços utilizáveis.

**Por que dividir assim?** Segurança. O banco de dados não precisa ser visto pela internet, então ele fica numa subnet privada. Só a aplicação consegue conversar com ele.

Uma zona de disponibilidade (AZs) é um data center (ou grupo de data centers) **fisicamente** separado, com energia, refrigeração e rede próprias. Se um pega fogo ou fica sem energia, o outro continua fincionando. 

Se colocarmos todos os nossos servidores/aplicações em um só lugar e ele cair, nosso sistema cai. Se espalharmos em dois lugares, o outro assume.

```
VPC 10.0.0.0/16
├── Subnet A (10.0.1.0/24) → Zona de disponibilidade 1
└── Subnet B (10.0.2.0/24) → Zona de disponibilidade 2
```

Podemos colocar um servidor da nossa aplicação em cada subnet. Se a zona 1 cair, o tráfego vai para a zona 2 e os usuários nem percebem. Isso se chama **alta disponibilidade**.

Na AWS toda subnet pertence a uma zona de disponibilidade (AZ). Para ter redundancia precisamos criar várias subnets, uma em cada AZ. 

Uma VPC é **regional**: ela abrange uma região (por exemplo, `sa-east-1`, São Paulo) e suas zonas de disponibilidade (`sa-east-1a`, `1b`, `1c`), que ficam na mesma região metropolitana, a poucos quilômetros umas das outras. 

**Boa prática:** subnets públicas para o que precisa de internet, privadas para o que precisa de proteção, e pelo menos duas AZs para redundância.

##### Route Table e Internet Gateway

A route table é uma lista de regras que diz para onde o tráfego de rede deve ir, com base no endereço de IP. 

Cada máquina da VPC (o load balancer, a API, o banco) precisa mandar pacotes de dados para algum lugar. Só que **a máquina não sabe o caminho**. Ela só sabe: "quero falar com o IP `X`".

Quem decide o caminho é a **route table**. Ela é como uma **lista de instruções de trânsito**:

> "Se o destino for assim, vá por ali. Se for assado, vá por lá."

Cada linha da lista tem dois campos:

- **Destino**: para qual faixa de IPs o pacote quer ir.
- **Por onde vai**: qual caminho ele deve tomar.

![image-20261001235329156](C:\Users\rayan\AppData\Roaming\Typora\typora-user-images\image-20261001235329156.png)

**Route table da subnet pública (à esquerda):**

1. `10.0.0.0/16 → local`: "se o destino for um IP **dentro da VPC**, entrega lá dentro mesmo."
2. `0.0.0.0/0 → IGW`: "qualquer **outro** destino (ou seja, a internet) sai pelo Internet Gateway."

**Route table da subnet privada (à direita):**

1. `10.0.0.0/16 → local`: só isso. Ela consegue falar com tudo dentro da VPC, mas **não existe nenhuma linha dizendo como chegar na internet**. Sem caminho, sem saída.

É só essa faixa amarela que separa uma subnet pública de uma privada. O nome "pública" ou "privada" é só um rótulo; **o que manda é a route table**.

Imagine que alguém abre o site da empresa:

1. O pacote vem da internet e entra pelo **Internet Gateway**.
2. Chega no **load balancer** (subnet pública).
3. O load balancer precisa passar o pedido para a API, que está em `10.0.2.15`. Ele consulta a route table dele: "`10.0.2.15` está dentro de `10.0.0.0/16`? Está. Então é `local`." O pacote vai para a API sem sair da VPC.
4. A resposta volta pelo mesmo caminho.

Repare, na figura, que a API (subnet privada) **nunca fica exposta à internet**. Quem conversa com o mundo é só o load balancer.

O IGW é **a portaria do condomínio que dá acesso à rua (internet)**. Sem ele, a VPC é uma ilha: nada entra, nada sai. Ele faz duas coisas:

1. **Dá um caminho** entre a VPC e a internet, nos dois sentidos (por isso a seta no desenho vai e volta).
2. **Traduz endereços**: suas máquinas têm IPs privados (`10.0.x.x`), que não existem na internet. Para uma máquina ser alcançável de fora, ela precisa de um **IP público** (ou Elastic IP). O IGW faz a troca: pacote que sai tem o IP privado trocado pelo público, e o que volta é trocado de novo.

Alguns fatos úteis:

- **Uma VPC tem no máximo um IGW** anexado.
- Ele é **gerenciado pela AWS**: não tem servidor para você manter, não cai por falta de capacidade e não tem custo próprio.
- Ele não decide *quem* usa a internet. Isso é papel da route table.

##### Security Group - Ingress/Egress

A route table decide se **existe caminho**, e o Security Group decide se o pacote **tem permissão para passar** por ele. 

Um Security Group (SG) é um **firewall virtual colado em cada recurso** (instância EC2, load balancer, banco, task do ECS...). Ele olha cada pacote que tenta entrar ou sair e decide: pode ou não pode.

No exemplo do condomínio:

- **Route table** = a placa que mostra o caminho.
- **Internet Gateway** = a portaria do condomínio.
- **Security Group** = o **segurança na porta de cada apartamento**.

Por que ter os dois níveis? Porque saber o caminho não significa ter permissão. Mesmo que exista rota até o seu banco, o SG dele pode dizer "só abro para a API". É o que protege cada peça individualmente, mesmo que a rede em volta esteja aberta.

Ingress e egress são só duas direções, vistas **do ponto de vista do recurso protegido**:

- **Ingress** (entrada): tráfego **chegando** nele. Ex.: alguém tentando acessar a porta 443 do load balancer.
- **Egress** (saída): tráfego **saindo** dele. Ex.: a API tentando chamar um serviço externo.

Cada regra tem basicamente três campos:

| Campo                                      | Exemplo                                    |
| ------------------------------------------ | ------------------------------------------ |
| Protocolo                                  | TCP                                        |
| Porta                                      | 443, 8080, 5432                            |
| Origem (no ingress) ou destino (no egress) | `0.0.0.0/0`, `10.0.0.0/16` ou **outro SG** |

![image-20261002000735679](C:\Users\rayan\AppData\Roaming\Typora\typora-user-images\image-20261002000735679.png)

No desenho:

1. **SG-lb**: aceita entrada na porta 443 vinda de qualquer lugar (`0.0.0.0/0`), porque é a cara pública do sistema.
2. **SG-api**: aceita a porta 8080, mas **só de quem pertence ao SG-lb**. Se alguém tentar acessar a API direto, o pacote é descartado, mesmo que consiga chegar na rede.
3. **SG-db**: aceita a porta 5432, mas **só de quem pertence ao SG-api**. O banco só conversa com a API.

Esse encadeamento é a prática mais usada. Repare que a origem não é um IP, e sim **o nome de outro SG**. Isso importa pelo *porquê*: os IPs das máquinas mudam o tempo todo (autoscaling, redeploy, tasks novas no ECS). Se escrevessemos "aceita do IP `10.0.1.23`", quebraria na próxima troca. Com "aceita de quem está no SG-lb", qualquer máquina nova que entrar nesse grupo já passa automaticamente.

### Entendendo condeitos no console da AWS

