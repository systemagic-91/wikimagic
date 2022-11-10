# MOCKITO

O Mockito é um framework de Test and Spy (testes unitários) e seu principal objetivo é simular a instancia de classes e o comportamento de métodos. Isso é chamado de "mock". O Mockito é uma ótima ferramenta para testar, pois a possibilidade de isolar comportamentos e testar pequenas partes é uma grande estratégia para garantir a qualidade.

Ao "mockar" a dependência de uma classe com o mockito, fazemos com que a classe que vai ser testada simule o método testado e suas dependências. Durante o mock podemos configurar retorno e ações de acordo com a necessidade do teste.

[Instalar](https://site.mockito.org/#how) o Mockito em um projeto é muito simples. E após ele estar nas dependências do nosso projeto, já se torna possível anotar suas classes e criar *mocks*.

Quando criamos testes é possível perceber o quão complexo ficou nosso código. **Geralmente, se existes muitas dependências em uma classe, significa que ela poderia ser quebrada em mais de uma. O mesmo vale para os métodos.**



##### Funções

* **Mock:** cria uma instancia de uma classe, porém Mockada. Se chamarmos um método ele não irá chamar o método real, a não ser que façamos isso. O comportamento padrão de um `@Mock` será sempre retornar nulo, ele é um objeto utilitário para verificações e simulação de retornos, exceções, entre outras coisas.
* **Spy:** cria uma instancia de uma classe, que você pode mockar ou chamar os métodos reais. É uma alternativa ao `injectMocks`, quando é preciso mockar métodos da própria classe que está sendo testada.
* **InjectMocks:** cria uma instancia e injeta as dependências necessárias que estão anotadas com `@Mock`.
* **Verify:** verifica a quantidade de vezes e quais parâmetros utilizados para acessar um determinado método.
* **When:** após um mock ser criado, você pode direcionar um retorno para um método dado um parâmetro de entrada.
* **Matchers:** permite a verificação por meio de matchers de argumentos (`abyObject(), anyString()`)
* **Given:** mesmo propósito que o *when*, porém é utilizado para BDD. Fazendo parte do BDDMockito.



##### Criando um mock

Há duas formas de criar um mock usando mockito, por meio de um método estático com ou com a anotação `@Mock`

Estático: 

`var ClientRepository = Mockito.mock(EmployeeRepository.class)`

Anotação: 

````java
@Mock
private ClientRepository clientRepository;
````



##### Configurando a classe testada

Ao declarar a classe vamos anotar ela com o `@InjectMocks`. O mockito vai criar uma instancia real dessa classe e injetar todos os objetos `@Mock` que foram declarados na classe de teste.

```java
@InjectMocks
private ClientController clientController;
```



##### Habilitando as anotações

Para que essas anotações (`@Mock` e `@InjectMocks`) funcionem, é necessário habilita-las. Existem duas formas: 

* anotando a classe de teste com `RunWhit(MockitoJUnitRunner.class)`

```java
@RunWith(MockitoJUnitRunner.class)
public class ClientControllerTest{}
```

* usando o `MockitoAnnotations.initMocks()` antes dos testes

```java
@Before
public void setup(){
	MockitoAnnotations.initMocks(this);	
}
```



##### Testando um método void

Método que será testado: 

```java
@DeleteMapping("/clients/{id}")
public void deleteClient(@PathVariable Long id) {
    repository.deleteById(id);
}
```

O teste: 

```java
@Test
public void deleteClient() {
	clientController.deleteClient(1L);
    Mockito.verify(clientRepository, Mockito.times(1)).deleteById(1L);
}
```

Primeiro chamamos o método que vai ser testado e passamos os parâmetros necessários. Em seguida usamos o `Mockito.verify` para verificar se durante a execução das classes mocadas foi chamado o método em questão. 

Podemos verificar varias coisas com `Mockito.verify` numero de vezes que executou, parâmetros recebidos e etc.

No exemplo abaixo, criamos um *mock()* de uma classe `CustomerRegister` para testar o comportamento do método `validateRealCpf` . Evidentemente, teremos um resultado positivo, independente do valor que for passado para ser validado. Isso ocorre porque eu utilizamos o `when()`.

```java
@Test
public void validate_cpf_success() {
    customerRegister = mock(CustomerRegister.class);
    when(customerRegister.validateRealCpf(anyString())).thenReturn(true);
    Assert.assertTrue(customerRegister.validateRealCpf("8888"));
}
```

Agora, se chamarmos o método real, utilizando o `thenCallRealMethod()` do Mockito, o teste falha. Porque o CPF informado é inválido, e o teste passou pelo método `validateRealCpf()` de fato.

```java
@Test
public void shouldReturnFalseToInvalidateCpf() {
    customerRegister = mock(CustomerRegister.class);
    when(customerRegister.validateRealCpf(anyString())).thenCallRealMethod();
    Assert.assertFalse(customerRegister.validateRealCpf("8888"));
}
```



##### Spy Annotation

Usamos o `@Spy` para espionar uma instância existente. No exemplo seguinte verificamos se os elementos adicionados na lista foram mesmo inseridos: 

```java
@Test
public void spyTest(){
    List<Client> clients = Mockito.spy(new ArrayList<Client>());
    
    Client c1 = new Client("Name", "address");
    Client c2 = new Client("Name", "address");
    
    clients.add(c1);
    clients.add(c2);
    
    Mockito.verify(clients).add(c1);
    Mockito.verify(clients).add(c2);
    
    assertEquals(2, clients.size());
    
    Mockito.doReturn(100).when(clients).size();
    assertEquals(100, clients.size());
}
```



* `clients.add()` - adiciona elementos a lista de clientes
* `clients.size()`- para retornar 100 em vez de 2 usando `Mockito.doReturn()`



Nesse exemplo, faremos um teste utilizando a função `Spy()/@Spy`, que possibilita *mockar* a classe que está sendo testada. Algo que não conseguimos fazer utilizando somente o `@InjectMocks`. Veja:

```java
@RunWith(MockitoJUnitRunner.class)
public class CustomerRegisterTest {

    @Spy
    @InjectMocks
    private CustomerRegister customerRegister;

    @Mock
    private CustomerRepository repository;

    @Before
    public void init() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void register_success() throws InvalidValueException {
        Customer objectSaved = new Customer("83607056072", "Silas", 123456L);

        when(customerRegister.validateRealCpf(anyString())).thenReturn(true);
        when(repository.save(any(Customer.class))).thenReturn(objectSaved);

        CustomerVO vo = new CustomerVO("83607056072", "Silas", 123456L);

        CustomerVO register = customerRegister.register(vo);
        assertEquals(objectSaved.getId(), register.getId());
        verify(customerRegister).register(vo);
    }
}
```



##### Método when

Através dele é possível simular chamadas a recursos externos a classe, como acesso a um banco de dados por exemplo, sem se preocupar como funcionará essa consulta.

A sintaxe do `when`: 

```java
@Test
public void newClientTest(){
    
    Client client = ClientTest.create();
    
    when(clientRepository.save(Mockito.any(Client.class))).thenReturn(client);
    
    ResponseEntity<Client> newClient = clientController.newClient(client);
    
    assertEquals(client.getName(), newClient.getBody().getName());
    assertEquals(client.getAddress(), newClient.getBody().getAddress());
}
```



##### InjectMocks

Podemos usar o `mock()` em outros contextos pouco mais complexos, como para obter um resultado positivo do `repository.save()` independente do que este receba como parâmetro de entrada. 

No exemplo abaixo utilizamos as anotações `@InjectMocks`, `@Mock` e `@Before` conforme codigo abaixo:

```java
@RunWith(MockitoJUnitRunner.class)
public class CustomerRegisterTest {

    @InjectMocks
    private CustomerRegister customerRegister;

    @Mock
    private CustomerRepository repository;

    @Before
    public void init() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void register_success() throws InvalidValueException {
        Customer objectSaved = new Customer("83607056072", "Silas", 123456L);

        when(repository.save(any(Customer.class))).thenReturn(objectSaved);

        CustomerVO vo = new CustomerVO("83607056072", "Silas", 123456L);

        CustomerVO register = customerRegister.register(vo);
        assertEquals(objectSaved.getId(), register.getId());
    }
}
```



##### Verify

Alguns casos de uso do `verify()`:

* É possível fazer verificar por quantidade de interação:

```java
verify(customerRegister, times(1)).register(vo);
```

* Verificar quando não houver interação:

```java
verifyNoInteractions(repository);
```

* Verificar quando não houver outras interações além das que já verificamos, utilizar o `verifyNoMoreInteractions()`, por exemplo:

```java
@Test
public void register_success_verify() throws InvalidValueException {
    CustomerRegister customerRegister2 = mock(CustomerRegister.class);

    when(customerRegister2.validateRealCpf(anyString())).thenCallRealMethod();

    CustomerVO vo = new CustomerVO("33408777004", "Silas", 123456L);

    customerRegister2.register(vo);

    verify(customerRegister2, times(1)).register(vo);
    verifyNoMoreInteractions(customerRegister2);
}
```



##### Quando usar Mockito clássico/simples e quando usar o `@MockBean` do Spring Boot ?

Os testes unitários são projetados para testar um componente isoladamente de outros componentes e os testes unitários também têm um requisito: ser o mais rápido possível em termos de tempo de execução, pois esses testes podem ser executados diariamente dezenas de vezes nas máquinas do desenvolvedor.

Consequentemente, aqui está uma orientação simples:

Quando você escreve um teste que não precisa de nenhuma dependência do container Spring Boot, o Mockito clássico/simples é o caminho a seguir: é rápido e favorece o isolamento do componente testado.

Se o seu teste precisar contar com o contêiner Spring Boot **e** você também quiser adicionar ou simular um dos `beans` do contêiner: `@MockBean`do Spring Boot é o caminho.







https://stackoverflow.com/questions/44200720/difference-between-mock-mockbean-and-mockito-mock

https://stackoverflow.com/questions/71724227/when-to-use-and-not-use-mock-annotation-mockbean-annotation-injectmock-anno

https://www.digitalocean.com/community/tutorials/mockito-tutorial

https://inside.contabilizei.com.br/conceitos-basicos-sobre-mockito-73b931ce0c2c

https://medium.com/cwi-software/testando-seu-c%C3%B3digo-java-com-o-mockito-framework-8bea7287460a

https://medium.com/backend-habit/integrate-junit-and-mockito-unit-testing-for-controller-layer-91bb4099c2a5

https://stackoverflow.com/questions/55172843/testing-post-request-controller-with-mockito

https://dev.to/luizleite_/como-fazer-testes-unitarios-em-controllers-de-um-app-spring-boot-1bbm

https://emmanuelneri.com.br/2017/03/18/teste-de-controllers-no-spring-boot/

https://www.youtube.com/watch?v=A4Gp5du8wKE&ab_channel=Alex-JDevTreinamentoon-line

https://www.youtube.com/watch?v=HRNUVbnkU7g&ab_channel=Jean
