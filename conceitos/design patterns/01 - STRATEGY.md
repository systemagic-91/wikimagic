O padrão de projeto **Strategy** é um padrão comportamental que permite definir uma família de algoritmos, ancapsulá-los em classes separadas e torná-los intercambiáveis sem alterar o código cliente que os utiliza.

O **Strategy** resolve o problema de múltiplas implementações de um comportamento ou algoritmo que podem variar dependendo do contexto. Em vez de usar condicionais complexas, ele separa cada comportamento em sua própria classe e permite que o cliente escolha qual comportamento usar em tempo de execução.

---

#### Exemplo Simples

Um sistema financeiro que precisa calcular um imposto sobre um valor. Considerando como exemplo os impostos: 

* ICMS
* ISS
* IPI

Sem usar o padrão **strategy**, o codigo da nossa service poderia ficar assim: 

```java
@Service
public class TaxCalculatorService {

  public BigDecimal calculate(TaxRequest taxRequest) {

    if (taxRequest.taxType().equals("ICMS"))
      return taxRequest.amount()
          .multiply(new BigDecimal(4))
          .divide(new BigDecimal(100), 2, RoundingMode.HALF_EVEN);

    if (taxRequest.taxType().equals("ISS"))
      return taxRequest.amount()
          .multiply(new BigDecimal(11))
          .divide(new BigDecimal(100), 2, RoundingMode.HALF_EVEN);

    if (taxRequest.taxType().equals("IPI"))
      return taxRequest.amount()
          .multiply(new BigDecimal(15))
          .divide(new BigDecimal(100), 2, RoundingMode.HALF_EVEN);

    throw new IllegalArgumentException("Invalid tax type");
  }
}
```

O nosso método `calculate` cresce a medida que surge a necessidade de adicionar um novo tipo de imposto no sistema, violando o princípio **OCP** (Open-Closed Principle), que diz que uma classe deve estar aberta para extensão e fechada para modificação.

O metodo também viola o principio **SRP** (Single Responsiblity Principle), pois o método faz o calculo de varios tipos de impostos diferentes.



##### Aplicando o Strategy

Primeiro criamos nossa uma interface que será a nossa estrategia: 

```java
public interface TaxTypeInterface {

  BigDecimal calculate(BigDecimal amount);
}
```

Criamos agora nossas classes para cada tipo de imposto: 

```java
public class ICMS implements TaxTypeInterface{

  @Override
  public BigDecimal calculate(BigDecimal amount) {

    return amount
        .multiply(new BigDecimal(4))
        .divide(new BigDecimal(100), 2, RoundingMode.HALF_EVEN);
  }
}
```

```java
public class IPI implements TaxTypeInterface{

  @Override
  public BigDecimal calculate(BigDecimal amount) {

    return amount
        .multiply(new BigDecimal(15))
        .divide(new BigDecimal(100), 2, RoundingMode.HALF_EVEN);
  }
}
```

```java
public class ISS implements TaxTypeInterface{

  @Override
  public BigDecimal calculate(BigDecimal amount) {

    return amount
        .multiply(new BigDecimal(11))
        .divide(new BigDecimal(100), 2, RoundingMode.HALF_EVEN);
  }
}
```

Agora integramos a interface Strategy na classe que usa o imposto: 

```java
@Service
public class TaxCalculatorStrategyService {

  private TaxTypeInterface taxType;

  public BigDecimal calculate(BigDecimal amount) {

    return this.taxType.calculate(amount);
  }

  public TaxCalculatorStrategyService setTexType(TaxTypeInterface taxType) {

    this.taxType = taxType;
    return this;
  }
}
```

Agora usamos o Strategy no cliente (controller):

```java
  @GetMapping
  public BigDecimal getTaxStrategy(@RequestBody TaxRequest request){

    TaxTypeInterface taxType;

    if (request.taxType().equals("ISS"))
      taxType = new ISS();
    else if (request.taxType().equals("ICMS"))
      taxType = new ICMS();
    else if (request.taxType().equals("IPI"))
      taxType = new IPI();
    else
      throw new IllegalArgumentException("Invalid tax type");

    return serviceStrategy
        .setTexType(taxType)
        .calculate(request.amount());
  }
```

---

#### Quando usar ?

* Quando há multiplas variações de um comportamento que podem ser encapsuladas em implementações diferentes. 
* Quando o código tem muitos condicionais repetitivos baseados em tipos ou estados
* Quando voce precisa adicionar novos comportamentos com frequencia, quem modificar o codigo existente

#### Benefícios do Strategy

1. **Segue o princípio OCP do SOLID:** Você pode adicionar novas estratégias sem modificar o código existente.
2. **Reduz a duplicação:** Cada comportamento fica isolado em sua própria classe.
3. **Promove a composição sobre a herança:** Você pode mudar o comportamento em tempo de execução.

---

#### Quando não usar

* **Se o comportamento não varia muito:** se há apenas um ou dois comportamentos possíveis, usar strategy pode ser um exagero.
* **Se o comportamento não deve ser configurável:** se as regras do algoritmo não mudam e são estáveis, o strategy introduz complexidade desnecessária.
* **Quando há necessidade de muitos parametros compartilhados:** se as estratégias compartilham muitos dados entre si, pode ser melhor usar outro padrão como template method.

---

Importante lembrar que o Strategy **NÃO RESOLVE PROBLEMAS DE IF's**. Ele resolve problemas que ferem o OCP e o SRP do SOLID.

* **OCP**: Permite adicionar novos comportamentos sem alterar o código existente.
* **SRP**: Separa o comportamento em classes diferentes, deixando cada uma com uma única responsabilidade.

No **Strategy** o uso dos `if's` não é elimidado eles são jogados para uma camada acima.