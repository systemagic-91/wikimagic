# ArrayList

Dentre as Collections do Java,  a `ArrayList` é a que mais aparece. A seguir um exemplo de como criar um objeto do tipo `ArrayList`.

```java
List<String> aulas = new ArrayList<>();
ArrayList<String> aulas = new ArrayList<>();
```

Ao declarar a referência a uma `ArrayList`, passamos qual o tipo de objeto com o qual ela trabalhará. Se queremos uma lista de nomes de aulas, vamos declarar `ArrayList<String>`.

```java
aulas.add("");
aulas.remove();
aulas.size();
aulas.get(0);
Collections.sort(aulas)

for(String aula : aulas){
    System.out.println(aula)
}

aulas.forEach(aula -> {
    
});
```

O `forEach` recebe um `Consumer`.



Ao criar uma lista dos nossos objetos, não conseguimos usar o método `Collections.sort()` caso nossa classe `Aula` não tenha implementado em seu corpo o método `compareTo`. Na classe String esse método vem de uma interface chamada `Comparable` do pacote `java.lang`. 

```java
public class Aula implements Comparable<Aula> {

    // ... restante do código aqui

    @Override
    public int compareTo(Aula outraAula) {
        // o que colocar aqui?
    }
}
```

Ao fazer com que nossa classe implemente a interface poderemos então definir decidir o nosso *critério de comparação* dos objetos da classe. 

Se quisermos ordenar essa lista de acordo com outro critério, uma opção é utilizar o segundo argumento que o `Collections.sort` recebe. Um comparador, representado pela interface `Comparator` do pacote `java.util`.



```java
public class NovoComparador implements Comparator<Aula>{
    @Override
    public int compare(String a1, String a2) {
        return Integer.compare(a1.length(), a2.length());
    }
}

public class Main {
    public static void main(String[] args) {
        
        Comparator<String> comparador = new NovoComparador();
        Collections.sort(aulas, comparator);
        
        //podemos fazer tambem
        aulas.sort(Comparator.comparing(Aula::getTempo));
    }
}
```



# LinkedList

O `ArrayList`, como diz o nome, internamente usa um *array* para guardar os elementos. Ele consegue fazer operações de maneira muito eficiente, como invocar o método `get(indice)`. Se você precisa pegar o décimo quinto elemento, ele te devolverá isso bem rápido. Quando um `ArrayList` é lento? Quando você for, por exemplo, inserir um novo elemento na primeira posição. Pois a implementação vai precisar mover todos os elementos que estão no começo da lista para a próxima posição. Se há muitos elementos, isso vai demorar... Em computação, chamamos isso de **consumo de tempo linear**.

Já o `LinkedList` possui uma grande vantagem aqui. Ele utiliza a estrutura de dados chamada **lista ligada**, e é bastante rápido para adicionar e remover elementos na *cabeça* da lista, isto é, na primeira posição. Mas é lento se você precisar acessar um determinado elemento, pois a implementação precisará percorrer todos os elementos até chegar ao décimo quinto, por exemplo.

```java
List<String> aulas = new LinkedList<>();
```



# HashSet

O Set é uma interface que lembra um conjunto matemático. `Set` é uma interface, não podemos usar o `new`, a implementação mais utilizada dela, o `HashSet`

```java
Set<String> alunos = new HashSet<>();  
alunos.add("Rodrigo Turini");
```

Quando estamos utilizando um *set*, não temos garantia da ordem em que os elementos vão ficar dentro desse conjunto, diferente de uma lista, que representa uma sequência de objetos um `set` é uma "sacola"  cheia de objetos, e você não sabe em que ordem eles estão.

Um `set` não aceita elementos repetidos. **Todos** os `Set` do Java garantem para nós que só haverá um objeto dentro do conjunto, nenhum outro igual. Ele ignorará todos os outros elementos iguais.

A grande vantagem de se utilizar o conjunto é a velocidade de performance, quando utilizamos métodos que procuram objetos dentro de uma coleção. O `HashSet` utiliza uma **tabela de espalhamento** para tentar fazer a busca em tempo constante, tornando a busca mais rápida.

`HashSet` implementa `Set`, que por sua vez implementa `Collection`, então podemos declarar um `HashSet` da seguinte forma:

```java
Collection<String> alunos = new HashSet<>();
```

Existe um grande problema, bastante comum ao trabalhar com conjuntos, o problema do `equals`. Olhando a documentação da interface `Collection` e indo no método `contains`, veremos que ele utiliza o método `equals`. Sabemos que a definição do `equals` usada pelo Java nem sempre é a que queremos. Por isso, precisamos reescrever o método `equals` na nossa classe `Aluno`. Para nós, dois alunos são iguais se ambos tiverem o mesmo nome, então vamos ao trabalho:

```java
@Override
public boolean equals(Object obj) {
    Aluno outroAluno = (Aluno) obj;
    return this.nome.equals(outroAluno.nome);
}
```

Ainda sim a comparação de  dois objetos Aluno ainda não funcionará.

A estrutura `Set` usa uma **tabela de espalhamento** para realizar mais rapidamente suas buscas. Cada vez que você adiciona algo dentro de um `Set` para espalhar os objetos, um número é gerado e todos os objetos que o tenham são agrupados. E ao buscar, em vez de comparar o objeto com todos os outros objetos contidos dentro do `Set` (isso daria muitas comparações), ele gera novamente o mesmo número , e compara apenas com aqueles que também tiveram como resultado esse número. Ou seja, ele compara apenas dentro do grupo de semelhança.

Esse número é gerado utilizando o método `hashCode`, por isso precisamos sobrescrevê-lo, mudando-o para quando criarmos um objeto `Aluno` com o mesmo nome, que esses objetos gerem o mesmo `hashCode` e portanto, fiquem no mesmo grupo. O espalhamento é feito para que se tenha o menor número possível de objetos dentro de um grupo.

A classe `String` do Java tem o método `hashCode` implementado, e ele já faz uma conta bem difícil, para que haja o melhor espalhamento e assim, a busca seja bastante eficiente. Então, podemos fazer com que o nosso `hashCode` devolva o `hashCode` da `String` `nome`:

```java
@Override
public int hashCode(){
    return this.nome.hashCode();
}
```

Devemos considerar a seguinte **regra**: caso você sobrescreva o método `equals`, obrigatoriamente deverá sobrescrever o método `hashCode`.