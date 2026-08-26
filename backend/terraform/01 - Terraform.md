# Terraform

É uma ferramenta open source, ela provisiona infraestrutura, ou sera, cria e configura recursos de infra de forma automatizada. Provisonar infra em grandes organizações é uma tarefa complexa pois em grandes empresas não temos apenas 1 ou 2 maquinas elas tem 10 mil maquinas, 100 mil maquinas, o que inviabiliza a configuração manual.

> Provisionar infraestrutura = disponibilizar os recursos necessários para uma aplicação funcionar

Sem o terraform teriamos que entrar no painel da AWS/Azure/GCP e criar cada coisa manualmente. COm o terraform, podemos descrever o que precisamos em arquivos `.tf`, e ele conversa com o provedor e cria os recursos necessários.

> **IaC** significa *Infrastructure as Code*. Em vez de configurar a infra manualmente, voce pode descrever a infraestrutura usando código. **IaC** é o conceito e Terraform é a ferramenta para aplicá-lo. 

### Idempotência

> Na matemática uma operação é idempotente quando você pode aplica-lá varias vezes e o resultado continua sendo o mesmo. O resultado de uma função: f(x) = x + 1 será sempre o mesmo para x = 2.

A ideia de idempotencia no terraform aparece quando precisamos fazer alterações em recursos já existentes. Vamos imaginar que estamos criando um recurso: 

```
crie o servidor chamado: server-01
```

Nessa primeira execução o servidor é criado. Na segunda execução desse mesmo comando o terraform verifica que o servidor já existe e está exatamente como foi pedido então ele não cira outro servidor e o estado continua igual.

### Terraform vs Ansible

Como já dito o ponto forte do terraform é o provisionamento de infraestrutura. Já o do Ansible é o gerenciamento e automação de configurações. Cada uma dessas ferramentas tem seu proposito, ambos também fazem tarefas semelhantes mas no final das contas cada uma faz uma coisa melhor que a outra. 

É muito comum que essas duas ferramentas sejam usadas em conjunto para que o ponto forte de cada uma seja explorado. Enquato o terraform provisona os nossos recursos, o ansible vem e os configura.

### Gerenciamento de estado

O terraform anota todo o estado do provisionamento feito, quando precisamos fazer uma alteração ele faz uma comparação do que exite atualmente e o que mudou. Nem sempre vamos conseguir aplicar mudanças no que ja existe, as vezes para alterar o estado de algo o elemento precisa ser destruido e criado novamente.

Quando estamos trabalhando com terraform vamos ver o plano de ação que ele vai realizar. Quando subimos uma maquina EC2, por exemplo, o terraform começa a anotar tudo em um arquivo esse arquivo tem o estado de tudo que aconteceu. Quando fazemos uma alteração em qualquer coisa nessa maquina ele faz a comparação com esse arquivo. Se não temos registro de nenhum estado atual o terraform começá a criar tudo do zero.

