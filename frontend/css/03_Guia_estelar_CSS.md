# Guia Estelar de CSS

## O que significa CSS?

* Cascading Style Sheet
* Código para criar estilos HTML
* HTML é a estrutura, e o CSS é a beleza
* Não é uma linguagem de programação
* É uma linguagem style shet

Exemplo:

```css
h1{
    color:blue;
}
```

## Anatomia do CSS

```css
h1{
	color:blue;
    font-size:60px;
    background:gray;
}
```

* Seletor
* Declaration
* Properties
* Property Value

## Seletores

* Conecta um elemento HTML com o CSS
* Tipos:
  * Global selector: `*`
  * Element/Type selector: `h1, h2, p, div`
  * ID selector: `#box, #container`
  * Class selector: `.red, .m-4`
  * Attribute selector, Pseudo-class, Pseudo-element, e outros

## Box model

O CSS trabalha com uma ideia de caixas, ou seja, box model. 

Box model é uma caixa retangular. Essa caixa possui as mesmas propriedades de uma caixa 2D, e tem como propriedades:

* Tamanho (largura x altura): width e heidht, respectivamente
* Conteúdo: o content
* Bordas: o border
* Preenchimento interno: o padding
* Espaços fora da caixa: a margin

Quase todo elemento de uma página é considerado uma caixa: Posicionamentos, tamanhos, espaçamentos, bordas, cores, então, em suma, elementos HTML são caixas, assim como quase tudo no CSS.

## Adicionando CSS

Começaremos pelo **inline**, que é dentro do próprio HTML, através da tag `style`, utilizada das seguintes formas:

```html
<h1 style="color: blue;">Título
	<strong style="color: red;">alo</strong>
</h1>
```

Ou na head do HTML (**tag style**), assim:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
	<style>
	h1 {
			color: blue;
			}
	
	strong {
			color: red;
			}
	</style>
</head>
```

Porém, a forma mais comum, é através da **tag link**, onde vamos linkar um documento CSS externo, um outro arquivo para nosso documento HTML, feito da seguinte forma:

```html
<link rel="stylesheet" href="style.css">
```

Neste caso, o nosso documento CSS se chama style.css e sua relação com o HTML é de stylesheet.

A última forma é através do @import, que é na verdade uma regra do CSS, portanto, deve ser usada dentro do css, ao invés de dentro do HTML, como as duas primeiras formas, e seu uso é mostrado a seguir:

```css
@import 'https://fonts.googleapis.com/css2?family=Roboto:wght@300&display=swap'
```

Não é recomendado seu uso, pois leva um pouco mais de tempo do que através da tag link, fazendo a página ficar menos responsiva, demorando mais para o carregamento da mesma.

## A Cascata (cascading)

A escolha do browser de **qual** regra aplicar, caso haja muitas regras para o mesmo elemento.

O estilo CSS é lido de cima para baixo, ou seja, caso haja algum selector com informações conflitantes, o mais embaixo é o que será atribuído (também vale para mais de 1 arquivo css o ultimo vai sobrescrever regras já definidas anteriormente).

São levados em consideração 3 fatores:

* A origem do estilo;
* A especificidade;
* A importância;

### Origem do estilo:

inline > tag style > tag link

O inline tem mais força que uma tag style. E a tag style por sua vez tem mais força que uma tag link.

### Especificidade

É um cálculo matemático, onde, cada tipo de seletor e origem do estilo, possuem valores a serem considerados.

| Valor (Força) | Seletor                                                      |
| :-----------: | ------------------------------------------------------------ |
|       0       | Universal selector, combinators e negation pseudo-class (:not()) |
|       1       | Element type selector e peseudo-elements (::before, ::after) |
|      10       | Classes e attribute selectors ([type="radio"])               |
|      100      | ID selector                                                  |
|     1000      | Inline                                                       |

### A regra !important

* Cuidado, evite o uso
* não é considerado uma boa prática
* quebra o fluxo natural da cascata

```css
h1{
	color: blue !important;
}
```



## At -rules

* Está relacionado ao comportamento do CSS
* Começa com o sinal de `@` seguido do identificador e valor

### Exemplos: 

```css
@import ""; /* incluir um CSS externo */

@media ""; /* regras condicionais para dispositivos */

@font-face ""; /* fontes externas */
    
@keyframes ""; /* animation */

/*------------------------------------------*/ 

@import "http://local.com/style.css";
@media(min-width:500px){
    /*rules here*/
}
@font-face{
	/*rules here*/
}
@keyframes nameofanimation{
    /*rules here*/
}
```

## Shorthand

* É uma junção de propriedades
* Segue a ideia de colocar diversas propriedades do CSS de uma maneira resumida
* É bem mais legível

```css
/* background properties */
background-color: #000;
background-image: url(image/bg.gif);
background-repeat: no-repeat;
background-position: left top;

/* background shorthands */
background: #000 url(image/bg.gif) no-repeat left top;

/* font properties */
font-style: italic;
font-weight: bold;
font-size: .8em;
line-height: 1.2;
font-family: Arial, sans-serif;

/* font shorthand */
font: italic bold .8em/1.2 Arial, sans-serif;
```

### Detalhes:

* Não irá considerar propriedades anteriores (sobrescrita)
* valores não especificados irão assumir o valor padrão 
* geralmente, a ordem descrita não importa, mas, se houver muitas propriedades com valores semelhantes, poderemos encontrar problemas

### Algumas propriedades que aceitam shorthand

![shorthands](/anotacoes/img/shorthand.png)

[Documentação Shorthands](**https://developer.mozila.org/en-US/docs/Web/CSS/Shorhand_properties**)

## Funções

* nome seguido de parenteses
* recebe argumentos

### Exemplo:

```css
@import url("http://url.com/estilo.css");

{
    color: rgb(255,0,100);        
    width: calc(100%-10px);
}
```

## Vendor Prefixes

Permitem que browsers adicionem `features` a fim de colocar em uso alguma novidade que vemos no CSS.

### Exemplo:

```css
p{
	-webkit-background-clip: text; /*Chrome, Safari, iOS e Android*/
	-moz-background-clip: text; /* Mozilla (Firefox) */
	-ms-background-clip: text; /* Internet Explorer ou Edge*/
	-o-background-clip: text; /* Opera */
}
```

### Consultas 

Consultar se a feature pode ser utilizada através dos sites:

[Which Vendor Prefix](http://ireade.github.io/which-vendor-prefix)

[Caniuse](http://caniuse.com/)

