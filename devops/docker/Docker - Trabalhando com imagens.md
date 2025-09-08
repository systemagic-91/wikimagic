## Docker - Trabalhando com imagens 

Um dos pontos mais importantes que precisamos entender é que quando estamos trabalhando com Docker são as imagens. O [docker hub](https://hub.docker.com/) é o *container registry* do Docker, basicamente é nele que ficam guardadas todas as imagens Docker que chamamos. 

Comandos:

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

### ENTRYPOINT vs CMD

* O **CMD** define o **comando padrão** que vai rodar quando o container for iniciado.
* Ele **pode ser sobrescrito** facilmente quando você roda `docker run ...`.

Exemplo:

```dockerfile
FROM ubuntu:latest
CMD ["echo", "Hello World"]
```

Se buildarmos e rodarmos: 

```bash
docker build -t teste-cmd
docker run teste-cmd
```

A saída será: 

```bash
Hello World
```

Mas se rodarmos: 

```bash
docker run teste-cmd echo "Outro comando"
```

Teremos como saída:

```bash
Outro comando
```

Ou seja `CMD` é só um padrão, vc pode trocar na hora de rodar o container.

* O **ENTRYPOINT** define o **programa principal** do container.
* Tudo o que você passar no `docker run ...` será tratado como **argumento para o ENTRYPOINT**.
* É mais "fixo": não substitui fácil como o CMD.

```dockerfile
FROM ubuntu:latest
ENTRYPOINT ["echo", "Hello"]
CMD ["World"]
```

Se rodarmos: 

```bash
docker run teste-cmd echo "Charllote"
```

Teremos como saída:

```bash
Hello Charllote
```

### Publicando imagem  no DockerHub

Se eu quiser que outra pessoa possa baixar e executar uma imagem no computador dela precisaremos pegar a imagem que foi criada e subir em algum local para que a pessoa tenha acesso. 

```dockerfile
FROM nginx:latest
COPY html /usr/share/nginx/html
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
```

O *Dockerfile* descrito acima configura uma imagem do *nginx* com um arquivo `HTML`. Vamos preparar ela para o push:

```bash
docker build -t <usuarioDockerHub>/nginx-fullcycle .
```

Rodando imagem: 

```bash
docker run --rm -d -p 8080:80 <usuarioDockerHub>/nginx-fullcycle
```

Acessando o `dockerhub` no terminal e enviando a imagem:

```bash
docker login
docker push <usuarioDockerHub>/nginx-fullcycle
```

