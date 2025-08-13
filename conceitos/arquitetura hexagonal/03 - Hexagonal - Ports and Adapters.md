### Hexagonal

A arquitetura hexagonal, também chamada de "Ports and Adapters" (portas e adaptadores), é uma forma de organizar uma aplicação para separar as regras de negócio da parte técnica. A ideia principal é criar limites claros entre o que é a lógica central da aplicação e os componentes externos, como banco de dados, sistemas de logs ou APIs. Isso facilita mudanças, pois você pode trocar componentes sem alterar o núcleo da aplicação. Por exemplo, se você quiser usar o serviço de armazenamento do S3 da Amazon ou o Google Cloud Storage, basta mudar o componente de armazenamento sem alterar o código principal da aplicação.

Nessa arquitetura, a aplicação fica no centro, como o núcleo que contém as regras de negócio, enquanto do lado esquerdo temos os clientes (que são as formas de acessar a aplicação, como interfaces de linha de comando, APIs REST ou mensagerias como Kafka), e do lado direito temos os sistemas que a aplicação acessa para funcionar (como bancos de dados, sistemas de cache ou leitura de arquivos).

Um ponto importante da arquitetura hexagonal é o desacoplamento. Isso significa que o núcleo da aplicação não depende diretamente de clientes ou servidores, mas sim de "portas" ou interfaces. Essas portas se conectam aos adaptadores que fazem a comunicação com o mundo externo. Por exemplo, a aplicação não interage diretamente com o banco de dados, mas com uma interface que faz a ponte entre eles. Assim, se for necessário trocar o banco de dados por outro ou até por um sistema de arquivos, isso pode ser feito sem grandes mudanças no código da aplicação.

Esse desacoplamento também facilita a migração de um sistema monolítico para microsserviços. Como os componentes estão bem separados, é mais simples dividir o sistema em partes menores. Além disso, a arquitetura hexagonal é baseada em um dos princípios do SOLID, o Princípio da Inversão de Dependência, que sugere que tanto o código de alto nível (como a lógica de negócios) quanto o de baixo nível (como a comunicação com banco de dados) devem depender de abstrações (interfaces), e não diretamente um do outro.

Essa abordagem ajuda a manter o código mais organizado e preparado para mudanças, evitando que ele fique cheio de dependências desnecessárias. A ideia é separar bem as responsabilidades e evitar acoplamentos fortes entre diferentes partes do sistema, garantindo maior flexibilidade e facilidade de manutenção.

A arquitetura hexagonal é uma forma de pensar no design de software que foca na separação e modularização do código, ajudando a criar sistemas mais robustos e fáceis de evoluir.



## Exemplo com elemento do mundo real

Imagine que sua aplicação é como uma fábrica de brinquedos. O objetivo principal da fábrica é produzir brinquedos (que, no mundo da programação, seria sua **lógica de negócios**). Essa fábrica precisa de algumas coisas para funcionar: matérias-primas (como plástico, madeira) e também de clientes que fazem pedidos. Agora, pense na **arquitetura hexagonal** como o modo de organizar essa fábrica de forma eficiente e flexível.

### A Fábrica (Lógica de Negócio)

No centro, está a fábrica, que é o coração do negócio. Ela sabe como montar os brinquedos, quais são as etapas de produção, e como entregar o resultado final. Essa fábrica não precisa saber de onde vem a matéria-prima nem quem são exatamente os clientes. Ela só precisa de uma porta de entrada para os pedidos e uma porta de saída para as entregas.

### Portas e Adaptadores

Agora, vamos pensar nas **portas** e **adaptadores**.

#### Porta de Entrada (Clientes)

Imagine que sua fábrica recebe pedidos por diferentes meios: pode ser que alguém ligue por telefone (tipo uma API REST), pode ser que um vendedor bata na porta (como uma interface gráfica), ou que um pedido chegue por carta (como uma linha de comando). Todos esses clientes estão do **lado esquerdo** da fábrica.

Agora, se você usar a arquitetura hexagonal, você não deixa o telefone ou o vendedor entrar direto na fábrica e bagunçar as coisas. Em vez disso, você tem **portas** que filtram esses pedidos e entregam para a fábrica de forma organizada. Essas portas são como interfaces que separam os clientes da fábrica em si. Assim, se amanhã o telefone quebrar e você precisar usar e-mail para receber pedidos, basta trocar o adaptador, sem mudar a fábrica.

#### Porta de Saída (Serviços Externos)

No **lado direito**, a fábrica precisa de matérias-primas (como um banco de dados ou armazenamento de arquivos) para funcionar. Ela também não se preocupa em saber de onde vêm essas matérias-primas. Tudo o que a fábrica precisa é de uma porta para receber esses materiais, seja de um depósito de plástico (banco de dados) ou de uma loja de madeira (sistema de arquivos).

Assim como na entrada, essa porta é uma interface. E o "adaptador" seria o fornecedor. Se um dia a fábrica quiser trocar de fornecedor (por exemplo, mudar o banco de dados), ela não precisa parar a produção ou reorganizar toda a fábrica. Apenas troca o adaptador por outro fornecedor, e tudo continua funcionando.

### Como Isso Facilita a Vida

Imagine agora que sua fábrica vai crescer e você decide dividir a produção em várias fábricas menores (como transformar um sistema monolítico em microsserviços). Como todas as portas e adaptadores já estão separados e organizados, essa mudança será simples. Não precisa desmontar toda a fábrica, só separar as partes e fazer com que cada fábrica nova tenha suas próprias portas e adaptadores.

Resumindo, a arquitetura hexagonal organiza sua fábrica (a aplicação) de forma que você possa trocar os adaptadores (clientes ou serviços externos) sem mudar a parte central, garantindo flexibilidade e facilidade para futuras mudanças!



## Hexagonal vs Clen vs Onion

Primeiro, as arquiteturas não ditam como você deve construir seu software, como a estrutura de pastas ou o uso de padrões específicos. Ela simplesmente sugere a separação entre o que está dentro da aplicação (lógica de negócios) e o que está fora (serviços e adaptadores).

Muitas vezes, as pessoas confundem arquitetura hexagonal com **clean architecture** e **onion architecture**. Embora todas compartilhem o mesmo princípio de separar o núcleo da aplicação das partes externas, cada uma tem suas próprias definições sobre como organizar essas camadas. A clean architecture, por exemplo, especifica quais partes devem existir, como UI e persistência.

Portanto, não trate essas arquiteturas como sinônimos. A hexagonal oferece uma visão mais livre, permitindo que você organize seu código como quiser, desde que siga o princípio de separação. Lembre-se: quanto mais desacoplada sua aplicação estiver, melhor! E sempre tenha cuidado com informações equivocadas.