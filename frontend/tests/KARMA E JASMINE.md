# Karma e Jasmine

Um componente, ao contrário de todas as outras partes de um aplicativo Angular, combina um modelo HTML e uma classe TypeScript. O componente é verdadeiramente o modelo e a classe *trabalhando juntos* . Para testar adequadamente um componente, você deve testar se eles funcionam juntos conforme o esperado.

Esses testes requerem a criação do elemento host do componente no DOM do navegador, como faz o Angular, e a investigação da interação da classe do componente com o DOM conforme descrito por seu modelo.

O Angular `TestBed`facilita esse tipo de teste, como você verá nas seções a seguir. Mas, em muitos casos, *testar apenas a classe do componente*, sem o envolvimento do DOM, pode validar muito do comportamento do componente de maneira direta e mais óbvia.

#### Teste de classe

O teste de classe de componente deve ser mantido muito limpo e simples. Ele deve testar apenas uma única unidade. À primeira vista, você deve ser capaz de entender o que o teste está testando.

Considere isso `LightswitchComponent`, que liga e desliga uma luz (representada por uma mensagem na tela) quando o usuário clica no botão.

```typescript
@Component({
  selector: 'lightswitch-comp',
  template: `
    <button type="button" (click)="clicked()">Click me!</button>
    <span>{{message}}</span>`
})
export class LightswitchComponent {
  isOn = false;
  clicked() { this.isOn = !this.isOn; }
  get message() { return `The light is ${this.isOn ? 'On' : 'Off'}`; }
}
```

Você pode decidir apenas testar se o `clicked()`método alterna o estado de *ligado/desligado* da luz e define a mensagem apropriadamente.

Esta classe de componente não tem dependências. Para testar esses tipos de classes, siga as mesmas etapas de um serviço sem dependências:

1. Crie um componente usando a palavra-chave new.
2. Cutuque sua API.
3. Afirmar expectativas sobre seu estado público.

```typescript
describe('LightswitchComp', () => {
  it('#clicked() should toggle #isOn', () => {
    const comp = new LightswitchComponent();
    expect(comp.isOn)
      .withContext('off at first')
      .toBe(false);
    comp.clicked();
    expect(comp.isOn)
      .withContext('on after click')
      .toBe(true);
    comp.clicked();
    expect(comp.isOn)
      .withContext('off after second click')
      .toBe(false);
  });

  it('#clicked() should set #message to "is on"', () => {
    const comp = new LightswitchComponent();
    expect(comp.message)
      .withContext('off at first')
      .toMatch(/is off/i);
    comp.clicked();
    expect(comp.message)
      .withContext('on after clicked')
      .toMatch(/is on/i);
  });
});	
```

Aqui está o `DashboardHeroComponent`do tutorial  *Tour of Heroes .*

```typescript
export class DashboardHeroComponent {
  @Input() hero!: Hero;
  @Output() selected = new EventEmitter<Hero>();
  click() { this.selected.emit(this.hero); }
}
```

Você pode testar se o código da classe funciona sem criar o `DashboardHeroComponent`ou seu componente pai.

```typescript
it('raises the selected event when clicked', () => {
  const comp = new DashboardHeroComponent();
  const hero: Hero = {id: 42, name: 'Test'};
  comp.hero = hero;

  comp.selected.pipe(first()).subscribe((selectedHero: Hero) => expect(selectedHero).toBe(hero));
  comp.click();
});	
```



Quando um componente tiver dependências, talvez você queira usar o `TestBed`para criar o componente e suas dependências.

O `WelcomeComponent` seguinte depende do `UserService`saber o nome do usuário para cumprimentar.

```typescript
export class WelcomeComponent implements OnInit {
  welcome = '';
  constructor(private userService: UserService) { }

  ngOnInit(): void {
    this.welcome = this.userService.isLoggedIn ?
      'Welcome, ' + this.userService.user.name : 'Please log in.';
  }
}
```

Você pode começar criando uma simulação do `UserService`que atenda às necessidades mínimas desse componente.

```typescript
class MockUserService {
  isLoggedIn = true;
  user = { name: 'Test User'};
}
```

Em seguida, forneça e injete *o* **componente** *e o serviço* na `TestBed`configuração.

```typescript
beforeEach(() => {
  TestBed.configureTestingModule({
    // provide the component-under-test and dependent service
    providers: [
      WelcomeComponent,
      { provide: UserService, useClass: MockUserService }
    ]
  });
  // inject both the component and the dependent service.
  comp = TestBed.inject(WelcomeComponent);
  userService = TestBed.inject(UserService);
});
```

Em seguida, exercite a classe do componente, lembrando-se de chamar os [métodos de gancho de ciclo](https://angular.io/guide/lifecycle-hooks) de vida como o Angular faz ao executar o aplicativo.

```typescript
it('should not have welcome message after construction', () => {
  expect(comp.welcome).toBe('');
});

it('should welcome logged in user after Angular calls ngOnInit', () => {
  comp.ngOnInit();
  expect(comp.welcome).toContain(userService.user.name);
});

it('should ask user to log in if not logged in after ngOnInit', () => {
  userService.isLoggedIn = false;
  comp.ngOnInit();
  expect(comp.welcome).not.toContain(userService.user.name);
  expect(comp.welcome).toContain('log in');
});
```

#### Teste de componente DOM



Testar a *classe de* componente é tão simples quanto [testar um serviço](https://angular.io/guide/testing-services) .

Mas um componente é mais do que apenas sua classe. Um componente interage com o DOM e com outros componentes. Os testes *somente de classe* podem informar sobre o comportamento da classe. Eles não podem dizer se o componente será renderizado corretamente, responderá à entrada e aos gestos do usuário ou se integrará com seus componentes pai e filho.

Nenhum dos testes *de classe* anteriores pode responder a perguntas importantes sobre como os componentes realmente se comportam na tela.

- `Lightswitch.clicked()` está vinculado a algo de modo que o usuário possa invocá-lo?
- O `Lightswitch.message` é exibido?
- O usuário pode realmente selecionar o herói exibido por `DashboardHeroComponent`?
- O nome do herói é exibido conforme o esperado (como letras maiúsculas)?
- A mensagem de boas-vindas é exibida pelo modelo de `WelcomeComponent`?

Estas podem não ser questões problemáticas para os componentes simples anteriores ilustrados. Mas muitos componentes têm interações complexas com os elementos DOM descritos em seus modelos, fazendo com que o HTML apareça e desapareça conforme o estado do componente muda.

Para responder a esses tipos de perguntas, você deve criar os elementos DOM associados aos componentes, deve examinar o DOM para confirmar se o estado do componente é exibido corretamente nos momentos apropriados e deve simular a interação do usuário com a tela para determinar se essas interações fazem com que o componente se comporte como esperado.

Para escrever esses tipos de teste, você usará recursos adicionais do `TestBed`bem como outros auxiliares de teste.



###### Testes gerados pela CLI



A CLI cria um arquivo de teste inicial para você por padrão quando você solicita a geração de um novo componente.

Por exemplo, o seguinte comando da CLI gera um `BannerComponent`na pasta `app/banner`(com modelo e estilos embutidos):

```bash
ng generate component banner --inline-template --inline-style --module app	
```

Ele também gera um arquivo de teste inicial para o componente, `banner-external.component.spec.ts`, que se parece com isto:

```typescript
import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { BannerComponent } from './banner.component';

describe('BannerComponent', () => {
  let component: BannerComponent;
  let fixture: ComponentFixture<BannerComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({declarations: [BannerComponent]}).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BannerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeDefined();
  });
});
```



###### Reduza a configuração



Apenas as últimas três linhas deste arquivo realmente testam o componente e tudo o que fazem é afirmar que o Angular pode criar o componente.

O restante do arquivo é um código clichê de configuração antecipando testes mais avançados que *podem* se tornar necessários se o componente evoluir para algo substancial.

Você aprenderá sobre esses recursos de teste avançados nas seções a seguir. Por enquanto, você pode reduzir radicalmente esse arquivo de teste para um tamanho mais gerenciável:

```typescript
describe('BannerComponent (minimal)', () => {
  it('should create', () => {
    TestBed.configureTestingModule({declarations: [BannerComponent]});
    const fixture = TestBed.createComponent(BannerComponent);
    const component = fixture.componentInstance;
    expect(component).toBeDefined();
  });
});
```

Neste exemplo, o objeto de metadados passado para `TestBed.configureTestingModule`simplesmente declara `BannerComponent`, o componente a ser testado.

```typescript
TestBed.configureTestingModule({declarations: [BannerComponent]});
```

`TestBed` configura e inicializa o ambiente para teste de unidade e fornece métodos para criar componentes e serviços em testes de unidade. `TestBed`é a API principal para escrever testes de unidade para aplicativos e bibliotecas Angular.



###### `createComponent()`



Depois de configurar `TestBed`, você chama seu `createComponent()`método.

```typescript
const fixture = TestBed.createComponent(BannerComponent);
```

`TestBed.createComponent()`cria uma instância do `BannerComponent`, adiciona um elemento correspondente ao DOM do executor de teste e retorna um [`ComponentFixture`](https://angular.io/guide/testing-components-basics#component-fixture).

> Não reconfigure `TestBed`depois de chamar `createComponent`.
>
> O método`createComponent` congela a  definição`TestBed` atual, fechando-a para configuração posterior.
>
> Você não pode chamar mais nenhum método de configuração `TestBed`, `configureTestingModule()`nem , nem `get()`, nem nenhum dos métodos `override...`. Se você tentar, `TestBed`lança um erro.



###### `ComponentFixture`



O [ComponentFixture](https://angular.io/api/core/testing/ComponentFixture) é um equipamento de teste para interagir com o componente criado e seu elemento correspondente. Uma fixture para depurar e testar um componente.

Acesse a instância do componente por meio do acessório e confirme se existe com uma expectativa Jasmine:

```typescript
const component = fixture.componentInstance;
expect(component).toBeDefined();
```



###### `beforeEach()`



Você adicionará mais testes à medida que esse componente evoluir. Em vez de duplicar a configuração `TestBed` para cada teste, você refatora para colocar a configuração em um Jasmine `beforeEach()`e algumas variáveis de suporte:

```typescript
describe('BannerComponent (with beforeEach)', () => {
  let component: BannerComponent;
  let fixture: ComponentFixture<BannerComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({declarations: [BannerComponent]});
    fixture = TestBed.createComponent(BannerComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeDefined();
  });
});	
```

Agora adicione um teste que obtém o elemento do componente `fixture.nativeElement`e procura o texto esperado.

```typescript
it('should contain "banner works!"', () => {
  const bannerElement: HTMLElement = fixture.nativeElement;
  expect(bannerElement.textContent).toContain('banner works!');
});
```



###### `nativeElement`

O valor de `ComponentFixture.nativeElement`tem o tipo `any`. Mais tarde, você encontrará o `DebugElement.nativeElement`que também tem o tipo`any`.

Angular não pode saber em tempo de compilação que tipo de elemento HTML `nativeElement`é ou se é um elemento HTML. O aplicativo pode estar sendo executado em uma *plataforma sem navegador* , como o servidor ou um [Web Worker](https://developer.mozilla.org/docs/Web/API/Web_Workers_API), onde o elemento pode ter uma API reduzida ou não existir.

Os testes neste guia foram projetados para serem executados em um navegador, portanto, um valor `nativeElement` sempre será uma `HTMLElement`ou uma de suas classes derivadas.

Sabendo que é `HTMLElement`algum tipo, use o HTML padrão `querySelector`para se aprofundar na árvore de elementos.

Aqui está outro teste que chama `HTMLElement.querySelector`para obter o elemento de parágrafo e procurar o texto do banner:



```typescript
it('should have <p> with "banner works!"', () => {
  const bannerElement: HTMLElement = fixture.nativeElement;
  const p = bannerElement.querySelector('p')!;
  expect(p.textContent).toEqual('banner works!');
});
```



###### `DebugElement`



*A fixação* Angular fornece o elemento do componente diretamente através do arquivo `fixture.nativeElement`.

```typescript
const bannerElement: HTMLElement = fixture.nativeElement;
```

Na verdade, esse é um método de conveniência, implementado como `fixture.debugElement.nativeElement`.

```typescript
const bannerDe: DebugElement = fixture.debugElement;
const bannerEl: HTMLElement = bannerDe.nativeElement;
```

Há uma boa razão para esse caminho tortuoso até o elemento.

As propriedades do `nativeElement`dependem do ambiente de tempo de execução. Você pode estar executando esses testes em uma plataforma *sem navegador* que não possui um DOM ou cuja emulação de DOM não oferece suporte à `HTMLElement`API completa.

Angular depende da abstração `DebugElement` para funcionar com segurança em *todas as plataformas suportadas* . Em vez de criar uma árvore de elementos HTML, o Angular cria uma árvore `DebugElement` que agrupa os *elementos nativos* para a plataforma de tempo de execução. A propriedade`nativeElement` desdobra `DebugElement`e retorna o objeto de elemento específico da plataforma.

Como os testes de amostra deste guia foram projetados para serem executados apenas em um navegador, a `nativeElement`nesses testes é sempre um `HTMLElement`cujos métodos e propriedades familiares você pode explorar em um teste.

Aqui está o teste anterior, reimplementado com `fixture.debugElement.nativeElement`:

```typescript
it('should find the <p> with fixture.debugElement.nativeElement)', () => {
  const bannerDe: DebugElement = fixture.debugElement;
  const bannerEl: HTMLElement = bannerDe.nativeElement;
  const p = bannerEl.querySelector('p')!;
  expect(p.textContent).toEqual('banner works!');
});
```



###### `By.css()`



Embora todos os testes deste guia sejam executados no navegador, alguns aplicativos podem ser executados em uma plataforma diferente pelo menos parte do tempo.

Por exemplo, o componente pode renderizar primeiro no servidor como parte de uma estratégia para tornar a inicialização do aplicativo mais rápida em dispositivos mal conectados. O renderizador do lado do servidor pode não oferecer suporte à API de elemento HTML completo. Se `querySelector` não for compatível , o teste anterior poderá falhar.

O `DebugElement`oferece métodos de consulta que funcionam para todas as plataformas suportadas. Esses métodos de consulta usam uma função de *predicado* que retorna `true`quando um nó na árvore `DebugElement` corresponde aos critérios de seleção.

Você cria um *predicado* com a ajuda de uma classe `By` importada de uma biblioteca para a plataforma de tempo de execução. Aqui está a importação`By` para a plataforma do navegador:

```typescript
import { By } from '@angular/platform-browser';
```

O exemplo a seguir reimplementa o teste anterior com `DebugElement.query()`e o método do navegador `By.css`.

```typescript
it('should find the <p> with fixture.debugElement.query(By.css)', () => {
  const bannerDe: DebugElement = fixture.debugElement;
  const paragraphDe = bannerDe.query(By.css('p'));
  const p: HTMLElement = paragraphDe.nativeElement;
  expect(p.textContent).toEqual('banner works!');
});
```



Algumas observações dignas de nota:

- O método estático `By.css()` seleciona nós `DebugElement` com um [seletor de CSS padrão](https://developer.mozilla.org/docs/Web/Guide/CSS/Getting_started/Selectors).
- A consulta retorna um `DebugElement`para o parágrafo.
- Você deve desempacotar esse resultado para obter o elemento de parágrafo.

*Quando você está filtrando pelo seletor CSS e apenas testando as propriedades do elemento nativo* de um navegador , a abordagem  `By.css` pode ser um exagero.

Muitas vezes, é mais direto e claro filtrar com um método `HTMLElement`padrão como `querySelector()`ou `querySelectorAll()`.









