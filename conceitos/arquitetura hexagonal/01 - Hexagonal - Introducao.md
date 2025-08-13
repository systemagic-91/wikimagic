Imagine que você está montando um **sanduíche**. O objetivo é criar um lanche delicioso, com ingredientes escolhidos por você. Agora, pense que os ingredientes, como o pão, queijo e presunto, são a **complexidade de negócio** — eles representam o que realmente importa para o cliente, ou seja, o que você está entregando. A forma como você prepara esses ingredientes, como o tipo de faca que usa ou o prato em que serve, é a **complexidade técnica** — o jeito que você escolhe para montar o sanduíche.

### O que é a Complexidade de Negócio e a Complexidade Técnica?

1. **Complexidade de negócio:**
   Imagine que você está fazendo o sanduíche para uma pessoa que quer um lanche específico. Ela quer um sanduíche de presunto e queijo, e isso é o que você precisa entregar. O problema aqui é **resolver o pedido da pessoa** — garantir que o sanduíche tenha exatamente o que ela pediu, com o sabor e as combinações corretas. Esse é o seu objetivo principal, e essa é a **complexidade de negócio**. No software, isso seria equivalente a resolver o problema central, como calcular as parcelas de um empréstimo ou gerenciar o estoque de um supermercado.
2. **Complexidade técnica:**
   Agora, pense nas ferramentas e métodos que você vai usar para fazer o sanduíche. Você pode usar uma faca comum ou uma faca elétrica, pode tostar o pão em uma sanduicheira ou em uma frigideira. Essas são **decisões técnicas** que você toma para preparar o sanduíche. Elas não mudam o pedido, mas afetam como você vai entregá-lo. No desenvolvimento de software, isso seria como escolher um framework, um banco de dados, ou a forma de comunicação da sua aplicação (como APIs ou microsserviços). É uma complexidade que **você mesmo cria** ao escolher como implementar a solução.

### Separar essas duas complexidades

Agora, imagine que você decida que, para todos os seus sanduíches, vai usar uma sanduicheira muito específica. O problema é que, se essa sanduicheira quebrar ou sair de linha, você teria que refazer toda a sua cozinha para conseguir fazer o mesmo sanduíche. Isso é o que acontece no software quando misturamos a lógica de negócio com as ferramentas técnicas. Se tudo estiver muito dependente da "ferramenta" (framework, banco de dados, etc.), qualquer mudança técnica pode bagunçar o sistema inteiro.

### A Solução: Arquitetura Hexagonal

A **arquitetura hexagonal** ajuda a evitar essa confusão. Ela funciona como se você estivesse separando a receita do sanduíche (o que o cliente pediu) das ferramentas que você usa para prepará-lo. No caso do software, você separa o **coração do problema de negócio** (como calcular as parcelas de um empréstimo) da forma **como você faz isso tecnicamente** (qual framework, banco de dados ou protocolo de comunicação vai usar).

Se você conseguir manter essa separação, será muito mais fácil trocar as "ferramentas". Se a sua "sandwicheira" quebrar, você pode usar uma frigideira, um forno ou qualquer outra coisa, sem precisar mudar a receita. No software, isso significa que você pode trocar de framework, banco de dados ou qualquer outra tecnologia sem precisar mexer no núcleo da sua lógica de negócio.

### Por que isso facilita o desenvolvimento?

Quando você separa a lógica de negócio da complexidade técnica, o código fica muito mais fácil de manter e modificar. Se precisar mudar de ferramenta, você não precisa reescrever tudo do zero. Isso torna o software mais flexível e adaptável às mudanças tecnológicas, além de garantir que o foco continue sendo **resolver o problema do cliente** de forma eficiente.

### Pontos importantes sobre arquitetura

* Crescimento sustentável
* Software precisa se pagar ao passar do tempo
* Software deve ser desenhado por você e não pelo seu framework
* Peças precisam se encaixar e eventualmente serem substituídas

Arquitetura diz respeito ao futuro do software!
