> "Atividades relacionadas a arquitetura de software são sempre de design. Entretanto nem todas as atividades de design são sobre arquitetura. O objetivo primário da arquitetura de software é garantir que os atributos de qualidade, restrições de alto nível e os objetivos do negócio, sejam atendidos pelo sistema. Qualquer decisão de design que não tenha relação com esse objetivo não é arquitetural. Todas as decisões de design para um componente que não sejam visiveis fora dele, geralmente, também não são"

### Arquitetura vs. Design: São a mesma coisa?

Quando falamos em **arquitetura de software** e **design de software**, muita gente pensa que são a mesma coisa, mas não são. Vamos usar uma comparação simples para entender isso melhor.

Imagine que você vai construir uma **casa**.

- **Arquitetura** é o plano geral da casa: quantos andares ela terá, onde serão os quartos, o banheiro, a cozinha. É o esqueleto principal, aquilo que define a estrutura de tudo.
- **Design** é como cada cômodo será decorado: a cor das paredes, os móveis, o estilo da iluminação.

Agora, na construção de software:

- A **arquitetura de software** é o plano geral do sistema, as decisões que garantem que ele vai funcionar como esperado e com qualidade. Isso envolve garantir que o sistema atenda às necessidades da empresa, que funcione bem e seja seguro.
- O **design de software** é o como você vai construir as partes internas do código, como vai organizar as classes, métodos, variáveis, e quais bibliotecas vai usar. Essas são decisões menores, que não impactam tanto o sistema como um todo.

### Como Arquitetura e Design se Relacionam?

A arquitetura e o design estão relacionados, mas nem toda decisão de design afeta a arquitetura. Por exemplo:

- Se você decide que o **sistema inteiro vai gerar logs** (registros das atividades do sistema) e esses logs devem ser salvos em um único lugar para facilitar o monitoramento, isso é uma decisão **arquitetural**.
- Mas a forma de implementar isso — como enviar esses logs (se eles serão exibidos na tela ou salvos em um arquivo) — é uma decisão de **design**.

### Decisões Arquiteturais Impactam o Design

Às vezes, quando você toma uma decisão arquitetural, isso também afeta o design. Por exemplo, se você decide que seu sistema vai funcionar com logs distribuídos (que vão para vários lugares ao mesmo tempo), você precisa ajustar o design para garantir que os logs sigam essa regra. Nesse caso, a arquitetura **influencia** o design.

### Um Exemplo Simples

Imagine que você quer pintar um quadro:

- A **arquitetura** seria você decidir o tamanho da tela, o tipo de tinta e as regras gerais para pintar (não misturar certas cores, por exemplo).
- O **design** seria como você vai misturar as cores, onde vai colocar sombras, e como vai criar os detalhes.

Ambas as coisas são importantes, mas servem para objetivos diferentes. A arquitetura cria a estrutura geral, enquanto o design cuida dos detalhes de como aquilo vai ser feito.

Resumindo a arquitetura de software está em um nível mais alto e serve para garantir que o sistema funcione bem e atenda aos objetivos do negócio. Já o design de software cuida de como as partes internas vão funcionar. Embora estejam conectadas, nem tudo que é design é arquitetura, e entender essa diferença ajuda a construir sistemas mais bem organizados e fáceis de manter.