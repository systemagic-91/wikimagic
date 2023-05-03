# SOLID

Os princípios do SOLID estão diretamente ligados com coesão, encapsulamento e acoplamento.


###### Classe coesa

A classe a seguir é responsável apenas por representar Funcionários e executa tarefas relacionadas apenas a isso.

```java
class Funcionario{	
    String nome;
    String cpf;
    Cargo cargo;
    BigDecimal salario;
}

public boolean isGerente(){
    return Cargo.GERENTE == this.cargo;
}
```



###### Classe NÃO coesa

Essa classe é responsável representar Funcionários e Endereços, o que faz com que essa seja maior que a anterior e que execute tarefas relacionadas a duas entidades.

```java
class Funcionario{	
    String nome;
    String cpf;
    Cargo cargo;
    BigDecimal salario;
    String cep;
    String logradouro;
    String bairro;
    String cidade;
    String uf;
}

public void formatarCPF(){
}

public void formatarCEP(){
}

public void completarEndereco(){
}
```

Classes não coesas tendem a crescer indefinidamente, o que as tornam difíceis de manter.


###### Encapsulamento

Nada mais é do que proteger uma classe contra manipulações externas que podem prejudicar a consistência das informações.

Abaixo salário é um atributo importante, ele tem validações, ele tem regras de negócio. Eu não posso alterar o salário de qualquer maneira, existem validações.

```java
public class Funcionario {

    private String nome;
    private String cpf;
    private Cargo cargo;

// double apenas para fins didáticos
    private double salario;

    public void reajustarSalario(double aumento) {
        double percentualReajuste = (aumento / salario) * 100;

        if (percentualReajuste > 40) {
            throw new IllegalArgumentException(
                "percentual de reajuste deve ser inferior a 40%";
        }

        this.salario += aumento;
    }
}
```

Um exemplo ruim que seria um exemplo clássico de você somente chegar na classe e colocar os atributos como `private` e gerar os métodos `getters` e `setters`.

Classes não encapsuladas permitem violação de regras de negócio, além de aumentarem o acoplamento.


###### Acoplamento

A ideia de você acoplar é quando você tem dois componentes que estão interligados entre si causando uma dependência entre eles. Então, por exemplo, quando eu tenho uma classe que faz a utilização de uma outra classe. Uma classe A que chama uma classe B. O fato da classe A estar utilizando a classe B, isso já gera um acoplamento.

Classes acopladas causam fragilidade no código da aplicação, o que dificulta na sua manutenção.



### Single Responsibility Principle



"Uma classe deveria ter apenas um único motivo para mudar" - Robert Martin

O foco desse princípio é justamente em coesão. Quando aplicamos esse princípio da responsabilidade única, estamos focando em manter uma alta coesão no nosso código, estamos pensando em deixar as classes pequenas, enxutas e deixá-las com bastante coesão para que assim elas tenham realmente um único motivo para mudar. Então eu consigo sempre que for fazer uma alteração no meu projeto, mexer em um único ponto do sistema.


### Open Closed Principle




"Entidades de software (classes, módulos, funções, etc.) devem estar abertas para extensão, porém fechadas para modificação" - Bertrand Meyer

Então quanto menos mexermos, modificarmos uma classe, melhor, porque mais estável ela vai ficar, menos *bugs* corremos o risco de introduzir no software. Porém vamos precisar alterar o software, nós vamos precisar adicionar novas funcionalidades, novas validações, novos algoritmos, regras, enfim. Então precisamos escrever o código de uma maneira que nós também não o deixe engessado, que não possamos mexer e não possamos adicionar mais nada, ele esteja fechado, uma caixa-preta.



### Liskov Substitution Principle



"Se `q(x)` é uma propriedade demonstrável dos objetos `x` de tipo `T`, então `q(y)` deve ser verdadeiro para objetos y de tipo `S`, onde `S` é um subtipo de `T`" - Barbara Liskov

Esse princípio é importante porque garante que a hierarquia de classes seja bem definida, evitando que as subclasses possam quebrar a funcionalidade da classe pai, mantendo a consistência e a estabilidade do sistema. Isso significa que qualquer método que funciona com a classe base também deve funcionar com as subclasses sem que o comportamento do programa seja afetado.

Em resumo, o princípio de Liskov ajuda a garantir que as classes herdeiras não alterem o comportamento esperado das classes pai e, portanto, é um princípio fundamental para escrever sistemas orientados a objetos robustos e escaláveis.



### Interface Segregation Principle



"Uma classe não deveria ser forçada a depender de métodos que não utilizará." - Robert Martin

O ISP estabelece que uma classe cliente não deve ser forçada a implementar métodos que ela não usa. Em vez disso, as interfaces devem ser projetadas de forma a atender às necessidades específicas de cada classe cliente, evitando assim interfaces genéricas que incluam mais métodos do que os necessários.

Por exemplo, suponha que exista uma interface genérica chamada `IRepository` que inclui métodos como `Add()`, `Update()` e `Delete()`. Uma classe cliente que só precisa adicionar dados em um repositório, pode implementar a interface completa, mesmo que não precise dos métodos de atualização e exclusão. Em vez disso, uma melhor abordagem seria criar interfaces específicas para cada tipo de operação, como `IAddRepository`, `IUpdateRepository` e `IDeleteRepository`.



### Dependency Inversion Principle



"Abstrações não devem depender de implementações. Implementações devem depender de abstrações." - Robert Martin

A ideia central do DIP (Dependency Inversion Principle) é que classes de alto nível não devem depender diretamente de classes de baixo nível. Em vez disso, ambas as classes devem depender de abstrações, ou seja, interfaces ou classes abstratas. Isso permite que o código seja mais flexível, escalável e testável, já que as mudanças em uma classe de baixo nível não afetarão as classes de alto nível que dependem dela.

