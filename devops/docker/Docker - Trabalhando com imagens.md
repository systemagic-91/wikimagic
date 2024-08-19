## Docker - Trabalhando com imagens 

Um dos pontos mais importantes que precisamos entender é que quando estamos trabalhando com Docker são as imagens. O [docker hub](https://hub.docker.com/) é o *container registry* do Docker, basicamente é nele que ficam guardadas todas as imagens Docker que chamamos. 

Ccomandos:

* `docker pull ubuntu`  - podemos baixar uma imagem do docker hub para o nosso registry local. 
* `docker images`  - lista as imagens que temos na nossa máquina local.
* `docker rmi php:latest` - remove a imagem com a tag latest do php 

### Criando uma imagem

Primeiro vamos criar o nosso Dockerfile. Ele é nossa "receita de bolo", é onde descrevemos os passos de tudo que precisamos.

```dockerfile
FROM nginx:latest
RUN apt-get update
RUN apt-get install vim -y
```

* `FROM nginx:latest` - define a imagem base a partir da qual a nova imagem será construída. Neste caso, a imagem base é a versão mais recente (`latest`) do Nginx, um popular servidor web.
* `RUN apt-get update` - executa uma atualização dos pacotes dentro da imagem. Ele usa o gerenciador de pacotes `apt-get` (Advanced Package Tool) do Debian/Ubuntu para atualizar a lista de pacotes disponíveis.
* `RUN apt-get install vim -y` - instala o editor de texto `vim` dentro da imagem Docker. O `-y` é um flag que diz ao `apt-get` para responder "sim" automaticamente a todas as perguntas que seriam feitas durante o processo de instalação, tornando o processo não interativo.

Para construir a imagem basta usar o comando: 

```shell
docker build -t <tag da imagem/nome da imagem:latest> .
```

* **`docker build`** - instrui o Docker a construir uma nova imagem a partir de um `Dockerfile`. Ele executa as instruções definidas no `Dockerfile` (como `FROM`, `RUN`, etc.) e cria uma imagem que pode ser usada para criar contêineres.
* **`-t`** - (abreviação de "tag") é usada para nomear e marcar a imagem que está sendo construída.

- `<nome da imagem/nome da imagem>:<latest>` -  a primeira parte é o nome que você quer dar à imagem. A segunda parte, após os dois-pontos `:`, é a tag da imagem. Normalmente, é usada para indicar a versão da imagem. A tag `latest` é frequentemente usada para indicar a versão mais recente. Exemplo completo: `meu-app:latest`. Se não for especificada uma tag, o Docker usa `latest` por padrão.
- **`.` (ponto)** - O ponto (`.`) no final do comando indica o contexto de construção, ou seja, o diretório atual. Isso significa que o Docker deve procurar o `Dockerfile` e qualquer outro recurso necessário no diretório em que o comando está sendo executado.

Após a construção desta imagem descrita no Dockerfile, teremos um contêiner que roda o Nginx e que tem o Vim instalado! 

### Comandos que podem ajudar:

```dockerfile
FROM nginx:latest
WORKDIR /the/workdir/path
RUN apt-get update && \
	apt-get install vim -y
COPY html /usr/share/nginx/html
```

* `WORKDIR` - Diretorio em que vamos trabalhar dentro do container. Por exemplo, quando subirmos a imagem o docker vai criar a pasta no caminho especificado e começaremos o trabalho a partir dela.
* `COPY <de onde> <para onde>` - Copiar um arquivo que está dentro do computador para dentro do container

### ENTRYPOINT vs  CMD