## Docker - Introdução

Os sistemas operacionais tem diversos processos, o SO tem um processo para cada tarefa sendo executada. Namespaces é uma forma de isolar os processos. Quando falamos de containers estamos falando de processos isolados com filhos. Ou seja, temos um processo principal rodando no container e todos os processos executados nesse container são filhos desse processo principal. 

Quando um container roda é como se estivessemos enganando o SO e o conteiner age como se tudo que ele estiver rodando dentro dele é de fato o SO dele, porém ele não consegue enchergar os processos do sistema operacional em si.

Podemos ter diverssos tipos de processos:

* Pid
* User
* Network
* File system

No final o conteiner é um processo, com subprocessos, emulando um sistema operacional.

### Cgroups

Os Cgroups controlam os recursos computacionais dos containers. A ideia é que eles sejam uma "borda" que controla/isola os recursos computacionais dos processos. Podemos definir, por exemplo, que um determinado processo irá usar somente 500MG de memória e 513 de cpu_shares. Isso é importantissimo para que os processos rodando dentro dos container não acabem interferindo nos outros recursos da mesma máquina.

### File System

A ideia do File System é (no docker OFS - Overlay File System) é traballhar com camadas que trabalham de uma forma individualizada. 

Vamos imaginar que o docker é uma lanchonete que faz sanduíches de forma rápida e eficiente. As camadas do sanduíche (imagens Docker): 

* o pão de baixo é a base (uma camada de imagem base, como o Ubuntu)
* a alface é outra camada (talvez a instalação de alguns pacotes)
* o queijo é mais uma camada (algum software adicionado)
* e o pão de cima finaliza o sanduíche (a configuração final da aplicação

Cada ingradiente é uma camada separada que, quando empilhada forma o sanduíche completo. Se voltarmos outro dia e quisermos outro sanduíche, mas com alguns ingredientes diferentes, a lanchonete (Docker) não precisa refazer tudo do zero. Ela pode simplesmente usar os mesmos ingredientes que já tem (camadas compartilhadas) e só adicionar o que é diferente. Quando pedimos o sanduíche, podemos adicionar ou mudar algo na hora (como um molho extra). Essas mudanças são feitas no topo, sem alterar os ingredientes de base, que ficam intactos.

No Docker isso significa que quando um conteiner esta rodando e voce faz alterações (como criar ou modificar arquivos), essas mudanças são aplicadas em uma camada nova e temporária no topo, sem mexer nas camadas abaixo.

Trazendo o exemplo para o mundo real, podemos pensar na construção de uma aplicação web que será implantada em diversos ambientes como, dev, uat e prod. Podemos utilizar o docker para garantir que a aplicação funcione de forma consistente em todos esses ambientes. Exemplo: 

* Começamos com uma imagem base, uma distribuição linux por exemplo
* Em cima dessa base, instalamos as dependencias necessárias, como o servidor web, uma linguagem de programação e as bibliotecas específicas para a aplicação 
* Depois adicionamos o código da aplicação à imgem

Cada uma dessas etapas (base, dependencia, código) forma uma camada na imagem Docker. E quando criamos os containers para cada um dos ambientes, todos eles vão usar a mesma imagem de base e se houver uma atualização na aplicação ou em alguma dependencia, sera necessario atualizar a camada específica sem recriar toda a imagem.

Como as camadas de imagem são reutilizáveis, se executarmos vários contêineres em um mesmo servidor, eles poderão compartilhar as camadas comuns, economizando espaço em disco. Ou seja, se três contêineres usam a mesma imagem base e dependências, apenas uma cópia dessas camadas será armazenada, enquanto cada contêiner terá sua própria camada de leitura e escrita para armazenar mudanças específicas.

No caso de uma pequena mudança no código da aplicação, só será necessário atualizar a camada superior da imagem (onde o código está). Isso significa que, ao fazer o deploy de uma nova versão da aplicação, só a camada alterada é transferida e aplicada, o que torna o processo muito mais rápido e eficiente.

### Imagens 

São criadas a partir de camadas. As imagens geralmente tem um nome e uma versão. Uma imagem nada mais é do que um conjunto de dependencias encadeadas em uma arvore, que pode ser utilizada. 

As imagens tem um estado que não muda, elas são imutáveis, por isso conseguimos subir de uma forma tão rápida os containers. 

Se a imagem é imutavel como conseguimos escrever dentro dela? Quando o Docker sobe a imagem é criada uma camada, junto com a imagem, que chamamos de camada de gravação e escrita (read/write), essa é a camada onde conseguimos escrever e fazer as alterações no container que está rodando. Note que, não alteramos a IMAGEM, estamos alterando o comportamento do container atraves da camada onde podemos escrever.

### Dockerfile

É uma das formas de criar imgaens. É um arquivo declarativo onde descrevemos como será a imagem que vamos construir (buildar). A imagem principal sempre é uma imagem em branco, mas normalmente nunca partimos de uma imgaem em branco. Exemplo:

```dockerfile
FROM: ImageName
RUN: apt-get install pacote
EXPOSE: 8000
```

* `FROM: ImageName` - baixa a imagem e todas as dependencias para buildar
* `RUN: apt-get install pacote` - roda o comando na imagem baixada
* `EXPOSE: 8000` - expoe uma porta da imagem 

O Dockerfile só é usado para CONSTRUIR IMAGENS! Caso não seja necessário modificar de forma alguma a imagem, NÃO é necessário ter um Dockerfile.Toda vez que temos um Dockerfile, temos um build e a partir desse build é gerada uma **nova** imagem.

Existem duas formas de conseguir gerar imagens, uma é gerar a partir de um Dockerfile, e a outra é pegar um container **que esta rodando** escrever na camada de read/write, e quando for feito um commit uma nova imagem será gerada a partir da alteração feita na camada de read/write. Ou seja, eu terei uma nova versão da imagem.

### Image Registry

É como se fosse um repositório onde as imagens são armazenadas, todas as imagens são guardadas nesse registro, e sempre que for necessário gerar um Dockerfile, ou um novo container, as imagens vem desse registo. 

Todas as vezes que geramos uma nova imagem, a partir do Dockerfile, estamos fazendo um pull no image registry. Quando geramos o build de uma imagem estamos fazendo um push para o image registry.

### Docker Host

O Docker criou uma solucão que integra namespaces, cgroups e file system. E baseado nesses tres pontos temos o conceito de docker host.

O docker roda em um host, este fica rodando um processo, uma deamon, que disponibiliza uma API. Para existir uma comunicação com o host é necessário um `client`. Toda vez que digitamos no terminal `docker comando` esse `docker` está invocando um `client` que vai se comunicar com a API disponibilizada pela deamon do docker. O Docker client pode criar containers, rodar containers, fazer pull, push. 

O docker host também tem um `cache`, `gerenciamento de volumes`, `gerenciamendo de redes`.