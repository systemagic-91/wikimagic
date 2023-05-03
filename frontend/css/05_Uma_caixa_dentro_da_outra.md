# Uma caixa dento da outra



## Box Model

- Fundamental para fazer layouts para web
- Maior facilidade para aplicar o CSS

Ele é uma caixa retangular que possui propriedades de uma caixa 2D

- `Tamanho (largura x altura)` - width | heigth
- `Conteudo` - content
- `Bordas` - border
- `Preenchimento interno` - padding
- `Espaços fora da caixa` - margin

Cada elemento em uma página será considerado uma caixa.



## Box Sizing

É o responsável pelo calculo do tamanho total da caixa. 

```html
<div>
	CSS é incrível!
</div>
```

```css
div {
   width: 100px; 
   height: 100px;
   border: 1px solid red;
   margin: 10%;
}
```

Quando o padding é adicionado (`padding: 0 20px;`) faz com que aumente a largura da caixa, deixando de respeitar os `100px` de largura:

```css
div {
   width: 100px; 
   height: 100px;
   border: 1px solid red;
   margin: 10%;
   padding: 0 20px;
}
```

Por padrão o navegados vai calcular o tamanho da caixa pelo `content-box` e vai somar com os outros boxes. Então no exemplo acima a caixa vai ficar com uma largura de 140px. Para que isso não aconteça, é possível mudar qual vai ser a referencia para o calculo do tamanho da caixa adicionando a propriedade `box-sizing: border-box;`. 

Dessa forma o elemento vai ficar com a largura determinada, 100px.

```css
div {
   width: 100px; 
   height: 100px;
   border: 1px solid red;
   margin: 10%;
   padding: 0 20px;
   box-sizing: border-box;
}
```

Normalmente usa-se o código abaixo como forma de "resetar" o box-sizing que vem por padrão nos navegadores.

```css
* {
   box-sizing: border-box;
}
```



## display: block vs display: inline

- Como as caixas  se comportam em relação as outras caixas
- Comportamento externo das caixas

| `block`                                                      | `inline`                                               |
| ------------------------------------------------------------ | ------------------------------------------------------ |
| Ocupa toda a linha, colocando o próximo elemento abaixo desse | Elemento um ao lado do outro na mesma linha            |
| width e heigth são respeitados                               | width e heigth são respeitados                         |
| padding, margin, border irão funcionar normalmente           | somente valores horizontais de margin, paddin e border |



## Margin

Espaços entre os elementos.

- `margin-top` |  `margin-rigth` |  `margin-bottom` |  `margin-left`
- values: `<length>` | `<percentage>` | auto

```css
div{
    /*shorthand*/
    margin: 12px 15px 10px 4px;
    margin: 12px 16px 0; /*cima laterais baixo*/
    margin: 12px 16px; /*cima baixo*/
    margin: 12px;    
}
```

obs: ter cuidado com `margin collapsing` (top se junta ao bottom)



## Padding

Preenchimento interno da caixa.

- `padding-top` |  `padding-rigth` |  `padding-bottom` |  `padding-left`
- values: `<length>` | `<percentage>` | auto

```css
div{
    /*shorthand*/
    padding: 12px 15px 10px 4px;
    padding: 12px 16px 0; /*cima laterais baixo*/
    padding: 12px 16px; /*cima baixo*/
    padding: 12px;    
}
```

obs: padding poderá causar diferenças na largura de um elemento (box-sizing pode resolver isso).



## Border e outline

São as bordas da caixa.

- values: `<border-style>` | `<border-width>`| `<border-color>`
  - `style`: solid | dotted | dashed | double | groove | ridge | inset | outset
  - `width`: `<length>`
  - `color`: `<color>`

```css
div {
	/* shorthand */
	border-top: solid 2px; /* top | right | bottom | left */

	/* style */
	border: solid;

	/* width <length> | style */
	border: 2px dotted;

	/* style | color */
	border: outset #f33;

	/* width | style | color */
	border: medium dashed green;

}
```

obs: o `border` por padrão adiciona o tamanho da borda ao tamanho da caixa. Podemos usar o `box-sizing: border-box` para resolver.

O **`outline`** é muito semelhante ao `border`, mas difere em 4 sentidos:

- Não modifica o tamanho da caixa, pois não é parte do `Box Model`
- Poderá ser diferente de retangular
- Não permite ajuste individuais
- Mais usado pelo `user agent` para acessibilidade