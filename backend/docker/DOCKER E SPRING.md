# Instruções para instalação do Docker no Windows 10

Para instalação é necessário ter os seguintes requisitos: 

* Um processador 64 bits com (SLAT)
* Pelo menos 4GB de RAM <S>(TENHA MAIS Q ISSO SE NÃO QUISER SOFRER COMO SE ESTIVESSE NO INFERNO)</s>
* O suporte à virtualização de hardware na BIOS deve ser habilitado no Configurações <s>Não conferi isso, assumi que ja está ativo nos nossos notes</s>
* E tem que instalar o WSL2.

"Aaaaah... como instalar o WSL2?" - vocês perguntam... Simples... abre o powershell e lança um `wsl --install` depois reinicia o PC. Qnd ele terminar de reiniciar vai aparecer um terminal com umas mensagens de configuração (demora um pouco), ai qnd terminar essa configuração será solicitado um nome de usuário e senha e pronto WSL instalado.

A distribuição Linux instalada por padrão é o Ubuntu. Tem como configurar outra distro... se vc quiser fazer isso: PROCURE COMO FAZER :)

A instalação do Docker em si não tem mistérios no <s>ruin</s>windows... é apenas: install, next, next, next, ok.



## Dockerizando a aplicação Spring + Gradle

Com o Docker podemos criar imagens executáveis das aplicações desenvolvidas. Para isso, é necessário possuir uma conta no Dockerhub, para que possamos enviar a imagem gerada para lá. [Clique aqui para criar uma conta gratuita](https://hub.docker.com/signup). 

Após criar a aplicação Sprint Boot + Gradle, devemos criar um arquivo chamado **Dockerfile** na raiz do projeto.

O conteúdo do Dockerfile deve ser o seguinte:

- **FROM** - Inicia um stage de build, nesse caso, indicamos que vamos usar a imagem do java openjdk:11
- **COPY** - Definimos quais arquivos copiar para o filesystem do container, nesse caso vamos pegar o jar que iremos gerar no próximo passo em **build/libs/**, e criarmos um jar executável chamado **app.jar**.
- **ENTRYPOINT** - Configuramos o container para rodar como um executável, passando o conjunto de instruções **java -jar app.jar**

Com isso, as instruções para gerarmos a imagem estão completas. Agora, vamos gerar o jar da nossa aplicação, executando o seguinte comando pelo terminal na raiz do projeto: **./gradlew bootjar**

Ao rodar esse comando, um jar executável da aplicação deve aparecer na pasta **build/libs** do projeto.

Com esses passos feitos podemos então gerar e etiquetar a imagem do Docker. Para isso, na pasta raiz do projeto devemos executar comando: 

`docker build -t <seu-dockerhub>/<seu-repositorio-dockerhub> .` 

Para cada instrução do `Dockerfile`, é executado um Step. E após esse comando, podemos verificar a imagem gerada na lista de imagens atraves do comando `docker images` .

Agora já podemos subir a aplicação com o docker com o seguinte comando no terminal: 

`docker run -p 8080:8080 <seu-dockerhub>/<seu-repositorio-dockerhub>`

para testar basta entrar em algum `endpoind` da sua aplicação pelo navegador.



#### Enviando a imagem para o dockerhub

Para enviarmos essa imagem para o Dockerhub, é necessário que tenhamos uma conta criada.

Feito isso, basta se logar pelo terminal no seu repositório no Dockerhub utilizando o comando 

`docker login --username seu_usuario --password sua_senha` 

Após se logar, rodamos o comando:

`docker push usuario/repo:tag`

para enviar sua imagem para o repositório no dockerhub.







---

#### Referências

[Install Docker Desktop on Windows | Docker Documentation](https://docs.docker.com/desktop/install/windows-install/)

[Instalar o WSL | Microsoft Learn](https://learn.microsoft.com/pt-br/windows/wsl/install)

[(8) Dockerizando uma aplicação Spring Boot/Gradle | LinkedIn](https://www.linkedin.com/pulse/dockerizando-uma-aplicação-spring-bootgradle-felipe-neves/?originalSubdomain=pt)

[Introdução | Docker de inicialização de primavera (spring.io)](https://spring.io/guides/topicals/spring-boot-docker/)