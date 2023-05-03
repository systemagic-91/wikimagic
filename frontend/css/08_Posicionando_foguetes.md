# Posicionando Foguetes

### Layouts

* Tables 
* Floats e clear
* Frameworks e Grid Systems
* Flexbox
* Grid

### Position

Controlar onde, na página, o elemento irá ficar, alterando o fluxo normal dos elementos. Lembrando que o fluxo normal dos elementos é um a baixo do outro, exceto para os elementos inline, que ficam um ao lado do outro.

O **position** indica onde o elemento vai ser posicionado na página. Ao usar o position podemos adicionar outras propriedades como top, right, bottom, left e z-index, que vão determinar o posicionamento final do elemento.

Propriedade:

* nome: `position` 
* valor: `static | relative | absolute | fixed`



#### `Relative`

Quando o position é **`relative`** os elementos são **deslocados** do seu **posicionamento normal**, mas **sem afetar** o posicionamento de outros elementos da página. Temos disponíveis 5 propriedades: `top | rigth | bottom | left | z-index`

```html
<div class="box box1"></div>
<div class="box box2"></div>
<div class="box box3"></div>
```

```css
.box {
  width: 50px;
  height: 50px;
  margin-bottom: 8px;
}

.box1 {
  background-color: red;
  position: relative;
  left: 100px;
  top: 80px
}

.box2 {
  background-color: green;
}

.box3 {
  background-color: blue;
}
```



#### `Absolute`

Quando o position é **`absolute`** o elemento é deslocado **saindo do fluxo normal**. O elemento de position `absolute` é **posicionado em relação ao seu parent element mais próximo**. Se esse elemento "pai" não existir, ele será posicionando em relação ao bloco contendo a raiz do elemento. Temos disponíveis 5 propriedades: `top | rigth | bottom | left | z-index`

```html
<div class="box box1"></div>
<div class="box box2"></div>
<div class="box box3"></div>
```

```css
.box {
  width: 50px;
  height: 50px;
  margin-bottom: 8px;
}

.box1 {
  background-color: red;
  position: absolute;
  left: 100px;
  top: 80px
}

.box2 {
  background-color: green;
}

.box3 {
  background-color: blue;
}
```



#### `Fixed`

Quando aplicado o position **`fixed`** é como se criasse um elemento flutuante que fica fixo na página, independente do scrolling feito. Temos disponíveis 5 propriedades: `top | rigth | bottom | left | z-index`



### Element Stacking (z-index)

É o empilhamento de elementos. Podemos usar o z-index para determinar a ordem da posição do elemento. Quanto maior o z-index, mais "acima" vai aparecer o elemento.

```html
<div class="box box1"></div>
<div class="box box2"></div>
<div class="box box3"></div>
```

```css
.box {
  width: 50px;
  height: 50px;
  margin-bottom: 8px;
}

.box1 {
  background-color: red;
  position: absolute;
  left: 5px;
  top: 5px;
  z-index: 3;
}

.box2 {
  background-color: green;
  position: absolute;
  left: 10px;
  top: 10px
}

.box3 {
  background-color: blue;
  position: absolute;
  left: 15px;
  top: 15px
}
```



### Flex

#### Flexbox

- Nos permite posicionar os elementos dentro da caixa
- Conseguimos controlar em uma dimensão (horizontal ou vertical)
- Conseguimos controlar alinhamento, direcionamento, ordenar e tamanhos

#### Flex-direction

- Qual a direção do flex: horizontal ou vertical
- row | column

#### Alinhamento

- justify-content
- align-items

```html
<div class="container">
  <div class="box blue"></div>
  <div class="box red"></div>
  <div class="box green"></div>
</div>
```

```css
body{
    height: 100vh;
    margin: 0;
    display: flex;
    align-items: center;
}
.container {
    width: 100vh;
    display: flex;
    justify-content: center;
}
.box {
    width: 50px;
    height: 50px;
    margin-bottom: 8px;
}

.blue {
    background-color: blue;
}

.red {
	background-color: red;
}

.green {
    background-color: green;
}
```



### Grid

* Posicionamento dos elementos dentro da caixa
* Posicionamento horizontal e vertical ao mesmo tempo
* Pode ser flexível ou fixo
* Cria espaços para os elementos filhos habitarem

```html
<body>
    <header>Topo</header>
    <main>Conteúdo</main>
    <aside>Infos adicionais</aside>
    <footer>Rodapé</footer>
</body>
```

```css
body{
    display: grid;
    margin: 0;
    height: 100vh;
    grid-template-areas: 
        "header header"
        "main aside"
        "footer footer";
    grid-template-rows: 30px 1fr 40px;
    grid-template-columns: 1fr 80px;
}

header{
    grid-area: header;
    background-color: green;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 8px;
}

main{
    grid-area: main;    
    background-color: red;
}

aside{
    grid-area: aside;    
    background-color: blue;
}

footer{
    grid-area: footer;
    background-color: gray;
}
```



**Obs**: Podemos usar o `Grid` e o `Flex` juntos. Mas não no mesmo elemento